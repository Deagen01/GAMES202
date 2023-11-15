#include "denoiser.h"
#include <iostream>
Denoiser::Denoiser() : m_useTemportal(false) {}

void Denoiser::Reprojection(const FrameInfo &frameInfo) {
    int height = m_accColor.m_height;
    int width = m_accColor.m_width;
    Matrix4x4 preWorldToScreen =
        m_preFrameInfo.m_matrix[m_preFrameInfo.m_matrix.size() - 1];
    Matrix4x4 preWorldToCamera =
        m_preFrameInfo.m_matrix[m_preFrameInfo.m_matrix.size() - 2];
#pragma omp parallel for
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            // TODO: Reproject
            Float3 pos_world = frameInfo.m_position(x,y);
            int id = frameInfo.m_id(x,y);
            if(id==-1){
                continue;
            }
            Matrix4x4 curWorldToObj = 
            frameInfo.m_matrix[id]; 
            Matrix4x4 invCurWorldToObj = Inverse(curWorldToObj);      
            Matrix4x4 preObjToWorld = m_preFrameInfo.m_matrix[id]; 
            //Float3 pre_pos_screen = preWorldToScreen*preObjToWorld*invCurWorldToObj;
            Float3 pre_pos_screen = invCurWorldToObj(pos_world,Float3::EType::Point);
            pre_pos_screen = preObjToWorld(pre_pos_screen,Float3::EType::Point);
            pre_pos_screen = preWorldToScreen(pre_pos_screen,Float3::EType::Point);
            //检查合法

            if(pre_pos_screen.x>=0 && pre_pos_screen.x<width 
            && pre_pos_screen.y>=0 && pre_pos_screen.y<height
            && m_preFrameInfo.m_id(pre_pos_screen.x,pre_pos_screen.y)==id){
                m_valid(x, y) = true;
                m_misc(x, y) = m_accColor(pre_pos_screen.x,pre_pos_screen.y);
            }
            else{
                m_valid(x, y) = false;
                m_misc(x, y) = Float3(0.f);
            }
            
        }
    }
    std::swap(m_misc, m_accColor);
}

void Denoiser::TemporalAccumulation(const Buffer2D<Float3> &curFilteredColor) {
    int height = m_accColor.m_height;
    int width = m_accColor.m_width;
    int kernelRadius = 3;
#pragma omp parallel for
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            // TODO: Temporal clamp
            Float3 color = m_accColor(x, y);
            // TODO: Exponential moving average
            float alpha = 1.0f;

            if (m_valid(x, y)) {
                alpha = m_alpha;

                int x_start = std::max(0, x - kernelRadius);
                int x_end = std::min(width - 1, x + kernelRadius);
                int y_start = std::max(0, y - kernelRadius);
                int y_end = std::min(height - 1, y + kernelRadius);

                Float3 mu(0.f);
                Float3 sigma(0.f);

                for (int m = x_start; m <= x_end; m++) {
                    for (int n = y_start; n <= y_end; n++) {
                        mu += curFilteredColor(m, n);
                        sigma += Sqr(curFilteredColor(x, y) - curFilteredColor(m, n));
                    }
                }

                int count = kernelRadius * 2 + 1;
                count *= count;

                mu /= float(count);
                sigma = SafeSqrt(sigma / float(count));
                color = Clamp(color, mu - sigma * m_colorBoxK, mu + sigma * m_colorBoxK);
            }

            m_misc(x, y) = Lerp(color, curFilteredColor(x, y), alpha);
        }
    }
    std::swap(m_misc, m_accColor);
}



Buffer2D<Float3> Denoiser::Filter(const FrameInfo &frameInfo) {
    int height = frameInfo.m_beauty.m_height;
    int width = frameInfo.m_beauty.m_width;
    Buffer2D<Float3> filteredImage = CreateBuffer2D<Float3>(width, height);
    int kernelRadius = 16;
    Float3 color = Float3(0);
#pragma omp parallel for
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            // TODO: Joint bilateral filter
            int x_start = std::max(0, x - kernelRadius);
            int x_end = std::min(width - 1, x + kernelRadius);
            int y_start = std::max(0, y - kernelRadius);
            int y_end = std::min(height - 1, y + kernelRadius);

            auto center_postion = frameInfo.m_position(x, y);
            auto center_normal = frameInfo.m_normal(x, y);
            auto center_color = frameInfo.m_beauty(x, y);

            Float3 final_color;
            auto total_weight = .0f;

            for (int m = x_start; m <= x_end; m++) {
                for (int n = y_start; n <= y_end; n++) {

                    auto postion = frameInfo.m_position(m, n);
                    auto normal = frameInfo.m_normal(m, n);
                    auto color = frameInfo.m_beauty(m, n);

                    auto d_position = SqrDistance(center_postion, postion) /
                                      (2.0f * m_sigmaCoord * m_sigmaCoord);
                    auto d_color = SqrDistance(center_color, color) /
                                   (2.0f * m_sigmaColor * m_sigmaColor);
                    auto d_normal = SafeAcos(Dot(center_normal, normal));
                    d_normal *= d_normal;
                    d_normal / (2.0f * m_sigmaNormal * m_sigmaNormal);

                    float d_plane = .0f;
                    if (d_position > 0.f) {
                        d_plane = Dot(center_normal, Normalize(postion - center_postion));
                    }
                    d_plane *= d_plane;
                    d_plane /= (2.0f * m_sigmaPlane * m_sigmaPlane);

                    float weight = std::exp(-d_plane - d_position - d_color - d_normal);
                    total_weight += weight;
                    final_color += color * weight;
                }
            }

            filteredImage(x, y) = final_color / total_weight;
            // filteredImage(x, y) = frameInfo.m_beauty(x,y);
        }
    }
    return filteredImage;
}


void Denoiser::Init(const FrameInfo &frameInfo, const Buffer2D<Float3> &filteredColor) {
    m_accColor.Copy(filteredColor);
    int height = m_accColor.m_height;
    int width = m_accColor.m_width;
    m_misc = CreateBuffer2D<Float3>(width, height);
    m_valid = CreateBuffer2D<bool>(width, height);
}

void Denoiser::Maintain(const FrameInfo &frameInfo) { m_preFrameInfo = frameInfo; }

Buffer2D<Float3> Denoiser::ProcessFrame(const FrameInfo &frameInfo) {
    // Filter current frame
    Buffer2D<Float3> filteredColor;
    filteredColor = Filter(frameInfo);
    // std::cout<<"denois over"<<std::endl;
    // Reproject previous frame color to current
    if (m_useTemportal) {
        Reprojection(frameInfo);
        // std::cout<<"Reprojection over"<<std::endl;
        TemporalAccumulation(filteredColor);
        // std::cout<<"TemporalAccumulation"<<std::endl;
    } else {
        Init(frameInfo, filteredColor);
    }

    // Maintain
    Maintain(frameInfo);
    if (!m_useTemportal) {
        m_useTemportal = true;
    }
    return m_accColor;
}
