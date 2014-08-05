//
//  YSAppDelegate.m
//  Yosaku
//
//  Created by CocoaPods on 08/03/2014.
//  Copyright (c) 2014 Shigeru Fujiwara. All rights reserved.
//

#import "YSAppDelegate.h"
#import <DDTTYLogger.h>

NSString* const dummyMessage = @"Quo usque tandem abutere, Catilina, patientia nostra? Quam diu etiam furor iste tuus nos eludet?";

@implementation YSAppDelegate {
    dispatch_source_t _logTimer;
    int _counter;
}

#pragma mark - Application life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"JST"];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss.SSS";

    _logger = [[YSLogger alloc] initWithCapacity:100 dateFormatter:dateFormatter];
    _logger.updateIntervalSec = 1.5;
    [DDLog addLogger:_logger];


    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [self startDummyLogging];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self stopDummyLogging];

    [DDLog removeLogger:_logger];
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
    _counter = 0;
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
            switch (_counter) {
                case 0:
                    DDLogInfo(msg);
                    _counter++;
                    break;
                case 1:
                    DDLogDebug(msg);
                    _counter++;
                    break;
                case 2:
                    DDLogVerbose(msg);
                    _counter++;
                    break;
                case 3:
                    DDLogWarn(msg);
                    _counter++;
                    break;
                case 4:
                    DDLogError(msg);
                    _counter = 0;
                    break;
                default:
                    DDLogError(@"Invalid counter value! (%d)", _counter);
                    _counter = 0;
                    break;
            }
        });
        dispatch_source_set_cancel_handler(_logTimer, ^{
            _logTimer = nil;
        });
    }
    dispatch_resume(_logTimer);
}

- (void)stopDummyLogging
{
    if (_logTimer) {
        dispatch_source_cancel(_logTimer);
    }
}

@end
