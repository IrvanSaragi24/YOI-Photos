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

- (UIImage *)adjustContrast:(UIImage *)image contrast:(float)contrast objectsOnly:(BOOL)objectsOnly {
    // Convert UIImage to cv::Mat
    cv::Mat inputMat;
    UIImageToMat(image, inputMat);
    
    // Convert RGBA to BGR
    cv::Mat bgrMat;
    cv::cvtColor(inputMat, bgrMat, cv::COLOR_RGBA2BGR);
    
    // Normalized contrast value
    float normalizedContrast = contrast / 100.0f;
    float factor = 1.0f + normalizedContrast;
    
    // Create result matrix (start with original image)
    cv::Mat resultBGR = bgrMat.clone();
    
    if (objectsOnly) {
        // Create a copy to apply contrast adjustment
        cv::Mat adjustedBGR;
        bgrMat.convertTo(adjustedBGR, -1, factor, 0);
        
        // Create grayscale version for object detection
        cv::Mat grayMat;
        cv::cvtColor(bgrMat, grayMat, cv::COLOR_BGR2GRAY);
        
        // Blur slightly to reduce noise
        cv::GaussianBlur(grayMat, grayMat, cv::Size(5, 5), 0);
        
        // Apply adaptive threshold to find objects
        cv::Mat threshMat;
        cv::adaptiveThreshold(grayMat, threshMat, 255,
                             cv::ADAPTIVE_THRESH_GAUSSIAN_C,
                             cv::THRESH_BINARY_INV, 11, 2);
        
        // Find contours in the thresholded image
        std::vector<std::vector<cv::Point>> contours;
        std::vector<cv::Vec4i> hierarchy;
        cv::findContours(threshMat, contours, hierarchy,
                        cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
        
        // Create mask for objects (black background)
        cv::Mat objectMask = cv::Mat::zeros(bgrMat.size(), CV_8UC1);
        
        // Draw contours on the mask (white objects)
        for (size_t i = 0; i < contours.size(); i++) {
            // Filter small contours to ignore noise
            if (cv::contourArea(contours[i]) > 200) {
                cv::drawContours(objectMask, contours, i, cv::Scalar(255), -1);
            }
        }
        
        // Dilate the mask slightly to include object edges
        cv::dilate(objectMask, objectMask,
                  cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
        
        // Only copy the adjusted pixels where the mask is white (objects)
        adjustedBGR.copyTo(resultBGR, objectMask);
    } else {
        // Apply contrast to the entire image
        bgrMat.convertTo(resultBGR, -1, factor, 0);
    }
    
    // Convert back to RGBA
    cv::Mat resultRGBA;
    cv::cvtColor(resultBGR, resultRGBA, cv::COLOR_BGR2RGBA);
    
    // Convert back to UIImage
    return MatToUIImage(resultRGBA);
}

@end
