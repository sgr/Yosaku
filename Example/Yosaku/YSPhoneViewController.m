//
//  YSViewController.m
//  Yosaku
//
//  Created by Shigeru Fujiwara on 08/03/2014.
//  Copyright (c) 2014 Shigeru Fujiwara. All rights reserved.
//

#import "YSPhoneViewController.h"
#import "YSAppDelegate.h"

@interface YSPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *logTableView;
@end

@implementation YSPhoneViewController {
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
