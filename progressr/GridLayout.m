//
//  GridLayout.m
//  progressr
//
//  Created by Gergely Koncz on 24/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "GridLayout.h"

@implementation GridLayout

-(id)initWithSize:(CGSize)size{
    self = [super init];
    if(self){
        self.itemSize = size;
        self.minimumLineSpacing = 5.0f;
    }
    return self;
}

@end
