//
//  TitleCollectionViewCell.m
//  SGPageView
//
//  Created by 刘山国 on 2018/2/10.
//  Copyright © 2018年 山国. All rights reserved.
//

#import "TitleCollectionViewCell.h"

@implementation TitleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self.titleLabel setBackgroundColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:153/255.0 alpha:1]];
        
    } else {
        [self.titleLabel setBackgroundColor:[UIColor whiteColor]];
    }
}

@end
