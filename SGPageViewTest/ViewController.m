//
//  ViewController.m
//  SGPageViewTest
//
//  Created by 刘山国 on 2016/12/22.
//  Copyright © 2016年 山国. All rights reserved.
//

#import "ViewController.h"
#import "SGPageView.h"

@interface ViewController ()<SGPageViewDelegate,SGPageViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) SGPageView *pageView;
@property (nonatomic,strong) NSArray *dataArrays;

@end

@implementation ViewController

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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)scroll{
    [self.pageView scrollToIndex:4 animated:YES];
}
#pragma mark SGPageView Data Source

- (NSInteger)numberOfViewsInPageView{
    return self.dataArrays.count;
}

- (void)pageView:(SGPageView *)pageView shouldSettingTableView:(UITableView *)tableView atIndex:(NSInteger)index{
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    NSLog(@"tableView==%d",tableView.tag);
}

#pragma mark - UITableView DataSource


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArrays[tableView.tag] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"  forIndexPath:indexPath];
    cell.textLabel.text = self.dataArrays[tableView.tag][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"sccccc");
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
    
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}


@end
