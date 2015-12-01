//
//  FoldersViewController.m
//  progressr
//
//  Created by Gergely Koncz on 20/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "FoldersViewController.h"
#import "FilesViewController.h"
#import "FileSystemHelper.h"
#import "FolderManager.h"
#import "FolderTableViewCell.h"

@interface FoldersViewController ()

@end

@implementation FoldersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    folders =[[FolderManager sharedManager] getFolders];
}

-(void)viewWillAppear:(BOOL)animated{
    folders =[[FolderManager sharedManager] getFolders];
    [self.theTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)addFolder:(id)sender{
    [[FolderManager sharedManager] addFolder:@"Folder"];
    folders =[[FolderManager sharedManager] getFolders];
    [self.theTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [folders count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FolderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"];
    cell.theTextView.text = [folders objectAtIndex:indexPath.row];
    UIImage* thumbnail = [[FileSystemHelper sharedHelper] getThumbnailForFolder:[folders objectAtIndex:indexPath.row]];
    if(!thumbnail){
        thumbnail = [UIImage imageNamed:@"Placeholder"];
    }
    cell.theImage.image = thumbnail;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    targetFolder = [folders objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShowFiles" sender:self];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString* folderName = [folders objectAtIndex:indexPath.row];
        NSArray* itemsInFolder = [[FileSystemHelper sharedHelper] getImagesFromFolder:folderName];
        if([itemsInFolder count] == 0){
            [[FolderManager sharedManager] removeFolder:folderName];
        
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
            folders =[[FolderManager sharedManager] getFolders];
            
        }
        else{
            folderToDelete = folderName;
            rowToDelete = indexPath;
            [[[UIActionSheet alloc] initWithTitle:@"This folder contains pictures. Deleting it will remove them from all of your devices." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete folder anyway" otherButtonTitles:nil]showFromRect:CGRectMake(0, 320, self.view.bounds.size.width, self.view.bounds.size.height) inView:self.view animated:YES];
        }
    }
    [tableView endUpdates];
    [tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ShowFiles"]){
        ((FilesViewController*)segue.destinationViewController).folderName = targetFolder;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self.theTableView beginUpdates];
        [[FolderManager sharedManager] removeFolder:folderToDelete];
        [self.theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:rowToDelete, nil] withRowAnimation:UITableViewRowAnimationTop];
        folders =[[FolderManager sharedManager] getFolders];
        [self.theTableView endUpdates];
        [self.theTableView reloadData];
    }
}

@end
