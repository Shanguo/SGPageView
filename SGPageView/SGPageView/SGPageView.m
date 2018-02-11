//
//  SGPageView.m
//  SGPageViewTest
//
//  Created by 刘山国 on 2016/12/22.
//  Copyright © 2016年 山国. All rights reserved.
//

#import "SGPageView.h"

static NSString * const kSGPageViewRegisterDefaultView = @"kSGPageViewRegisterDefaultView";

@interface SGPageView ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableDictionary   *showViews;
@property (nonatomic,strong) NSMutableDictionary   *identifiers;
@property (nonatomic,strong) NSMutableDictionary   *caches;
@property (nonatomic,strong) NSMutableDictionary   *viewContentOffSetYs;
@property (nonatomic,strong) NSMutableDictionary   *viewFrameXes;
@property (nonatomic,assign) NSInteger             currentIndex;
@property (nonatomic,assign) NSInteger             pageCount;

@end

@implementation SGPageView

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSetting];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting];
    }
    return self;
}

- (void)initSetting{
    self.pagingEnabled = YES;
    self.delegate = self;
    self.currentIndex = 0;
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - publick

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    if ([self isInValidIndex:index]) return;
    if (index == self.currentIndex) return;
    [self prepareViewAtIndex:index];
    [self setContentOffset:CGPointMake(self.frame.size.width*index, 0) animated:animated];
}

- (id)reusableViewWithIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    if (!identifier) identifier = kSGPageViewRegisterDefaultView;
    [self.identifiers setValue:identifier forKey:[@(index) stringValue]];
    return [self loadViewInCache:index];
}

- (void)reloadData {
    self.pageCount = [self.dataSource numberPages];
    self.contentSize = CGSizeMake(self.frame.size.width*self.pageCount, self.frame.size.height);
    if ([self isInValidIndex:self.currentIndex]) self.currentIndex = 0;
    [self prepareViewAtIndex:self.currentIndex];
}

- (UIView *)viewAtIndex:(NSInteger)index {
    return [self.showViews valueForKey:[@(index) stringValue]];
}

#pragma private

/**
 准备将要显示的view及其左右两边的view

 @param index index
 */
- (void)prepareViewAtIndex:(NSInteger)index {
    // 先缓存其他的，后面才能prepare从缓存取出
    [self cacheViewBeyondIndex:index];
    self.currentIndex = index;
    for (NSInteger i=index-1; i<index+2; i++) {
        if ([self isInValidIndex:i]) continue;
        if ([self viewAtIndex:i]) continue;
        NSString *indexKey = [self keyOfIndex:i];
        // 从缓存取出
        UIView *view = [self.dataSource pageView:self viewForIndex:i];
        [view setPageViewIndex:i];
        if (CGRectEqualToRect(view.frame, CGRectZero) || CGRectIsNull(view.frame)) {
            view.frame = CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        } else {
            if (view.frame.origin.x<self.bounds.size.width) [self.viewFrameXes setValue:@(view.frame.origin.x) forKey:indexKey];
            view.frame = CGRectMake(i*self.bounds.size.width+[[self.viewFrameXes valueForKey:indexKey] floatValue], view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
        if ([view isKindOfClass:[UIScrollView class]]) {
            UICollectionView *collectionOrTableView = (UICollectionView *)view;
            if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]) [collectionOrTableView reloadData]; // 自动reload
            NSNumber *contentOffSetY = [self.viewContentOffSetYs valueForKey:[@(i) stringValue]];
            [collectionOrTableView setContentOffset:CGPointMake(0, [contentOffSetY floatValue])];
        }
        if ([view isKindOfClass:[UIWebView class]]) {
            UIWebView *webView = (UIWebView*)view;
            NSURLRequest* request = [NSURLRequest requestWithURL:view.webViewUrl];
            [webView loadRequest:request];
        }
        [self addSubview:view];
        [self.showViews setObject:view forKey:indexKey];
    }
}


/**
 从缓存中获取View 可能为nil, nil 需要用户初始化view

 @param index index
 @return reusableView
 */
- (UIView *)loadViewInCache:(NSInteger)index{
    if ([self isInValidIndex:index]) return nil;
    UIView *view = nil;
    NSString *identifier = [self.identifiers valueForKey:[self keyOfIndex:index]];
    for (NSInteger i=0; i<3; i++) {
        NSString *key = [self cacheKey:identifier index:i];
        view = [self.caches valueForKey:key];
        if (view) {
            [self.caches removeObjectForKey:key];
            return view;
        }
    }
    return view;
}

/**
 缓存其他的showViews

 @param index 当前准备显示的index
 */
- (void)cacheViewBeyondIndex:(NSInteger)index {
    for (NSInteger i=0; i<self.pageCount; i++) {
        if (i>=index-1 && i<=index+1) continue;
        UIView *view = [self.showViews valueForKey:[self keyOfIndex:i]];
        if (!view) continue;
        if ([view isKindOfClass:[UIScrollView class]]) [self.viewContentOffSetYs setValue:@(((UIScrollView*)view).contentOffset.y) forKey:[self keyOfIndex:i]];
        [self.showViews removeObjectForKey:[self keyOfIndex:i]];
        NSString *identifier = [self.identifiers valueForKey:[@(i) stringValue]];
        for (NSInteger j=0; j<3; j++) { // 最多需要缓存3个，缓存3个的概率很小
            NSString *key = [self cacheKey:identifier index:j];
            UIView *cacheView = [self.caches valueForKey:key];
            if (!cacheView) {
                [self.caches setValue:view forKey:key];
                break;
            }
        }
    }
}

- (NSString *)keyOfIndex:(NSInteger)index {
    return [@(index) stringValue];
}

- (BOOL)isInValidIndex:(NSInteger)index {
    return index<0 || index >= self.pageCount;
}

- (NSString *)cacheKey:(NSString *)identifier index:(NSInteger)index {
    return [NSString stringWithFormat:@"%@%ld",identifier,(long)index];
}


#pragma mark - UIScrollViewDelegate

// drag过程中的index 基本都会调用,也可能因为太快遗漏中间某个index，可能无法检测到最后停止的那个index
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSInteger index = (NSInteger)targetContentOffset->x/CGRectGetWidth(scrollView.frame);
    if ([self isInValidIndex:index]) return;
    if (index == self.currentIndex) return;
    [self prepareViewAtIndex:index];
    [self runDelegateSG];
}

// 停止的时候一定坑检测到最后一个index
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x/self.frame.size.width);
    if ([self isInValidIndex:index]) return;
    if (index == self.currentIndex) return;
    [self prepareViewAtIndex:index];
    [self runDelegateSG];
}

// 调用ScrollTo方法时此代理会被调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self runDelegateSG];
}

- (void)runDelegateSG {
    if (self.delegateSG && [self.delegateSG respondsToSelector:@selector(pageView:scrollToView:atIndex:)]) {
        [self.delegateSG pageView:self scrollToView:self.currentView atIndex:self.currentIndex];
    }
}

#pragma mark - setter

- (void)setDataSource:(id<SGPageViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self reloadData];
}

#pragma mark - getter

- (UIView *)currentView {
    return [self viewAtIndex:self.currentIndex];
}

- (NSMutableDictionary *)identifiers {
    if (!_identifiers) {
        _identifiers = [[NSMutableDictionary alloc]init];
    }
    return _identifiers;
}

- (NSMutableDictionary *)caches {
    if (!_caches) {
        _caches = [[NSMutableDictionary alloc]init];
    }
    return _caches;
}

- (NSMutableDictionary *)viewContentOffSetYs {
    if (!_viewContentOffSetYs) {
        _viewContentOffSetYs = [[NSMutableDictionary alloc]init];
    }
    return _viewContentOffSetYs;
}

- (NSMutableDictionary *)showViews {
    if (!_showViews) {
        _showViews = [[NSMutableDictionary alloc]init];
    }
    return _showViews;
}
- (NSMutableDictionary *)viewFrameXes {
    if (!_viewFrameXes) {
        _viewFrameXes = [[NSMutableDictionary alloc]init];
    }
    return _viewFrameXes;
}


@end
