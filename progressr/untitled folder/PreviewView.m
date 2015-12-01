//
//  PreviewView.m
//  progressr
//
//  Created by Gergely Koncz on 20/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "PreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation PreviewView

+(Class)layerClass{
    return [AVCaptureVideoPreviewLayer class];
}

-(AVCaptureSession*)session{
    AVCaptureVideoPreviewLayer* previewLayer = (AVCaptureVideoPreviewLayer*)self.layer;
    return previewLayer.session;
}

-(void)setSession:(AVCaptureSession *)session{
    AVCaptureVideoPreviewLayer* previewLayer = (AVCaptureVideoPreviewLayer*)self.layer;
    previewLayer.session = session;
}

@end
