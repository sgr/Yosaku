//
//  LogCellTableViewCell.h
//  Yosaku
//
//  Created by Shigeru Fujiwara on 2014/08/03.
//  Copyright (c) 2014年 Shigeru Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface LogTableViewCell : UITableViewCell

@property (nonatomic) DDLogMessage* logMessage;
@property (nonatomic) NSDateFormatter* dateFormatter;

- (CGFloat)calcHeightAgainstWidth:(CGFloat)width;

@end
