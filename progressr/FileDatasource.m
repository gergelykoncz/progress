//
//  FileDatasource.m
//  progressr
//
//  Created by Gergely Koncz on 26/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "FileDatasource.h"
#import "FileSystemHelper.h"
#import "FileCollectionViewCell.h"

@implementation FileDatasource

-(id)initWithFolder:(NSString*)folder{
    self = [super init];
    if(self){
        self.folderName = folder;
        self.files = [[FileSystemHelper sharedHelper] getImagesFromFolder:folder];
    }
    return self;
}

-(void)update{
    self.files = [[FileSystemHelper sharedHelper] getImagesFromFolder:self.folderName];
}

-(NSString*)fileAtIndex:(NSUInteger)index{
    return [self.files objectAtIndex:index];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.files count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FileCollectionViewCell* cell = (FileCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"photoFileCell" forIndexPath:indexPath];
    cell.imageView.image = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage* theImage = [[FileSystemHelper sharedHelper] getImageFromFolder:self.folderName named:[self.files objectAtIndex:indexPath.row]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = theImage;
        });
    });
    
    return cell;
}

@end
