//
//  YSPadViewController.m
//  Yosaku
//
//  Created by 藤原 滋 on 2014/08/04.
//  Copyright (c) 2014年 Shigeru Fujiwara. All rights reserved.
//

#import "YSPadViewController.h"
#import "YSAppDelegate.h"

@interface YSPadViewController ()
@property (weak, nonatomic) IBOutlet UITableView *logTableView;
@end

@implementation YSPadViewController {
    YSAppDelegate* _app;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _app = [UIApplication sharedApplication].delegate;
    _app.logger.tableView = _logTableView;
    [_app.logger viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_app.logger viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_app.logger viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
