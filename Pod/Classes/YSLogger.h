//
//  YSLogger.h
//  Pods
//
//  Created by Shigeru Fujiwara on 2014/08/04.
//
//

#import <UIKit/UIKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

extern const float YSDefaultUpdateIntervalSec;
extern const int YSDefaultCapacity;

@interface YSLogger : DDAbstractLogger <DDLogger, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic) float updateIntervalSec;

@property (nonatomic, readonly) NSUInteger countOfLogMessages;

- (instancetype)initWithCapacity:(NSUInteger)capacity dateFormatter:(NSDateFormatter*)formatter;

//! This method must be called in your UIViewController's viewDidLoad
- (void)viewDidLoad;

//! This method must be called in your UIViewController's viewDidAppear
- (void)viewDidAppear:(BOOL)animated;

//! This method must be called in your UIViewController's viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated;

@end
