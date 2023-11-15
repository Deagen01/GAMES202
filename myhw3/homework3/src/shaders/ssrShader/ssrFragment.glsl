#ifdef GL_ES
precision highp float;
#endif

uniform vec3 uLightDir;
uniform vec3 uCameraPos;
uniform vec3 uLightRadiance;
uniform sampler2D uGDiffuse;
uniform sampler2D uGDepth;
uniform sampler2D uGNormalWorld;
uniform sampler2D uGShadow;
uniform sampler2D uGPosWorld;

varying mat4 vWorldToScreen;
varying highp vec4 vPosWorld;

#define M_PI 3.1415926535897932384626433832795
#define TWO_PI 6.283185307
#define INV_PI 0.31830988618
#define INV_TWO_PI 0.15915494309

float Rand1(inout float p) {
  p = fract(p * .1031);
  p *= p + 33.33;
  p *= p + p;
  return fract(p);
}

vec2 Rand2(inout float p) {
  return vec2(Rand1(p), Rand1(p));
}

float InitRand(vec2 uv) {
	vec3 p3  = fract(vec3(uv.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}

vec3 SampleHemisphereUniform(inout float s, out float pdf) {
  vec2 uv = Rand2(s);
  float z = uv.x;
  float phi = uv.y * TWO_PI;
  float sinTheta = sqrt(1.0 - z*z);
  vec3 dir = vec3(sinTheta * cos(phi), sinTheta * sin(phi), z);
  pdf = INV_TWO_PI;
  return dir;
}

vec3 SampleHemisphereCos(inout float s, out float pdf) {
  vec2 uv = Rand2(s);
  float z = sqrt(1.0 - uv.x);
  float phi = uv.y * TWO_PI;
  float sinTheta = sqrt(uv.x);
  vec3 dir = vec3(sinTheta * cos(phi), sinTheta * sin(phi), z);
  pdf = z * INV_PI;
  return dir;
}

void LocalBasis(vec3 n, out vec3 b1, out vec3 b2) {
  float sign_ = sign(n.z);
  if (n.z == 0.0) {
    sign_ = 1.0;
  }
  float a = -1.0 / (sign_ + n.z);
  float b = n.x * n.y * a;
  b1 = vec3(1.0 + sign_ * n.x * n.x * a, sign_ * b, -sign_ * n.x);
  b2 = vec3(b, sign_ + n.y * n.y * a, -n.y);
}

vec4 Project(vec4 a) {
  return a / a.w;
}
//深度值不等于世界坐标的z值
float GetDepth(vec3 posWorld) {
  float depth = (vWorldToScreen * vec4(posWorld, 1.0)).w;
  return depth;
}

/*
 * Transform point from world space to screen space([0, 1] x [0, 1])
 *
 */
vec2 GetScreenCoordinate(vec3 posWorld) {
  vec2 uv = Project(vWorldToScreen * vec4(posWorld, 1.0)).xy * 0.5 + 0.5;
  return uv;
}

float GetGBufferDepth(vec2 uv) {
  float depth = texture2D(uGDepth, uv).x;
  if (depth < 1e-2) {
    depth = 1000.0;
  }
  return depth;
}

vec3 GetGBufferNormalWorld(vec2 uv) {
  vec3 normal = texture2D(uGNormalWorld, uv).xyz;
  return normal;
}

vec3 GetGBufferPosWorld(vec2 uv) {
  vec3 posWorld = texture2D(uGPosWorld, uv).xyz;
  return posWorld;
}

float GetGBufferuShadow(vec2 uv) {
  float visibility = texture2D(uGShadow, uv).x;
  return visibility;
}

vec3 GetGBufferDiffuse(vec2 uv) {
  vec3 diffuse = texture2D(uGDiffuse, uv).xyz;
  diffuse = pow(diffuse, vec3(2.2));
  return diffuse;
}

/*
 * Evaluate diffuse bsdf value.
 *
 * wi, wo are all in world space.
 * uv is in screen space, [0, 1] x [0, 1].
 *
 */
vec3 EvalDiffuse(vec3 wi, vec3 wo, vec2 uv) {

  vec3 albedo = GetGBufferDiffuse(uv);
  //渲染方程中除了光照之外的项
  vec3 normal = GetGBufferNormalWorld(uv);
  float cos = max(0.,dot(normal,wi));
  //漫反射的BRDF是rou/pi
  return albedo*cos*INV_PI;
}

/*
 * Evaluate directional light with shadow map
 * uv is in screen space, [0, 1] x [0, 1].
 *
 */
vec3 EvalDirectionalLight(vec2 uv) {
  vec3 Le = vec3(0.0);
  float visability = GetGBufferuShadow(uv);
  Le = uLightRadiance*visability;
  return Le;
}


//屏幕空间下的光线求交


bool RayMarch(vec3 ori, vec3 dir, out vec3 hitPos) {
  
  const int maxSteps = 100;
  float len = 1.0;
  vec3 ray = ori;
  for(int i=0;i<maxSteps;i+=1){
    ray = ray + dir*len;
    vec2 uv= GetScreenCoordinate(ray);
    float depth_screen = GetGBufferDepth(uv);
    float depth_ray = GetDepth(ray);
    //如果光线的深度比屏幕深度更深 则相交
    if(depth_screen-depth_ray<=0.0001){
      hitPos = ray;
      return true;
    }
  }
  
  
  return false;
}

//测试SSR
//镜面反射材质
vec3 EvaluateReflect(vec3 ori,vec3 dir){
  
  vec3 hitPos;
  bool hit = RayMarch(ori,dir,hitPos);
  if(hit){
    vec2 hituv=GetScreenCoordinate(hitPos);
    vec3 f = GetGBufferDiffuse(hituv);
    return f;
  }
  return vec3(0.);

}


#define SAMPLE_NUM 10

void main() {
  float s = InitRand(gl_FragCoord.xy);
  vec3 vPos = vec3(vPosWorld.xyz/vPosWorld.w);
  vec2 uv = GetScreenCoordinate(vPos);
  vec3 wi = uLightDir;
  vec3 wo = normalize(uCameraPos-vPos);
  vec3 normal = GetGBufferNormalWorld(uv);

  vec3 L = vec3(0.0);
  vec3 L_indir = vec3(0.0);
  float pdf = 0.;
  vec3 hitPos,b1,b2;
  
  LocalBasis(normal,b1,b2);
  
  for(int i=0;i<SAMPLE_NUM;i++){
    //采样得到的是局部坐标下的
    vec3 dir_local = SampleHemisphereUniform(s,pdf);
    vec3 dir = normalize(mat3(b1, b2, normal) * dir_local);
    dir = normalize(dir);
    bool hit = RayMarch(vPos,dir,hitPos);
    if(hit){
      //对于shading point来说入射光是二次反射的光线方向dir
      vec3 f0 = EvalDiffuse(dir,wo,uv);
      vec2 uv_1 = GetScreenCoordinate(hitPos);
      //对于采样点来说 入射光是方向光wi
      vec3 f1 = EvalDiffuse(wi,dir,uv_1);
      //光线首先打到采样点再弹射到shading point上 所以是uv_1
      vec3 L_cur = f0*f1*EvalDirectionalLight(uv_1)/pdf;
      L_indir+=L_cur;

    }
  }
  //间接光照
  L_indir = L_indir/float(SAMPLE_NUM);
  //直接光照
  //L = GetGBufferDiffuse(GetScreenCoordinate(vPosWorld.xyz));
  L = EvalDiffuse(wi,wo,uv)*EvalDirectionalLight(uv);
  L=L+L_indir;

  //测试SSR
  //vec3 reflect_dir = reflect(-wo,normal);
  //reflect_dir = normalize(reflect_dir);
  //L = GetGBufferDiffuse(uv)+EvaluateReflect(vPos,reflect_dir);


  vec3 color = pow(clamp(L, vec3(0.0), vec3(1.0)), vec3(1.0 / 2.2));
  gl_FragColor = vec4(vec3(color.rgb), 1.0);
}
