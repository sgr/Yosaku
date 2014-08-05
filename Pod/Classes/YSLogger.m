//
//  YSLogger.m
//  Pods
//
//  Created by 藤原 滋 on 2014/08/04.
//
//

#import "YSLogger.h"
#import "LogTableViewCell.h"

const float kUpdateIntervalSec = 3.0f;
NSString* const kCellReuseIdentifier = @"LogCell";

@implementation YSLogger {
    NSUInteger _capacity;
    NSMutableArray* _buf;
    dispatch_queue_t _queue;
    NSMutableArray* _tableSource;
    NSUInteger _currIndex;
    dispatch_source_t _syncTimer;
    UIRefreshControl* _refreshControl;
    LogTableViewCell* _cell;
    NSDateFormatter* _dateFormatter;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity dateFormatter:(NSDateFormatter*)dateFormatter
{
    self = [super init];
    if (self) {
        _capacity = capacity > 0 ? capacity : 50;
        _buf = [NSMutableArray arrayWithCapacity:_capacity];
        _queue = dispatch_queue_create("org.cocoapods.sgr.yosaku.Queue", DISPATCH_QUEUE_SERIAL);
        _tableSource = [NSMutableArray arrayWithCapacity:_capacity];
        _currIndex = NSNotFound;

        _updateIntervalSec = kUpdateIntervalSec;

        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];

        if (dateFormatter) {
            _dateFormatter = dateFormatter;
        } else {
            _dateFormatter = [[NSDateFormatter alloc] init];
            _dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            _dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss.SSS";
        }
    }
    return self;
}

- (void)dealloc
{
    if (_syncTimer) {
        dispatch_source_cancel(_syncTimer);
    }
    _queue = nil;
    _buf = nil;
    _tableSource = nil;
    [_refreshControl removeTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    _refreshControl = nil;
    _cell = nil;
    _dateFormatter = nil;
}

#pragma mark - custom setter

- (void)setTableView:(UITableView *)tableView
{
    if (_refreshControl) {
        [_refreshControl removeFromSuperview];
    }
    if (_tableView) {
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
        _tableView = nil;
        _cell = nil;
        if (_syncTimer) {
            dispatch_source_cancel(_syncTimer);
        }
    }

    _tableView = tableView;
    if (_tableView) {
        _tableView.allowsSelection = NO;
        UINib *nib = [UINib nibWithNibName:@"LogTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:kCellReuseIdentifier];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView addSubview:_refreshControl];
        _cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
        _cell.dateFormatter = _dateFormatter;
        [self startSyncTimer:_updateIntervalSec];
    }
}

- (void)setUpdateIntervalSec:(float)updateIntervalSec
{
    _updateIntervalSec = updateIntervalSec;
    if (_syncTimer) {
        dispatch_source_cancel(_syncTimer);
        [self startSyncTimer:_updateIntervalSec];
    }
}

#pragma mark - for sync UIViewController's life cycle

- (void)viewDidLoad
{
    if (_tableView) {
        [self syncTableSource];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_tableView) {
        [self startSyncTimer:_updateIntervalSec];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_syncTimer) {
        dispatch_source_cancel(_syncTimer);
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogMessage* lm = _tableSource[indexPath.row];
    _cell.logMessage = lm;
    CGFloat height = [_cell calcHeightAgainstWidth:CGRectGetWidth(_tableView.bounds)];
    return height;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.dateFormatter = _dateFormatter;
    DDLogMessage* lm = _tableSource[indexPath.row];
    cell.logMessage = lm;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

#pragma mark - DDLogger

- (void)logMessage:(DDLogMessage*)logMessage
{
    dispatch_async(_queue, ^{
        @synchronized(_buf) {
            if (_buf.count >= _capacity) {
                [_buf removeObjectAtIndex:(_capacity - 1)];
            }
            [_buf insertObject:logMessage atIndex:0];
            if (_currIndex != NSNotFound) {
                _currIndex = _currIndex >= _capacity ? NSNotFound : _currIndex + 1;
            }
        }
    });
}

#pragma mark - private stuff

- (void)refresh
{
    [self performSelectorOnMainThread:@selector(syncTableSource) withObject:nil waitUntilDone:YES];
    [_refreshControl endRefreshing];
}

- (void)startSyncTimer:(float)interval
{
    if (_syncTimer == nil) {
        _syncTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_syncTimer,
                                  dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),
                                  interval * NSEC_PER_SEC,
                                  0);
        dispatch_source_set_event_handler(_syncTimer, ^{
            [self syncTableSource];
        });
        dispatch_source_set_cancel_handler(_syncTimer, ^{
            _syncTimer = nil;
        });
        dispatch_resume(_syncTimer);
    }
}

- (void)syncTableSource
{
    @synchronized(_buf) {
        if (_currIndex != 0 && _buf.count > 0) {
            if (_currIndex == NSNotFound) {
                // 全置き換え
                NSMutableArray* delPaths = [NSMutableArray array];
                for (NSInteger i = 0; i < _tableSource.count; i++) {
                    [delPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                [_tableSource removeAllObjects];
                [_tableView deleteRowsAtIndexPaths:delPaths withRowAnimation:NO];
                NSMutableArray* insPaths = [NSMutableArray array];
                for (NSInteger i = 0; i < _buf.count; i++) {
                    [insPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                [_tableSource addObjectsFromArray:_buf];
                [_tableView insertRowsAtIndexPaths:insPaths withRowAnimation:NO];
            } else {
                NSInteger delNum = _currIndex + _tableSource.count - _capacity;
                if (delNum > 0) {
                    // 削除
                    NSInteger delLoc = _capacity - _currIndex; // _tableSource.count - delNum
                    NSIndexSet* iset = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(delLoc, delNum)];
                    NSMutableArray* delPaths = [NSMutableArray array];
                    for (NSInteger i = delLoc; i < _tableSource.count; i++) {
                        [delPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    }
                    [_tableSource removeObjectsAtIndexes:iset];
                    [_tableView deleteRowsAtIndexPaths:delPaths withRowAnimation:NO];
                }
                
                // 挿入
                NSMutableArray* insPaths = [NSMutableArray array];
                for (NSInteger i = 0; i < _currIndex; i++) {
                    [insPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    [_tableSource insertObject:_buf[i] atIndex:i];
                }
                [_tableView insertRowsAtIndexPaths:insPaths withRowAnimation:NO];
            }
            _currIndex = 0;
        }
    }
}

@end
