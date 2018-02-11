//
//  FirstViewController.m
//  SGPageView
//
//  Created by 刘山国 on 2018/2/10.
//  Copyright © 2018年 山国. All rights reserved.
//

#import "FirstViewController.h"
#import "SGPageView.h"

static NSString * const kCellID = @"Cell";
@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource,SGPageViewDelegate,SGPageViewDataSource>

@property (nonatomic,strong) SGPageView *pageView;
@property (nonatomic,strong) NSArray *dataArrays;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArrays = @[@[@"a",@"b",@"c",@"d",@"e",@"f",@"g"],
                        @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"],
                        @[@"@",@"#",@"$",@"&",@"^",@"*",@"("],
                        @[@"哈",@"你",@"好",@"吗",@"啊",@"嘿",@"和"],
                        @[@"A",@"S",@"D",@"E",@"G",@"S",@"H"],
                        @[@"山东",@"河北",@"浙江",@"福建",@"江苏",@"北京",@"上海"],
                        @[@"中国",@"美国",@"英国",@"印度",@"法国",@"巴西",@"西班牙"]
                        ];
    
    [self.view addSubview:self.pageView];

}


#pragma mark SGPageView Data Source

- (NSInteger)numberPages{
    return self.dataArrays.count;
}

- (UIView *)pageView:(SGPageView *)pageView viewForIndex:(NSInteger)index {
    UITableView *tableView = [pageView reusableViewWithIdentifier:nil forIndex:index];
    if (!tableView) {
        NSLog(@"%@%d",@"新建tableView",index);
        tableView = [[UITableView alloc] init];
    }
//    [tableView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
//    [tableView setBackgroundColor:[UIColor greenColor]];
//    [tableView reloadData];
    return tableView;
}


//- (void)pageView:(SGPageView *)pageView shouldSettingTableView:(UITableView *)tableView atIndex:(NSInteger)index{
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
//    NSLog(@"tableView==%ld",(long)tableView.tag);
//}

#pragma mark - UITableView Delegate

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


#pragma mark - getter
- (SGPageView *)pageView{
    if (!_pageView) {
        _pageView = [[SGPageView alloc]initWithFrame:self.view.bounds];
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
