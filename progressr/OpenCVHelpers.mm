//
//  OpenCVHelpers.m
//  progressr
//
//  Created by Gergely Koncz on 19/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "OpenCVHelpers.h"


@implementation OpenCVHelpers

+(cv::Mat)cvMatFromUIImage:(UIImage*)image{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    if(image.imageOrientation == UIImageOrientationLeft ||
       image.imageOrientation == UIImageOrientationRight){
        cols = image.size.height;
        rows = image.size.width;
    }
    
    cv::Mat cvMat(rows, cols, CV_8UC4);
    
    CGContextRef contextref = CGBitmapContextCreate(cvMat.data,
                                                    cols,
                                                    rows,
                                                    8,
                                                    cvMat.step[0],
                                                    colorSpace,
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextref, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextref);
    
    return cvMat;
}

+(UIImage*)UIImageFromCVMat:(cv::Mat)cvMat withOrientation:(UIImageOrientation)orientation{
    NSData* data  = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if(cvMat.elemSize() == 1){
        colorSpace = CGColorSpaceCreateDeviceGray();
    }
    else{
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols, cvMat.rows, 8, 8 * cvMat.elemSize(), cvMat.step[0], colorSpace, kCGImageAlphaLast | kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    
    UIImage* finalImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:orientation];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

+(UIImage*)doMagic:(UIImage*) imageToMagic withThreshold:(int)threshold{
    cv::Mat src = [OpenCVHelpers cvMatFromUIImage:imageToMagic];
    
    
    cv::Mat dst;
    cv::Mat src_gray;
    cv::Mat detected_edges;
    int lowThreshold = threshold;
    int ratio = 1;
    int kernel_size = 3;
    
    dst.create(src.size(), src.type());
    
    
    cvtColor(src, src_gray, CV_BGR2GRAY);
    
    blur(src_gray, detected_edges, cv::Size(3,3));
    Canny(detected_edges, detected_edges, lowThreshold, lowThreshold * ratio, kernel_size);
    dst = cv::Scalar::all(0);
    src.copyTo(dst, detected_edges);
    dst = cv::Scalar::all(255) - dst;
    
    cv::Mat channels[4];
    split(dst, channels);
    
    cv::Scalar min_color(0,0,0);
    cv::Scalar max_color(255,255,255,0);
    
    inRange(dst, min_color, max_color, channels[3]);
    
    cv::Mat rgba;
    cv::merge(channels, 4, rgba);
    
    
    UIImage* result = [OpenCVHelpers UIImageFromCVMat:rgba withOrientation:imageToMagic.imageOrientation];
    return result;
}

@end
