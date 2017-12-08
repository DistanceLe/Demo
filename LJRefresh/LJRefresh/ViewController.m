//
//  ViewController.m
//  LJRefresh
//
//  Created by LiJie on 16/8/19.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+LJRefresh.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource=self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCell"];
    [self.tableView reloadData];
    [self.view addSubview: self.tableView];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    __weak typeof(self) tempWeakSelf=self;
    [self.tableView addLJFootRefresh:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tempWeakSelf.tableView endLJRefresh];
        });
    }];
    
    [self.tableView addLJHeadRefresh:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tempWeakSelf.tableView endLJRefresh];
        });
    }];
}

-(void)dealloc{
    NSLog(@"testVC dealloc....................");
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *testCell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    testCell.textLabel.text = [NSString stringWithFormat:@"第%ld条",(long)indexPath.row];
    return testCell;
}


















@end
