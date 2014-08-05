//
//  LogCellTableViewCell.m
//  Yosaku
//
//  Created by Shigeru Fujiwara on 2014/08/03.
//  Copyright (c) 2014年 Shigeru Fujiwara. All rights reserved.
//

#import "LogTableViewCell.h"

@interface LogTableViewCell ()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelLevel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelFunctionName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelMessage;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelDate;
@end

char* fname(const char* filepath) {
    return rindex(filepath, '/') + 1;
}

@implementation LogTableViewCell {
    NSDictionary* _labelMessageTextAttributes;
}

- (void)awakeFromNib
{
    NSMutableParagraphStyle* pStyle = [[NSMutableParagraphStyle alloc] init];
    CGFloat lineHeight = ceil(_labelMessage.font.lineHeight);
    pStyle.minimumLineHeight = lineHeight;
    pStyle.maximumLineHeight = lineHeight;
    _labelMessageTextAttributes = @{NSParagraphStyleAttributeName: pStyle,
                                    NSFontAttributeName: _labelMessage.font};
}

- (void)dealloc
{
    _logMessage = nil;
    _dateFormatter = nil;
}

- (void)setLogMessage:(DDLogMessage *)logMessage
{
    switch (logMessage->logFlag) {
        case LOG_FLAG_ERROR:
            _labelLevel.text = @"ERROR";
            _labelLevel.backgroundColor = [UIColor redColor];
            break;
        case LOG_FLAG_WARN:
            _labelLevel.text = @"WARN";
            _labelLevel.backgroundColor = [UIColor redColor];
            break;
        case LOG_FLAG_INFO:
            _labelLevel.text = @"INFO";
            _labelLevel.backgroundColor = [UIColor blueColor];
            break;
        case LOG_FLAG_DEBUG:
            _labelLevel.text = @"DEBUG";
            _labelLevel.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
            break;
        case LOG_FLAG_VERBOSE:
            _labelLevel.text = @"VERBOSE";
            _labelLevel.backgroundColor = [UIColor greenColor];
            break;
        default:
            _labelLevel.text = @"UNKNOWN";
            _labelLevel.backgroundColor = [UIColor grayColor];
            break;
    }
    _labelFunctionName.text = [NSString stringWithFormat:@"%s (%d) %s", fname(logMessage->file), logMessage->lineNumber, logMessage->function];
    _labelMessage.text = logMessage->logMsg;
    _labelDate.text = [_dateFormatter stringFromDate:logMessage->timestamp];
}

- (CGFloat)calcHeightAgainstWidth:(CGFloat)width
{
    CGFloat labelMessageWidth = width - 35;
    CGRect rect = [_labelMessage.text boundingRectWithSize:CGSizeMake(labelMessageWidth, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:_labelMessageTextAttributes
                                                   context:nil];
    return ceil(rect.size.height) + 20 + _labelLevel.bounds.size.height + _labelDate.bounds.size.height;
}

@end
