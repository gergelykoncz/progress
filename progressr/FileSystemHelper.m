//
//  FileSystemHelper.m
//  progressr
//
//  Created by Gergely Koncz on 20/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "FileSystemHelper.h"


@implementation FileSystemHelper

+(id)sharedHelper{
    static FileSystemHelper *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init{
    self = [super init];
    if(self){
        theCache = [NSCache new];
    }
    return self;
}

-(NSString*)getPicturesDirectory{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* picturesDirectory = [paths objectAtIndex:0];
    return picturesDirectory;
}

-(void)storeImage:(UIImage*)theImage inFolder:(NSString*)folderName{
    [self ensureFolderExists:folderName];
    
    NSString* imagePath = [[self getPicturesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.png", folderName, [self generateUniqueFileName]]];
    
    //Prevent rotation issues due to information loss
    if(!(theImage.imageOrientation == UIImageOrientationUp ||
       theImage.imageOrientation == UIImageOrientationUpMirrored)){
        CGSize imageSize = theImage.size;
        UIGraphicsBeginImageContext(imageSize);
        [theImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    NSData* imageData = UIImagePNGRepresentation(theImage);
    if(![imageData writeToFile:imagePath atomically:YES]){
        NSLog(@"Totally failed");
    }
    else{
        NSLog(@"Great success!");
    }
    
}

-(NSArray*)getImagesFromFolder:(NSString*)folderName{
    [self ensureFolderExists:folderName];
    
    NSString* fullPath = [[self getPicturesDirectory] stringByAppendingPathComponent:folderName];
    NSError* contentError = nil;
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:&contentError];
    if(contentError){
        NSLog(@"%@", [contentError description]);
    }
    
    return contents;
}

-(void)ensureFolderExists:(NSString*)folderName{
        NSString* fullPath = [[self getPicturesDirectory] stringByAppendingPathComponent:folderName];
    BOOL isDir = NO;
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]){
        NSError* createError = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:fullPath withIntermediateDirectories:NO attributes:nil error:&createError];
        
        if(createError){
            NSLog(@"%@", [createError description]);
        }
    }
}

-(UIImage*)getImageFromFolder:(NSString*)folderName named:(NSString*)fileName{
    UIImage* cachedImage = [theCache objectForKey:fileName];
    if(cachedImage){
        return cachedImage;
    }
    
    [self ensureFolderExists:folderName];
    NSString* imagePath = [[self getPicturesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", folderName, fileName]];
    UIImage* result = [UIImage imageWithContentsOfFile:imagePath];
    if(result){
        [theCache setObject:result forKey:fileName];
    }
    return result;
}

-(UIImage*)getThumbnailForFolder:(NSString*)folderName{
    [self ensureFolderExists:folderName];
    NSString* fileName = [[self getImagesFromFolder:folderName] lastObject];
    NSString* imagePath = [[self getPicturesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", folderName, fileName]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
        //TODO: return default image
    }
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

-(void)deleteImageFromFolder:(NSString *)folderName named:(NSString *)fileName{
    [self ensureFolderExists:folderName];
    NSString* imagePath = [[self getPicturesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", folderName, fileName]];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    
    [theCache removeObjectForKey:fileName];
}

-(NSString*)generateUniqueFileName{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
