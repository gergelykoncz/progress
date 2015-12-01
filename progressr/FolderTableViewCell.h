//
//  FolderTableViewCell.h
//  progressr
//
//  Created by Gergely Koncz on 26/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderTableViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UIImageView* theImage;
@property(nonatomic, retain) IBOutlet UITextView* theTextView;

@end
