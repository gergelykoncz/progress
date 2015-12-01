//
//  FileCollectionViewCell.m
//  progressr
//
//  Created by Gergely Koncz on 20/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "FileCollectionViewCell.h"

@implementation FileCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"FileCollectionViewCell" owner:self options:nil];
        if([views count] < 1){
            return nil;
        }
        
        if(![[views objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        
        self = [views objectAtIndex:0];
    }
    return self;
}

@end
