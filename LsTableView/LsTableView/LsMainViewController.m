//
//  LsMainViewController.m
//  LsTableView
//
//  Created by 光头强 on 16/7/26.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "LsMainViewController.h"
#import "LsMainTableViewCell.h"

@interface LsMainViewController ()<UITableViewDataSource, UITableViewDelegate>
/** 数据 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = [NSMutableArray arrayWithObjects:@"第一条消息",@"第二条消息",@"第三条消息",@"第四条消息",@"第五条消息", nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *mainIdentifier = @"mainIdentifier";
    [self.tableView registerClass:[LsMainTableViewCell class] forCellReuseIdentifier:mainIdentifier];
    
    LsMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
    return cell;
}
@end
