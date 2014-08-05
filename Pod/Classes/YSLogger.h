//
//  YSLogger.h
//  Pods
//
//  Created by 藤原 滋 on 2014/08/04.
//
//

#import <UIKit/UIKit.h>
#import "DDLog.h"

extern const float kUpdateIntervalSec;

@interface YSLogger : DDAbstractLogger <DDLogger, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic) float updateIntervalSec;

- (instancetype)initWithCapacity:(NSUInteger)capacity dateFormatter:(NSDateFormatter*)formatter;

//! This method must be called in your UIViewController's viewDidLoad
- (void)viewDidLoad;

//! This method must be called in your UIViewController's viewDidAppear
- (void)viewDidAppear:(BOOL)animated;

//! This method must be called in your UIViewController's viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated;

@end
