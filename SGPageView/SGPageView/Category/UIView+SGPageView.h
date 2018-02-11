//
//  UIView+SGPageView.h
//  SGPageView
//
//  Created by 刘山国 on 2018/2/11.
//  Copyright © 2018年 山国. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SGPageView)

@property (nonatomic,assign) NSInteger pageViewIndex;
@property (nonatomic,copy  ) NSURL     *webViewUrl;

@end
