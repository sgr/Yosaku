//
//  YSAppDelegate.h
//  Yosaku
//
//  Created by CocoaPods on 08/03/2014.
//  Copyright (c) 2014 Shigeru Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YSLogger.h>

@interface YSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) YSLogger* logger;

@end
