# Yosaku

[![CI Status](http://img.shields.io/travis/sgr/Yosaku.svg?style=flat)](https://travis-ci.org/sgr/Yosaku)
[![Version](https://img.shields.io/cocoapods/v/Yosaku.svg?style=flat)](http://cocoadocs.org/docsets/Yosaku)
[![License](https://img.shields.io/cocoapods/l/Yosaku.svg?style=flat)](http://cocoadocs.org/docsets/Yosaku)
[![Platform](https://img.shields.io/cocoapods/p/Yosaku.svg?style=flat)](http://cocoadocs.org/docsets/Yosaku)

Yosaku is a log viewer for Cocoa Touch.
It depends on [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack).

![iPhone portrait screenshot](https://github.com/sgr/Yosaku/raw/master/iPhone_portrait.PNG "iPhone portrait screenshot")
![iPad landspace screenshot](https://github.com/sgr/Yosaku/raw/master/iPad_landscape.PNG "iPad landspace screenshot")

## Usage

### Initializing YSLogger

Yosaku provides YSLogger class as a DDLogger.
In the following example, YSLogger is initialized as a property of your application delegate.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"JST"];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss.SSS";

    _logger = [[YSLogger alloc] initWithCapacity:100 dateFormatter:dateFormatter];
    _logger.updateIntervalSec = 1.5;
    [DDLog addLogger:_logger];

    return YES;
}
```


### Displaying log messages

Yosaku uses UITableView for displaying log records. You create an *empty* UITableView and set it to YSLogger.
In the following example, UITableView is set to app.logger in your view controller's `viewDidLoad` method.

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    // _app.logger is a YSLogger
    _app = [UIApplication sharedApplication].delegate;
    _app.logger.tableView = _logTableView; // YSLogger set myself to tableView's data source and delegate
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
```

You must call `viewDidLoad`, `viewWillDisappear`, and `viewDidAppear` in your view controller's same name methods for synchronizing YSLogger's life cycle with your view controller's it.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* XCode 5.1 or later
* iOS 7 or later

## Installation

Yosaku is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "Yosaku"

## Author

Shigeru Fujiwara

## License

Yosaku is available under the MIT license. See the LICENSE file for more info.

