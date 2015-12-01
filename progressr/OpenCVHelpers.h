//
//  OpenCVHelpers.h
//  progressr
//
//  Created by Gergely Koncz on 19/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/imgproc.hpp>

@interface OpenCVHelpers : NSObject

+(cv::Mat)cvMatFromUIImage:(UIImage*)image;
+(UIImage*)UIImageFromCVMat:(cv::Mat)cvMat withOrientation:(UIImageOrientation)orientation;
+(UIImage*)doMagic:(UIImage*) imageToMagic withThreshold:(int)threshold;

@end
