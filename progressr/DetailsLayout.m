//
//  DetailsLayout.m
//  progressr
//
//  Created by Gergely Koncz on 24/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "DetailsLayout.h"

@implementation DetailsLayout

-(id)initWithSize:(CGSize) size{
    self = [super init];
    if(self){
        self.itemSize = size;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 0.0f;
        
    }
    return self;
}

@end
