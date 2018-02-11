//
//  SGPageView.h
//  SGPageViewTest
//
//  Created by 刘山国 on 2016/12/22.
//  Copyright © 2016年 山国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SGPageView.h"

@class SGPageView;
@protocol SGPageViewDelegate <NSObject,UIScrollViewDelegate>

/**
 滑动PageView的回调

 @param pageView SGPageView
 @param tableView UITableView
 @param index index
 @param dirction SGPDirection
 */
@optional
- (void)pageView:(SGPageView *_Nonnull)pageView scrollToView:(UIView *_Nonnull)view atIndex:(NSInteger)index;

@end

@protocol SGPageViewDataSource <NSObject>

@required

/**
 Count of SGPageView pages
 
 @return NSInteger
 */
- (NSInteger)numberPages;

/**
 TableView Setting,calls when new tableView was add to view

 @param pageView SGPageView
 @param index index
 */
- (UIView *_Nonnull)pageView:(SGPageView *_Nonnull)pageView viewForIndex:(NSInteger)index;

@end

@interface SGPageView : UIScrollView

@property (nonatomic, weak, nullable) id <SGPageViewDataSource>     dataSource;
@property (nonatomic, weak, nullable) id <SGPageViewDelegate>       delegateSG; // 注意：delegate是SGPageView.super UIScrollView的代理，请勿使用错误
@property (nonatomic,assign,readonly) NSInteger                     currentIndex;
@property (nonatomic,strong,readonly) UIView * _Nonnull             currentView;


/**
 获取重用的View 如果返回nil 需要自己new View，如果是tableView、collectionView 内部自动调用其reload

 @param identifier 相同类型的View的重用标志，如果传nil则使用SGPageView默认的重用标志
 @param index index
 @return View or nil
 */
- (id _Nullable)reusableViewWithIdentifier:(NSString *_Nullable)identifier forIndex:(NSInteger)index;


/**
 滚动到Page

 @param index index
 @param animated animated
 */
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

/**
 reload pages
 */
- (void)reloadData;

@end
