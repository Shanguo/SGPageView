//
//  SecondViewController.m
//  SGPageView
//
//  Created by 刘山国 on 2018/2/10.
//  Copyright © 2018年 山国. All rights reserved.
//

#import "SecondViewController.h"
#import "SGPageView.h"
#import "TitleCollectionViewCell.h"

static NSString * const kCellID = @"Cell";

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate,SGPageViewDataSource,SGPageViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *titleCollectionView;
@property (nonatomic,strong)  SGPageView *pageView;
@property (nonatomic,strong) NSArray *dataArrays;
@property (nonatomic,strong) NSArray *titleArrays;
@property (nonatomic,copy  ) NSIndexPath *currentIndex;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArrays = @[@"tableView",@"View",@"CollectionView",@"webView",@"tableView数字",@"tableView符号",@"tableView汉字",@"tableView大写字母",@"tableView省份",@"tableView国家",@"webView"];
    self.dataArrays = @[@[@"a",@"b",@"c",@"d",@"e",@"f",@"g"],
                        @[@"View"],
                        @[@"CollectionView"],
                        @[@"http://www.baidu.com"],
                        @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"],
                        @[@"@",@"#",@"$",@"&",@"^",@"*",@"("],
                        @[@"哈",@"你",@"好",@"吗",@"啊",@"嘿",@"和"],
                        @[@"A",@"S",@"D",@"E",@"G",@"S",@"H"],
                        @[@"山东",@"河北",@"浙江",@"福建",@"江苏",@"北京",@"上海"],
                        @[@"中国",@"美国",@"英国",@"印度",@"法国",@"巴西",@"西班牙"],
                        @[@"https://zhidao.baidu.com/question/425382312987430932.html"]];
    [self.titleCollectionView setTag:-1];
    [self.titleCollectionView registerNib:[UINib nibWithNibName:kTitleCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:kTitleCollectionViewCellID];
    [self.view addSubview:self.pageView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.titleCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageView.currentIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self.pageView scrollToIndex:self.pageView.currentIndex animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArrays[tableView.pageViewIndex] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag%2==0) return 60;
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID  forIndexPath:indexPath];
    cell.textLabel.text = self.dataArrays[tableView.pageViewIndex][indexPath.row];
    return cell;
}


- (NSInteger)numberPages{
    return self.dataArrays.count;
}

- (UIView *)pageView:(SGPageView *)pageView viewForIndex:(NSInteger)index {
    UIView *view = nil;
    // 1.tableView
    if ((index<1||index>3) && index<self.dataArrays.count-1) {
        view = [pageView reusableViewWithIdentifier:nil forIndex:index];
        if (!view) {
            UITableView *tableView = [[UITableView alloc] init];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
            view = tableView;
        }
    }
    else {
        // 2.view
        if (index == 1) {
            view = [pageView reusableViewWithIdentifier:@"view" forIndex:index];
            if (!view) {
                view = [[UIView alloc] initWithFrame:CGRectMake(20, 50, 200, 300)];
                [view setBackgroundColor:[UIColor greenColor]];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 100, 20)];
                [label setText:@"View页面"];
                [view addSubview:label];
            }
        }
        // 3.collectionView
        else if (index == 2) {
            view = [pageView reusableViewWithIdentifier:@"collectionView" forIndex:index];
            if (!view) {
                CGFloat const kLineSpacing = 20;
                UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
                [flowLayout setItemSize:CGSizeMake(100, 100)];
                [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
                [flowLayout setMinimumInteritemSpacing:kLineSpacing];
                [flowLayout setMinimumLineSpacing:kLineSpacing];
                [flowLayout setSectionInset:UIEdgeInsetsMake(0, kLineSpacing, 0, kLineSpacing)];
                
                UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
                [collectionView setDelegate:self];
                [collectionView setDataSource:self];
                [collectionView setBackgroundColor:[UIColor whiteColor]];
                [collectionView registerNib:[UINib nibWithNibName:kTitleCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:kTitleCollectionViewCellID];
                view = collectionView;
            }
            
        }
        // 4.webView
        else {
            view = [pageView reusableViewWithIdentifier:@"webView" forIndex:index];
            if (!view) {
                UIWebView *webView = [[UIWebView alloc] init];
                view = webView;
            }
            NSURL *url = [NSURL URLWithString:self.dataArrays[index][0]];
            [view setWebViewUrl:url];
        }
    }
    return view;
}


- (void)pageView:(SGPageView *)pageView scrollToView:(UIView *)view atIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.titleCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag >=0) return 4;
    return self.titleArrays.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag>=0) {
       return CGSizeMake(100, 100);
    } else {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setText:self.titleArrays[indexPath.row]];
        [titleLabel sizeToFit];
        return CGSizeMake(titleLabel.frame.size.width+20, 44);
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTitleCollectionViewCellID forIndexPath:indexPath];
    if (collectionView.tag >= 0) {
        [cell.titleLabel setText:@"collcetion"];
        [cell.titleLabel setBackgroundColor:[UIColor yellowColor]];
    } else {
        [cell.titleLabel setText:self.titleArrays[indexPath.row]];
        [cell.titleLabel setBackgroundColor:[UIColor whiteColor]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag<0) [self.pageView scrollToIndex:indexPath.row animated:YES];
}

#pragma mark - getter
- (SGPageView *)pageView{
    if (!_pageView) {
        _pageView = [[SGPageView alloc]initWithFrame:CGRectMake(0, 20+44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44-44-20)];
        [_pageView setDelegateSG:self];
        [_pageView setDataSource:self];
    }
    return _pageView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
