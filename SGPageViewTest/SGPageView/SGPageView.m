//
//  SGPageView.m
//  SGPageViewTest
//
//  Created by 刘山国 on 2016/12/22.
//  Copyright © 2016年 山国. All rights reserved.
//

#import "SGPageView.h"

typedef struct {
    BOOL funcNumberOfViews;
    BOOL funcShouldSettintTableView;
}SGTableViewDataSourceResponse;

typedef struct {
    BOOL funcScrollToTableViewAtIndex;
}SGTableViewDelegateResponse;

@interface SGPageView ()<UIScrollViewDelegate>{
    SGTableViewDataSourceResponse dataSourceResponse;
    SGTableViewDelegateResponse   delegateResponse;
}

@property (nonatomic,strong) NSMutableArray *tableViews;
@property (nonatomic,strong) NSMutableArray *contentOffSets;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) SGPDirection direction;
@property (nonatomic,assign) CGFloat startContentOfSetX;
@property (nonatomic,strong) NSMutableArray *cacheTableViews;

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
}


#pragma mark - publick

- (void)reloaData{
    NSCAssert(dataSourceResponse.funcNumberOfViews, @"SGPageView %@ delegateSG %@ not response to selector funcNumberOfViews: ", self, self.dataSource);
    if (dataSourceResponse.funcNumberOfViews) {
        //清空记录
        for (UITableView *tableView in self.tableViews) {
            if ([self isValidTableView:tableView]) {
                [tableView removeFromSuperview];
            }
        }
        [self.tableViews removeAllObjects];
        [self.contentOffSets removeAllObjects];
        
        //重新添加
        NSInteger count = [self countOfViews];
        for (NSInteger i=0; i<count; i++) {
            [self.tableViews addObject:[NSNull null]];
            [self.contentOffSets addObject:@(0.0)];
        }
        [self setContentSize:CGSizeMake(CGRectGetWidth(self.frame)*count, CGRectGetHeight(self.frame))];
        [self scrollToIndex:0 animated:NO];
    } else {
        [self setContentSize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    }
}

- (void)reloadTableViewAtIndex:(NSInteger)index{
    UITableView *tableView =[self.tableViews objectAtIndex:index];
    if ([self isValidTableView:tableView]) {
        [tableView reloadData];
    } else {
        [self addTableViewAtIndex:index];
    }
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    if (![self isValidIndex:index]) return;
    self.currentIndex = index;
    [self autoReleaseMemery];
    [self prepareTableViewAtIndex:index];
    [self prepareTableViewAtIndex:index-1];
    [self prepareTableViewAtIndex:index+1];
   
    CGFloat x = index*CGRectGetWidth(self.frame);
    CGFloat y = [[self.contentOffSets objectAtIndex:index] floatValue];
    if (animated) {
         __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf setContentOffset:CGPointMake(x, y)];
        }];
    } else {
        [self setContentOffset:CGPointMake(x, y)];
    }
    
}

- (void)autoReleaseMemery{
    NSInteger validCount = [self validTableViewsCount];
    if (validCount>3) {
        for (NSInteger i=0; i<self.tableViews.count; i++) {
            if (i>self.currentIndex+1 || i<self.currentIndex-1) {
                UITableView *tableView = self.tableViews[i];
                if ([tableView isKindOfClass:[UITableView class]]) {
                    [self.tableViews replaceObjectAtIndex:i withObject:[NSNull null]];
                    [self.contentOffSets replaceObjectAtIndex:i withObject:@(tableView.contentOffset.y)];
                    [self.cacheTableViews addObject:tableView];
                    [tableView removeFromSuperview];
                }
            }
        }
    }
}

//- (void)shouldReleaseMemery{
//    NSInteger validCount = [self validTableViewsCount];
//    
//    if (validCount<=1) return;
//    validCount = validCount/2;
//    NSInteger upIndex   = self.currentIndex - (validCount/2>0?:1);
//    NSInteger nextIndex = self.currentIndex + (validCount/2>0?:1);
//    for (NSInteger i=0; i<self.tableViews.count; i++) {
//        if (i>=upIndex && i<=nextIndex+1) i= nextIndex+1;
//        if (![self isValidIndex:i]) continue;
//        UITableView *tableView = self.tableViews[i];
//        if ([tableView isKindOfClass:[UITableView class]]) {
//            [self.tableViews replaceObjectAtIndex:i withObject:[NSNull null]];
//            [self.contentOffSets replaceObjectAtIndex:i withObject:@(tableView.contentOffset.y)];
//            [tableView removeFromSuperview];
//        }
//    }
//}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.startContentOfSetX = scrollView.contentOffset.x;
//    NSLog(@"contentOffset.x==%f",self.startContentOfSetX);
    self.direction = SGDirctionNone;
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    NSInteger index = (NSInteger)targetContentOffset->x/CGRectGetWidth(scrollView.frame);
    if (index == self.currentIndex) return;
    if (![self isValidIndex:index]) return;
    if (targetContentOffset->x-self.startContentOfSetX>0) {
        self.direction = SGDirctionRigth;
    } else {
        self.direction = SGDirctionLeft;
    }
    self.currentIndex = index;
    [self autoReleaseMemery];
    if (delegateResponse.funcScrollToTableViewAtIndex) [self.delegateSG pageView:self dragScrollToTableView:[self prepareTableViewAtIndex:index] index:index direction:self.direction];
    [self prepareNextTableView];
    
}



#pragma mark - private

- (BOOL)isValidIndex:(NSInteger)index{
    if (index<0 || index>=[self countOfViews]) return NO;
    return YES;
}

- (NSInteger)validTableViewsCount{
    NSInteger count = 0;
    for (NSObject *obj in self.tableViews) {
        if ([obj isKindOfClass:[UITableView class]]) count++;
    }
    return count;
}


- (void)prepareNextTableView{
    if (self.direction == SGDirctionNone) return;
    NSInteger index = self.currentIndex+self.direction;
    [self prepareTableViewAtIndex:index];
    self.direction = SGDirctionNone;
}

- (BOOL)isValidTableView:(UITableView *)tableView{
    if (!tableView) return NO;
    if ([tableView isKindOfClass:[UITableView class]])  return YES;
    return NO;
}

- (UITableView *)prepareTableViewAtIndex:(NSInteger)index{
    if (![self isValidIndex:index]) return nil;
    UITableView *tableView = [self.tableViews objectAtIndex:index];
    if (![self isValidTableView:tableView]) tableView = [self addTableViewAtIndex:index];
    return tableView;
}


- (UITableView *)addTableViewAtIndex:(NSInteger)index{
    UITableView *tableView =[self.tableViews objectAtIndex:index];
    if (dataSourceResponse.funcShouldSettintTableView) {
        tableView = [self newTableViewAtIndex:index];
        [self.dataSource pageView:self shouldSettingTableView:tableView atIndex:index];
        [self addSubview:tableView];
        [self.tableViews replaceObjectAtIndex:index withObject:tableView];
        [tableView reloadData];
        [tableView setContentOffset:CGPointMake(0, [self.contentOffSets[tableView.tag] floatValue])];
    }
    return tableView;
}




- (UITableView *)newTableViewAtIndex:(NSInteger)index{
    CGFloat width  = CGRectGetWidth(self.frame);
    CGFloat heigth = CGRectGetHeight(self.frame);
    UITableView *tableView;
    
    if (self.cacheTableViews.count>0) {
        tableView = [self.cacheTableViews lastObject];
        [self.cacheTableViews removeLastObject];
    } else {
        tableView = [[UITableView alloc] init];
    }
    tableView.frame = CGRectMake(index*width, 0, width, heigth);
    tableView.tag = index;
    return tableView;
}

- (NSInteger)countOfViews{
    if (dataSourceResponse.funcNumberOfViews) return [self.dataSource numberOfViewsInPageView];
    return 0;
}


#pragma mark - setter

- (void)setDelegateSG:(id<SGPageViewDelegate>)delegateSG{
    _delegateSG = delegateSG;
    delegateResponse.funcScrollToTableViewAtIndex = [_delegateSG respondsToSelector:@selector(pageView:dragScrollToTableView:index:direction:)];
     if (_dataSource) [self reloaData];
}

- (void)setDataSource:(id<SGPageViewDataSource>)dataSource{
    _dataSource                                     = dataSource;
    dataSourceResponse.funcNumberOfViews            = [_dataSource respondsToSelector:@selector(numberOfViewsInPageView)];
    dataSourceResponse.funcShouldSettintTableView   = [_dataSource respondsToSelector:@selector(pageView:shouldSettingTableView:atIndex:)];
     if (_delegateSG) [self reloaData];
}



#pragma mark - getter

- (NSMutableArray *)tableViews{
    if (!_tableViews) {
        _tableViews = [[NSMutableArray alloc]init];
    }
    return _tableViews;
}


- (NSMutableArray *)contentOffSets{
    if (!_contentOffSets) {
        _contentOffSets = [[NSMutableArray alloc]init];
    }
    return _contentOffSets;
}

- (NSMutableArray *)cacheTableViews{
    if (!_cacheTableViews) {
        _cacheTableViews = [[NSMutableArray alloc]init];
    }
    return _cacheTableViews;
}

@end
