//
//  NewFolderViewController.m
//  progressr
//
//  Created by Gergely Koncz on 21/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "NewFolderViewController.h"
#import "FolderManager.h"

@interface NewFolderViewController ()

@end

@implementation NewFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.theTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)readyButtonTapped:(id)sender{
    if([self newFolderAdded]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)newFolderAdded{
    if([self.theTextField.text isEqualToString:@""]){
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please add a name for your collection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return NO;
    }
    
    NSArray* folders = [[FolderManager sharedManager] getFolders];
    if([folders containsObject:self.theTextField.text]){
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"You already have a collection with that name!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return NO;
    }
    
    [[FolderManager sharedManager] addFolder:self.theTextField.text];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([self newFolderAdded]){
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

@end
