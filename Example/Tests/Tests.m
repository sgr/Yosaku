//
//  YosakuTests.m
//  YosakuTests
//
//  Created by Shigeru Fujiwara on 08/03/2014.
//  Copyright (c) 2014 Shigeru Fujiwara. All rights reserved.
//

#import <YSLogger.h>
static const int ddLogLevel = LOG_LEVEL_DEBUG;

SpecBegin(YSLogger)

describe(@"consistency test", ^{
    YSLogger* logger = [[YSLogger alloc] initWithCapacity:10 dateFormatter:nil];
    [DDLog addLogger:logger];
    for (int i = 0; i < 15; i++) {
        DDLogDebug(@"test log (%d)", i);
    }
    it(@"don't over capacity", ^{
        expect(logger.countOfLogMessages).to.equal(10);
    });
    [DDLog removeLogger:logger];
});

SpecEnd
