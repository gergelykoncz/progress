//
//  CameraViewController.h
//  progressr
//
//  Created by Gergely Koncz on 20/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraViewControllerDelegate <NSObject>

-(void)didTakePicture:(UIImage*)image;

@end

@interface CameraViewController : UIViewController
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) UIImage* overlay;
@property (nonatomic, retain) NSString* folderName;
@end
