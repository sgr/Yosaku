//
//  YSAppDelegate.m
//  Yosaku
//
//  Created by CocoaPods on 08/03/2014.
//  Copyright (c) 2014 Shigeru Fujiwara. All rights reserved.
//

#import "YSAppDelegate.h"
#import <DDTTYLogger.h>

NSString* const dummyMessage = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, "
"sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, "
"quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
"Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
"Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

@implementation YSAppDelegate {
    dispatch_source_t _logTimer;
}

#pragma mark - Application life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"JST"];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss.SSS";

    _logger = [[YSLogger alloc] initWithCapacity:200 dateFormatter:dateFormatter];
    _logger.updateIntervalSec = 1.5;
    [DDLog addLogger:_logger];

    [self startDummyLogging];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [DDLog removeLogger:_logger];
    if (_logTimer) {
        dispatch_source_cancel(_logTimer);
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [DDLog addLogger:_logger];
    [self startDummyLogging];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark - Dummy logging for demo

- (void)startDummyLogging
{
    if (_logTimer == nil) {
        _logTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_logTimer,
                                  dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),
                                  1ull * NSEC_PER_SEC,
                                  0);
        dispatch_source_set_event_handler(_logTimer, ^{
            u_int32_t n = arc4random() % 3;
            NSMutableString* msg = [NSMutableString stringWithFormat:@"dummyMessage (%d): %@", n + 1, dummyMessage];
            for (int i = 0; i < n; i++) {
                [msg appendFormat:@" %@", dummyMessage];
            }
            DDLogDebug(msg);
        });
        dispatch_source_set_cancel_handler(_logTimer, ^{
            _logTimer = nil;
        });
    }
    dispatch_resume(_logTimer);
}

@end
