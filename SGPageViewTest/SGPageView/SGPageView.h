//
//  SGPageView.h
//  SGPageViewTest
//
//  Created by 刘山国 on 2016/12/22.
//  Copyright © 2016年 山国. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 滑动方向

 - SGDirctionLeft: 将要滑动到左边一页
 - SGDirctionNone: 滑动还在本页停
 - SGDirctionRigth: 将要滑动到右边一页
 */
typedef NS_ENUM(NSUInteger, SGPDirection) {
    SGDirctionLeft            = -1,
    SGDirctionNone            = 0,
    SGDirctionRigth           = 1,
};

@class SGPageView;
@protocol SGPageViewDelegate <NSObject,UIScrollViewDelegate>

/**
 滑动PageView的回调

 @param pageView SGPageView
 @param tableView UITableView
 @param index index
 @param dirction SGPDirection
 */
- (void)pageView:(SGPageView * _Nonnull)pageView dragScrollToTableView:(UITableView * _Nonnull)tableView index:(NSInteger)index direction:(SGPDirection)dirction;

@end

@protocol SGPageViewDataSource <NSObject>

@required

/**
 TableView Setting,calls when new tableView was add to view

 @param pageView SGPageView
 @param tableView UITableView
 @param index index
 */
- (void)pageView:(SGPageView *_Nonnull)pageView shouldSettingTableView:(UITableView *_Nonnull)tableView atIndex:(NSInteger)index;


/**
 Count of SGPageView pages

 @return NSInteger
 */
- (NSInteger)numberOfViewsInPageView;

@end

@interface SGPageView : UIScrollView

@property (nonatomic, weak, nullable) id <SGPageViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <SGPageViewDelegate> delegateSG;


- (void)reloaData;
- (void)reloadTableViewAtIndex:(NSInteger)index;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;


@end
