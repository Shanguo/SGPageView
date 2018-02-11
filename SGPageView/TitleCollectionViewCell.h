//
//  TitleCollectionViewCell.h
//  SGPageView
//
//  Created by 刘山国 on 2018/2/10.
//  Copyright © 2018年 山国. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kTitleCollectionViewCellID = @"TitleCollectionViewCell";

@interface TitleCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
