//
//  FileDatasource.h
//  progressr
//
//  Created by Gergely Koncz on 26/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FileDatasource : NSObject<UICollectionViewDataSource>

-(id)initWithFolder:(NSString*)folder;
-(void)update;
-(NSString*)fileAtIndex:(NSUInteger)index;

@property(nonatomic, retain) NSArray* files;
@property(nonatomic, retain) NSString* folderName;

@end
