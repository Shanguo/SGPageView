//
//  ThirdViewController.m
//  SGPageView
//
//  Created by 刘山国 on 2018/2/10.
//  Copyright © 2018年 山国. All rights reserved.
//

#import "ThirdViewController.h"
#import "SGPageView.h"

static NSString * const kCellID = @"Cell";
@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate,SGPageViewDataSource,SGPageViewDelegate>

@property (nonatomic,strong)  SGPageView *pageView;
@property (nonatomic,strong) NSArray *dataArrays;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn1;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn2;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArrays = @[@[@"山东",@"河北",@"浙江",@"福建",@"江苏",@"北京",@"上海"],
                        @[@"中国",@"美国",@"英国",@"印度",@"法国",@"巴西",@"西班牙"]];
    [self.view addSubview:self.pageView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArrays[tableView.tag] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag%2==0) return 60;
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID  forIndexPath:indexPath];
    cell.textLabel.text = self.dataArrays[tableView.tag][indexPath.row];
    return cell;
}


- (NSInteger)numberPages{
    return self.dataArrays.count;
}

- (UIView *)pageView:(SGPageView *)pageView viewForIndex:(NSInteger)index {
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


- (IBAction)titleBtnClick:(UIButton *)sender {
    [self selectedBtnIndex:sender.tag];
    [self.pageView scrollToIndex:sender.tag animated:YES];
}

- (void)selectedBtnIndex:(NSInteger)index {
    UIColor *color = [UIColor colorWithRed:248/255. green:143/255. blue:21/255. alpha:1];
    if (index == 0) {
        [self.titleBtn1 setBackgroundColor:color];
        [self.titleBtn2 setBackgroundColor:[UIColor whiteColor]];
    } else {
        [self.titleBtn1 setBackgroundColor:[UIColor whiteColor]];
        [self.titleBtn2 setBackgroundColor:color];
    }
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
