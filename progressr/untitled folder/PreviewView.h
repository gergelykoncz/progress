//
//  PreviewView.h
//  progressr
//
//  Created by Gergely Koncz on 20/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;
@interface PreviewView : UIView

@property(nonatomic, retain) AVCaptureSession *session;

@end
