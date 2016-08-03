//
//  ViewController.m
//  LsTableViewPlaceholder
//
//  Created by 光头强 on 16/8/3.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "UITableView+Placeholder.h"
#import "WeChatStylePlaceHolder.h"

static const CGFloat LsDuration = 1.0;
#define LsRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]
@interface ViewController ()<WeChatStylePlaceHolderDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign, getter=isNoResult) BOOL noResult;
@end

@implementation ViewController
/**
 *  lazy load dataSource
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (BOOL)isNoResult {
    _noResult = (self.dataSource.count == 0);
    return _noResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LsTableViewPlaceholder";
    self.view.backgroundColor = [UIColor cyanColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView ls_setPlaceholderView:^UIView * _Nonnull(UITableView * _Nonnull tableView) {
        UIView *weChatStyle = [self weChatStylePlaceHolder];
        return weChatStyle;
    }];
    [self setUpMJRefresh];
    //[self.tableView ls_setPlaceholderView:nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - 添加下拉刷新控件
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - 创建placeholder视图
- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.tableView.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}

#pragma mark - WeChatStylePlaceHolderDelegate Method
- (void)emptyOverlayClicked:(id)sender {
    //[self loadNewData];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 下拉刷新数据
- (void)loadNewData {
    if (!self.isNoResult) {
        self.dataSource = nil;
    } else {
        // 1.添加假数据
        for (int i = 0; i<5; i++) {
            [self.dataSource insertObject:LsRandomData atIndex:0];
        }
    }
    // 2.模拟1秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LsDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", @"Random Data", self.dataSource[indexPath.row]];
    return cell;
}



@end
