//
//  FoldersViewController.h
//  progressr
//
//  Created by Gergely Koncz on 20/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoldersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>{
    NSArray* folders;
    NSString* targetFolder;
    
    NSString* folderToDelete;
    NSIndexPath* rowToDelete;
}

@property(nonatomic, weak) IBOutlet UITableView* theTableView;
-(IBAction)addFolder:(id)sender;

@end
