//
//  ViewController.m
//  仿知乎加载
//
//  Created by _ on 16/8/15.
//  Copyright © 2016年 NXB. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+ZFQLoadView.h"

@interface ViewController () <UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    ZFQLoadFrontOrNextView *v = [[ZFQLoadFrontOrNextView alloc] initWithFrame:CGRectMake(30, 30, 200, 80)];
//    ZFQLoadHeaderView *v = [[ZFQLoadHeaderView alloc] initWithFrame:CGRectMake(30, 30, 200, 80)];
//    v.backgroundColor = [UIColor orangeColor];
//    v.titleLabel.text = @"上拉加载上一页";
//    [self.view addSubview:v];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [v headerPullWithOffset:0];
//    });
    self.view.backgroundColor = [UIColor lightGrayColor];
//    [self.myTableView addLoadHeaderWithRefreshingBlk:^{
//        NSLog(@"开始加载");
//    }];
    
    [self.myTableView addLoadFooterWithRefreshingBlk:^{
        NSLog(@"开始加载Footer");
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.myTableView.zfqHearderView beginRefresh];
//    });
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.myTableView testEnd];
//    });

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myTest:(id)sender
{
//    [self.myTableView.zfqHeaderView stopLoading];
    [self.myTableView.zfqFooterView stopLoading];

}
@end
