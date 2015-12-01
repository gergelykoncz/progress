//
//  FolderManager.h
//  progressr
//
//  Created by Gergely Koncz on 21/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FolderManager : NSObject

+ (id)sharedManager;

-(NSMutableArray*)getFolders;
-(void)addFolder:(NSString*)name;
-(void)removeFolder:(NSString*)name;

@end
