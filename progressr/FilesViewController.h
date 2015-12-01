//
//  FilesViewController.h
//  progressr
//
//  Created by Gergely Koncz on 20/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"
#import "GridLayout.h"
#import "DetailsLayout.h"
#import "FileDatasource.h"

@interface FilesViewController : UIViewController<UICollectionViewDelegate, CameraViewControllerDelegate, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>{
    NSString* selectedFile;
    NSDateFormatter* fileNameFormatter;
    NSDateFormatter* outputFormatter;
}

@property(nonatomic, retain) NSString* folderName;
@property(nonatomic, weak) IBOutlet UICollectionView* theCollectionView;
@property(nonatomic, weak) IBOutlet UIToolbar* toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem* deleteItem;
@property(nonatomic, weak) IBOutlet UIBarButtonItem* shareItem;
@property(nonatomic, weak) IBOutlet UIView* emptyView;
@property(nonatomic, retain) FileDatasource* fileDatasource;

@property(nonatomic, retain) GridLayout* gridLayout;
@property(nonatomic, retain) DetailsLayout* detailsLayout;
@property(nonatomic, assign) BOOL isInDetailsMode;
-(IBAction)takePicture:(id)sender;
-(IBAction)deleteFile:(id)sender;
-(IBAction)sharePhoto:(id)sender;

@end
