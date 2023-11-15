//L不是9×3吗？为什么是用mat3？
//用3个mat3表示？
//LT是1×9 作为3×3传入
attribute mat3 aPrecomputeLT;

attribute vec3 aVertexPosition;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;

uniform mat3 uPrecomputeLR;
uniform mat3 uPrecomputeLG;
uniform mat3 uPrecomputeLB;

varying highp vec3 vColor;


void main(void) {

  float colorR = 0.;
  float colorG = 0.;
  float colorB = 0.;

  colorR = 
  uPrecomputeLR[0][0]*aPrecomputeLT[0][0]+
  uPrecomputeLR[0][1]*aPrecomputeLT[0][1]+
  uPrecomputeLR[0][2]*aPrecomputeLT[0][2]+
  uPrecomputeLR[1][0]*aPrecomputeLT[1][0]+
  uPrecomputeLR[1][1]*aPrecomputeLT[1][1]+
  uPrecomputeLR[1][2]*aPrecomputeLT[1][2]+
  uPrecomputeLR[2][0]*aPrecomputeLT[2][0]+
  uPrecomputeLR[2][1]*aPrecomputeLT[2][1]+
  uPrecomputeLR[2][2]*aPrecomputeLT[2][2];
  colorG = 
  uPrecomputeLG[0][0]*aPrecomputeLT[0][0]+
  uPrecomputeLG[0][1]*aPrecomputeLT[0][1]+
  uPrecomputeLG[0][2]*aPrecomputeLT[0][2]+
  uPrecomputeLG[1][0]*aPrecomputeLT[1][0]+
  uPrecomputeLG[1][1]*aPrecomputeLT[1][1]+
  uPrecomputeLG[1][2]*aPrecomputeLT[1][2]+
  uPrecomputeLG[2][0]*aPrecomputeLT[2][0]+
  uPrecomputeLG[2][1]*aPrecomputeLT[2][1]+
  uPrecomputeLG[2][2]*aPrecomputeLT[2][2];

  colorB = 
  uPrecomputeLB[0][0]*aPrecomputeLT[0][0]+
  uPrecomputeLB[0][1]*aPrecomputeLT[0][1]+
  uPrecomputeLB[0][2]*aPrecomputeLT[0][2]+
  uPrecomputeLB[1][0]*aPrecomputeLT[1][0]+
  uPrecomputeLB[1][1]*aPrecomputeLT[1][1]+
  uPrecomputeLB[1][2]*aPrecomputeLT[1][2]+
  uPrecomputeLB[2][0]*aPrecomputeLT[2][0]+
  uPrecomputeLB[2][1]*aPrecomputeLT[2][1]+
  uPrecomputeLB[2][2]*aPrecomputeLT[2][2];

  vColor = vec3(colorR,colorG,colorB);
  gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix *
                vec4(aVertexPosition, 1.0);

}