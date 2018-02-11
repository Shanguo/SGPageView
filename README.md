# SGPageView


安装
==============

### CocoaPods

1. 在 Podfile 中添加  `pod 'SGPageView'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 `#import <SGPageView/SGPageView.h>`。
4. 请点个star吧

简述
==============

一个可以提供多栏页面的pageView，比使用UITableView还简单。

示例展示 Demo
==============

<img src="DemoImages/demo.gif" width="300">

使用 Usage
==============

### 只需要一个方法调用就可以放大浏览图片，下载图片，查看原图等。

1.把自定义的pageView设置好frame添加到self.view

```
[self.view addSubview:self.pageView];
- (SGPageView *)pageView{
    if (!_pageView) {
        _pageView = [[SGPageView alloc]initWithFrame:CGRectMake(0, 20+44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44-44-20)];
        [_pageView setDelegateSG:self];
        [_pageView setDataSource:self];
    }
    return _pageView;
}
        
```
2.实现数据源和代理回调

```
- (NSInteger)numberPages{
    return self.dataArrays.count;
}

- (UIView *)pageView:(SGPageView *)pageView viewForIndex:(NSInteger)index {
	// 如果多种类型的View可以看demo中SecondViewController
    UITableView *tableView = [pageView reusableViewWithIdentifier:nil forIndex:index];
    if (!tableView) tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
    return tableView;
} 
- (void)pageView:(SGPageView *)pageView scrollToView:(UIView *)view atIndex:(NSInteger)index {
    [self selectedBtnIndex:index];
}
```


API
==============
1.datasource和delegateSG

```
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


```
2.方法和属性

```
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
```