#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>
#include <sstream>
#include <fstream>
#include <random>
#include "vec.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION

#include "stb_image_write.h"


float Fresnel(Vec3f wi,float NdotV);

const int resolution = 128;
//采样点？方向和概率分布
typedef struct samplePoints {
    std::vector<Vec3f> directions;
	std::vector<float> PDFs;
}samplePoints;

samplePoints squareToCosineHemisphere(int sample_count){
    samplePoints samlpeList;
    const int sample_side = static_cast<int>(floor(sqrt(sample_count)));

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> rng(0.0, 1.0);
    for (int t = 0; t < sample_side; t++) {
        for (int p = 0; p < sample_side; p++) {
            double samplex = (t + rng(gen)) / sample_side;
            double sampley = (p + rng(gen)) / sample_side;
            
            double theta = 0.5f * acos(1 - 2*samplex);
            double phi =  2 * M_PI * sampley;
            Vec3f wi = Vec3f(sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta));
            //因为cos的波形符合高斯分布
            // /pi让边缘不是立马为0 而是接近0
            // 这是实际采样的概率密度函数
            float pdf = wi.z / PI;
            
            samlpeList.directions.push_back(wi);
            samlpeList.PDFs.push_back(pdf);
        }
    }
    return samlpeList;
}

float DistributionGGX(Vec3f N, Vec3f H, float roughness)
{
    float a = roughness*roughness;
    float a2 = a*a;
    float NdotH = std::max(dot(N, H), 0.0f);
    float NdotH2 = NdotH*NdotH;

    float nom   = a2;
    float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;

    return nom / std::max(denom, 0.0001f);
}

float GeometrySchlickGGX(float NdotV, float roughness) {
    float a = roughness;
    float k = (a * a) / 2.0f;

    float nom = NdotV;
    float denom = NdotV * (1.0f - k) + k;

    return nom / denom;
}

float GeometrySmith(float roughness, float NoV, float NoL) {
    float ggx2 = GeometrySchlickGGX(NoV, roughness);
    float ggx1 = GeometrySchlickGGX(NoL, roughness);

    return ggx1 * ggx2;
}

Vec3f IntegrateBRDF(Vec3f V, float roughness, float NdotV) {
    float A = 0.0;
    float B = 0.0;
    float C = 0.0;
    const int sample_count = 1024;
    //法线统一指向z轴
    Vec3f N = Vec3f(0.0, 0.0, 1.0);
    //采样1024个点 分辨率是128
    //这里假设恒定L=1的光强
    //做半球面上的积分 采样light direction
    samplePoints sampleList = squareToCosineHemisphere(sample_count);
    for (int i = 0; i < sample_count; i++) {
      // TODO: To calculate (fr * ni) / p_o here
        Vec3f H = normalize(V + sampleList.directions[i]);
        float F = Fresnel(V,NdotV);
        float pdf = sampleList.PDFs[i];
        float D_ggx = DistributionGGX(N, H, roughness);
        float G = GeometrySmith(roughness, NdotV, dot(N, sampleList.directions[i]));
        float brdf = F*D_ggx*G/(4*NdotV*dot(N, sampleList.directions[i]));
        
        //这里一个小点是 theta=L与N的夹角
        //所以sin theta如下
        float mu = dot(N,sampleList.directions[i]);
        
        A +=brdf *mu/sampleList.PDFs[i];
    }   
    B=A;
    C=A; 
    return {A / sample_count, B / sample_count, C / sample_count};
}
//菲涅尔项 我怎么知道这个RO基础反射率是多少？假设是0.4
float Fresnel(Vec3f wi,float NdotV){
    float R0 = 0.4;
    float Fc = R0 + (1.0 - R0) * pow(1.0 - NdotV, 5.0);
    return Fc;

}



int main() {
    uint8_t data[resolution * resolution * 3];
    float step = 1.0 / resolution;
    //注意不会取到resolution
    for (int i = 0; i < resolution; i++) {
        for (int j = 0; j < resolution; j++) {
            //i决定粗糙度 从0到1之间
            float roughness = step * (static_cast<float>(i) + 0.5f);
            //不一定是要实例化， 这只是打表
            //先生成costheta_o或者也可以是sintheta_o
            float NdotV = step * (static_cast<float>(j) + 0.5f);
            //V是观察方向 view direction
            //下面这个生成观察方向 默认归一化
            Vec3f V = Vec3f(std::sqrt(1.f - NdotV * NdotV), 0.f, NdotV);
            Vec3f irr = IntegrateBRDF(V, roughness, NdotV);
            //用一维数据存储二维数据
            data[(i * resolution + j) * 3 + 0] = uint8_t(irr.x * 255.0);
            data[(i * resolution + j) * 3 + 1] = uint8_t(irr.y * 255.0);
            data[(i * resolution + j) * 3 + 2] = uint8_t(irr.z * 255.0);
        }
    }
    stbi_flip_vertically_on_write(true);
    stbi_write_png("GGX_E_MC_LUT.png", resolution, resolution, 3, data, resolution * 3);
    
    std::cout << "Finished precomputed!" << std::endl;
    return 0;
}