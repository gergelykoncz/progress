//
//  FolderManager.m
//  progressr
//
//  Created by Gergely Koncz on 21/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "FolderManager.h"

@implementation FolderManager

+ (id)sharedManager {
    static FolderManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(NSMutableArray*)getFolders{
    return [NSMutableArray arrayWithContentsOfFile:[self getFolderFile]];
}

-(void)addFolder:(NSString *)name{
    NSMutableArray* folders = [self getFolders];
    [folders addObject:name];
    [folders writeToFile:[self getFolderFile] atomically:NO];
}

-(void)removeFolder:(NSString *)name{
    NSMutableArray* folders = [self getFolders];
    [folders removeObject:name];
    [folders writeToFile:[self getFolderFile] atomically:NO];
}

-(NSString*)getFolderFile{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* folderFile = [documentsDirectory stringByAppendingPathComponent:@"folders.plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderFile]){
        NSArray* folders = @[@"Front Spread"];
        [folders writeToFile:folderFile atomically:NO];
    }
    return folderFile;
    
}

@end
