//
//  NSObject+OpenCVWrapper.m
//  WarmCoolerDetect
//
//  Created by Irvan P. Saragi on 01/03/25.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation OpenCVWrapper

- (UIImage *)adjustTemperature:(UIImage *)image temperature:(float)temperature {
    // Convert UIImage to cv::Mat
    cv::Mat inputMat;
    UIImageToMat(image, inputMat);
    
    // Convert RGBA to BGR
    cv::Mat bgrMat;
    cv::cvtColor(inputMat, bgrMat, cv::COLOR_RGBA2BGR);
    
    // Split the channels
    std::vector<cv::Mat> channels;
    cv::split(bgrMat, channels);
    
    // Normalized temperature value (-1.0 to 1.0)
    float normalizedTemp = temperature / 100.0f;
    
    // Apply temperature adjustment
    if (normalizedTemp < 0) {
        // Cooler: increase blue, decrease red
        channels[0] *= (1.0f - normalizedTemp * 0.3f); // Blue
        channels[2] *= (1.0f + normalizedTemp * 0.5f); // Red
    } else if (normalizedTemp > 0) {
        // Warmer: increase red, decrease blue
        channels[2] *= (1.0f + normalizedTemp * 0.5f); // Red
        channels[0] *= (1.0f - normalizedTemp * 0.3f); // Blue
    }
    
    // Merge the channels
    cv::Mat adjustedBGR;
    cv::merge(channels, adjustedBGR);
    
    // Convert back to RGBA
    cv::Mat adjustedRGBA;
    cv::cvtColor(adjustedBGR, adjustedRGBA, cv::COLOR_BGR2RGBA);
    
    // Convert back to UIImage
    return MatToUIImage(adjustedRGBA);
}

@end
