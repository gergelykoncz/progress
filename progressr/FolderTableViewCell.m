//
//  FolderTableViewCell.m
//  progressr
//
//  Created by Gergely Koncz on 26/09/2015.
//  Copyright (c) 2015 Gergely Koncz. All rights reserved.
//

#import "FolderTableViewCell.h"

@implementation FolderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if(highlighted){
        self.contentView.backgroundColor = [UIColor colorWithRed:0.75f green:0.22f blue:0.16f alpha:1.0f];
        self.theTextView.textColor = [UIColor whiteColor];
    }
    else{
        self.theTextView.textColor = [UIColor colorWithRed:.26f green:.26f blue:.26f alpha:1.0f];
    }
}

@end
