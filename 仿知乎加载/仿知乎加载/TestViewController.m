//
//  TestViewController.m
//  仿知乎加载
//
//  Created by _ on 16/8/22.
//  Copyright © 2016年 NXB. All rights reserved.
//

#import "TestViewController.h"
#import "UIScrollView+ZFQLoadView.h"

@interface TestViewController () <UITableViewDataSource>
@property (nonatomic,assign) NSInteger count;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    self.count = 4;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.myTableView addLoadHeaderWithRefreshingBlk:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.count = weakSelf.count + 3;
            [weakSelf.myTableView reloadData];
            [weakSelf.myTableView.zfqHeaderView stopLoading];
        });
    }];
    self.myTableView.zfqHeaderView.titleLabel.text = @"加载上一篇";
    self.myTableView.zfqHeaderView.lineColor = [UIColor redColor];
    self.myTableView.zfqHeaderView.backgroundColor = [UIColor brownColor];
    
    [self.myTableView addLoadFooterWithRefreshingBlk:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.count = weakSelf.count + 3;
            [weakSelf.myTableView reloadData];
            [weakSelf.myTableView.zfqFooterView stopLoading];
        });
    }];
    self.myTableView.zfqFooterView.titleLabel.text = @"加载下一篇";
    self.myTableView.zfqFooterView.backgroundColor = [UIColor redColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zi行",indexPath.row];
    return cell;
}

@end
