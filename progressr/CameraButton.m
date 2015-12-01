//
//  CameraButton.m
//  progressr
//
//  Created by Gergely Koncz on 27/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "CameraButton.h"

@implementation CameraButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextFillEllipseInRect(contextRef, rect);
    CGContextSetRGBStrokeColor(contextRef, 0.0f, 0.0f, 0.0f, 1.0f);
    CGContextSetLineWidth(contextRef, 2);
    
    CGRect innerRect = CGRectMake(5, 5, rect.size.width - 10, rect.size.height -10);
    CGContextStrokeEllipseInRect(contextRef, innerRect);
}


@end
