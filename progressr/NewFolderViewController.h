//
//  NewFolderViewController.h
//  progressr
//
//  Created by Gergely Koncz on 21/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFolderViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet UITextField* theTextField;
-(IBAction)readyButtonTapped:(id)sender;

@end
