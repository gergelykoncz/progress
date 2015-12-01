//
//  FilesViewController.m
//  progressr
//
//  Created by Gergely Koncz on 20/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "FilesViewController.h"
#import "FileSystemHelper.h"
#import "OpenCVHelpers.h"
#import "FileCollectionViewCell.h"
#import "FileDatasource.h"

@interface FilesViewController ()

@end

@implementation FilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.folderName;
    self.fileDatasource = [[FileDatasource alloc] initWithFolder:self.folderName];
    self.theCollectionView.dataSource = self.fileDatasource;
    
    CGFloat gridSize = self.view.bounds.size.width / 3.0f - 7;
    self.gridLayout = [[GridLayout alloc] initWithSize:CGSizeMake(gridSize, gridSize)];
    self.detailsLayout = [[DetailsLayout alloc] initWithSize:self.view.bounds.size];
    [self.theCollectionView registerClass:[FileCollectionViewCell class] forCellWithReuseIdentifier:@"photoFileCell"];
    
    //Details view title date formatters
    fileNameFormatter = [NSDateFormatter new];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [fileNameFormatter setLocale:enUSPOSIXLocale];
    [fileNameFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [fileNameFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    outputFormatter = [NSDateFormatter new];
    [outputFormatter setDateStyle:NSDateFormatterMediumStyle];
    [outputFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [self setUpGridMode];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.emptyView.hidden = [self.fileDatasource.files count];
    self.theCollectionView.hidden = !self.emptyView.hidden;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.theCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.isInDetailsMode){
        selectedFile = [self.fileDatasource fileAtIndex:indexPath.row];
        [self setUpDetailsMode];
        [self displayTitleForFile:selectedFile];
    }
    else{
        BOOL currentState = self.toolbar.hidden;
        [self.toolbar setHidden:!currentState];
        [self.navigationController setNavigationBarHidden:!currentState];
        [[UIApplication sharedApplication] setStatusBarHidden:!currentState];
    }
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isInDetailsMode){
        selectedFile = [self.fileDatasource fileAtIndex:indexPath.row];
        [self displayTitleForFile:selectedFile];
        ((FileCollectionViewCell*)cell).imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else{
        ((FileCollectionViewCell*)cell).imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

-(void)setUpDetailsMode{
    self.isInDetailsMode = YES;
    [self.theCollectionView.collectionViewLayout invalidateLayout];
    [self.theCollectionView setCollectionViewLayout:self.detailsLayout animated:YES];
    [self.theCollectionView setPagingEnabled:YES];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Caret"] style:UIBarButtonItemStylePlain target:self action:@selector(setUpGridMode)]];
    [self.deleteItem setEnabled:YES];
    [self.shareItem setEnabled:YES];
}

-(void)setUpGridMode{
    self.isInDetailsMode = NO;
    [self.theCollectionView.collectionViewLayout invalidateLayout];
    [self.theCollectionView setCollectionViewLayout:self.gridLayout animated:YES];
    [self.theCollectionView setPagingEnabled:NO];
    [self.navigationItem setHidesBackButton:NO];
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.deleteItem setEnabled:NO];
    [self.shareItem setEnabled:NO];
    self.title = self.folderName;
}

-(void)displayTitleForFile:(NSString*)fileName{
    NSUInteger dotPosition = [fileName rangeOfString:@"."].location;
    fileName = [fileName substringToIndex:dotPosition];
    NSDate* parsedDate = [fileNameFormatter dateFromString:fileName];
    
    self.title = [outputFormatter stringFromDate:parsedDate];
}

-(IBAction)takePicture:(id)sender{
    [self performSegueWithIdentifier:@"TakePicture" sender:self];
}

-(IBAction)deleteFile:(id)sender{
    [[[UIActionSheet alloc] initWithTitle:@"This photo will be deleted from Progressr on all your devices." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:nil] showFromToolbar:self.toolbar];
}

-(IBAction)sharePhoto:(id)sender{
    UIImage* imageToShare = [[FileSystemHelper sharedHelper] getImageFromFolder:self.folderName named:selectedFile];
    UIActivityViewController* activityVc = [[UIActivityViewController alloc] initWithActivityItems:@[imageToShare] applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [self presentViewController:activityVc animated:YES completion:nil];
    }
    else{
        UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:activityVc];
        [popover presentPopoverFromBarButtonItem:self.shareItem permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [[FileSystemHelper sharedHelper] deleteImageFromFolder:self.folderName named:selectedFile];
        [self.fileDatasource update];
        [self.theCollectionView reloadData];
        [self setUpGridMode];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"TakePicture"]){
        UIImage* lastImage =[[FileSystemHelper sharedHelper] getThumbnailForFolder:self.folderName];
        CameraViewController* camVc = ((CameraViewController*)segue.destinationViewController);
        if(lastImage){
            camVc.overlay = [OpenCVHelpers doMagic:lastImage withThreshold:50];
        }
        camVc.folderName = self.folderName;
        camVc.delegate = self;
    }
}

-(void)didTakePicture:(UIImage *)theImage{
    [[FileSystemHelper sharedHelper] storeImage:theImage inFolder:self.folderName];
    [self.fileDatasource update];
    [self.theCollectionView reloadData];
}

@end
