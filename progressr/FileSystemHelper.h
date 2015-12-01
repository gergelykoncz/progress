//
//  FileSystemHelper.h
//  progressr
//
//  Created by Gergely Koncz on 20/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FileSystemHelper : NSObject{
    NSCache* theCache;
}

+(id)sharedHelper;

-(void)storeImage:(UIImage*)theImage inFolder:(NSString*)folderName;
-(NSArray*)getImagesFromFolder:(NSString*)folderName;
-(UIImage*)getImageFromFolder:(NSString*)folderName named:(NSString*)fileName;
-(UIImage*)getThumbnailForFolder:(NSString*)folderName;

-(void)deleteImageFromFolder:(NSString*)folderName named:(NSString*)fileName;

@end
