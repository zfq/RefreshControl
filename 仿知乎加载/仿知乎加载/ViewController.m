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
@property (nonatomic,assign) NSInteger count;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.count = 6;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    [self.myTableView addLoadHeaderWithRefreshingBlk:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.count = weakSelf.count + 3;
            [weakSelf.myTableView reloadData];
            [weakSelf.myTableView.zfqHeaderView stopLoading];
        });
        NSLog(@"开始加载");
    }];
    self.myTableView.zfqHeaderView.titleLabel.text = @"加载上一篇";
    
    
    [self.myTableView addLoadFooterWithRefreshingBlk:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.count = weakSelf.count + 3;
            [weakSelf.myTableView reloadData];
            [weakSelf.myTableView.zfqFooterView stopLoading];
        });
        NSLog(@"开始加载Footer");
    }];
    self.myTableView.zfqFooterView.titleLabel.text = @"加载下一篇";
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
