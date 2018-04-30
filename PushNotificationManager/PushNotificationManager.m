// PushNotificationManager.m
//
// Copyright (c) 2017 BANYAN
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PushNotificationManager.h"
#import <CoreLocation/CoreLocation.h>

static PushNotificationManager *_instance = nil;

@implementation PushNotificationManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

///-------------------------
#pragma mark - iOS 10
///-------------------------
#pragma mark - `push notification style of normal`->`普通推送`
- (void)normalPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;

    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of normal,provide a customized alert sound`->`普通推送,可设置自定义提示音`
- (void)normalPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    if (soundName) {
        content.sound = [UNNotificationSound soundNamed:soundName];
    }else{
        content.sound = [UNNotificationSound defaultSound];
    }
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of graphics`->`图像推送,包含png、jpg、gif等图像格式`
- (void)graphicsPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier fileName:(NSString *)fileName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    NSArray *array = [fileName componentsSeparatedByString:@"."];
    NSString *graphicsPath = [[NSBundle mainBundle]pathForResource:array[0] ofType:array[1]];
    
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:identifier URL:[NSURL fileURLWithPath:graphicsPath] options:nil error:nil];
    content.attachments = @[attachment];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of graphics,provide a customized alert sound`->`图像推送,包含png、jpg、gif等图像格式,可设置自定义提示音`
- (void)graphicsPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier fileName:(NSString *)fileName soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    if (soundName) {
        content.sound = [UNNotificationSound soundNamed:soundName];
    }else{
        content.sound = [UNNotificationSound defaultSound];
    }
    
    NSArray *array = [fileName componentsSeparatedByString:@"."];
    NSString *graphicsPath = [[NSBundle mainBundle]pathForResource:array[0] ofType:array[1]];
    
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:identifier URL:[NSURL fileURLWithPath:graphicsPath] options:nil error:nil];
    content.attachments = @[attachment];

    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of graphics,provide a graphics download from internet`->`图像推送,可以通过链接下载`
- (void)graphicsPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier urlString:(NSString *)urlString timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    NSData *graphicsData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    NSString *localPath = [documentPath stringByAppendingPathComponent:@"PushNotificationGraphics.png"];
    [graphicsData writeToFile:localPath atomically:YES];
    
    if (localPath && ![localPath isEqualToString:@""]) {
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:identifier URL:[NSURL URLWithString:[@"file://" stringByAppendingString:localPath]] options:nil error:nil];
        if (attachment) {
            content.attachments = @[attachment];
        }
    }
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of graphics,provide a graphics download from internet and a customized alert sound`->`图像推送,可以通过链接下载,可设置自定义提示音`
- (void)graphicsPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier urlString:(NSString *)urlString soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    if (soundName) {
        content.sound = [UNNotificationSound soundNamed:soundName];
    } else {
        content.sound = [UNNotificationSound defaultSound];
    }
    
    NSData *graphicsData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *localPath = [documentPath stringByAppendingPathComponent:@"PushNotificationGraphics.png"];
    [graphicsData writeToFile:localPath atomically:YES];
    
    if (localPath && ![localPath isEqualToString:@""]) {
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:identifier URL:[NSURL URLWithString:[@"file://" stringByAppendingString:localPath]] options:nil error:nil];
        if (attachment) {
            content.attachments = @[attachment];
        }
    }
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of video`->`视频推送`
- (void)videoPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier fileName:(NSString *)fileName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    NSArray *array = [fileName componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:array[0] ofType:array[1]];
    
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:identifier URL:[NSURL fileURLWithPath:filePath] options:nil error:nil];
    content.attachments = @[attachment];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of video,provide a customized alert sound`->`视频推送,可设置自定义提示音`
- (void)videoPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier fileName:(NSString *)fileName soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    if (soundName) {
        content.sound = [UNNotificationSound soundNamed:soundName];
    }else{
        content.sound = [UNNotificationSound defaultSound];
    }
    
    NSArray *array = [fileName componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:array[0] ofType:array[1]];

    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:identifier URL:[NSURL fileURLWithPath:filePath] options:nil error:nil];
    content.attachments = @[attachment];

    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of video,provide a video download from internet`->`视频推送,可以通过链接下载`
- (void)videoPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier urlString:(NSString *)urlString timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *localPath = [documentPath stringByAppendingPathComponent:@"PushNotificationVideo.mp4"];
    [videoData writeToFile:localPath atomically:YES];
    
    if (localPath && ![localPath isEqualToString:@""]) {
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:identifier URL:[NSURL URLWithString:[@"file://" stringByAppendingString:localPath]] options:nil error:nil];
        if (attachment) {
            content.attachments = @[attachment];
        }
    }
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of video,provide a video download from internet and a customized alert sound`->`视频推送,可以通过链接下载,可设置自定义提示音`
- (void)videoPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier urlString:(NSString *)urlString soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    if (soundName) {
        content.sound = [UNNotificationSound soundNamed:soundName];
    }else{
        content.sound = [UNNotificationSound defaultSound];
    }
    
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *localPath = [documentPath stringByAppendingPathComponent:@"PushNotificationVideo.mp4"];
    [videoData writeToFile:localPath atomically:YES];
    
    if (localPath && ![localPath isEqualToString:@""]) {
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:identifier URL:[NSURL URLWithString:[@"file://" stringByAppendingString:localPath]] options:nil error:nil];
        if (attachment) {
            content.attachments = @[attachment];
        }
    }
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of timing`->`定时推送`
- (void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier weekday:(NSString *)weekday hour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    NSDateComponents *components = [[NSDateComponents alloc]init];
    if (weekday && weekday != nil) {
        components.weekday = [weekday integerValue] + 1;
    }
    if (hour && hour != nil) {
        components.hour = [hour integerValue];
    }
    if (minute && minute != nil) {
        components.minute = [minute integerValue];
    }
    if (second && second != nil) {
        components.second = [second integerValue];
    }
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of timing,provide a customized alert sound`->`定时推送,可设置自定义提示音`
- (void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier weekday:(NSString *)weekday hour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    if (soundName) {
        content.sound = [UNNotificationSound soundNamed:soundName];
    }else{
        content.sound = [UNNotificationSound defaultSound];
    }
    
    NSDateComponents *components = [[NSDateComponents alloc]init];
    if (weekday && weekday != nil) {
        components.weekday = [weekday integerValue] + 1;
    }
    if (hour && hour != nil) {
        components.hour = [hour integerValue];
    }
    if (minute && minute != nil) {
        components.minute = [minute integerValue];
    }
    if (second && second != nil) {
        components.second = [second integerValue];
    }
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of timing(ex.2017-10-1)`->`定时推送(行如2017-10-1)`
- (void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier year:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    NSDateComponents *components = [[NSDateComponents alloc]init];
    if (year && year != nil) {
        components.year = [year integerValue];
    }
    if (month && month != nil) {
        components.month = [month integerValue];
    }
    if (hour && hour != nil) {
        components.hour = [hour integerValue];
    }
    if (minute && minute != nil) {
        components.minute = [minute integerValue];
    }
    if (second && second != nil) {
        components.second = [second integerValue];
    }
   
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [calendar dateFromComponents:components];
    NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:date];
    components.weekday = weekday +1;
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of timing(ex.2017-10-1),provide a customized alert sound`->`定时推送,可设置自定义提示音(行如2017-10-1)`
- (void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier year:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    if (soundName) {
        content.sound = [UNNotificationSound soundNamed:soundName];
    }else{
        content.sound = [UNNotificationSound defaultSound];
    }
    
    NSDateComponents *components = [[NSDateComponents alloc]init];
    if (year && year != nil) {
        components.year = [year integerValue];
    }
    if (month && month != nil) {
        components.month = [month integerValue];
    }
    if (hour && hour != nil) {
        components.hour = [hour integerValue];
    }
    if (minute && minute != nil) {
        components.minute = [minute integerValue];
    }
    if (second && second != nil) {
        components.second = [second integerValue];
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [calendar dateFromComponents:components];
    NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:date];
    components.weekday = weekday +1;
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of timing,the fire date is included in a dictionary`->`定时推送,启动时间包含在字典内`
- (void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier fireDate:(NSDictionary *)fireDate timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
  
    NSDateComponents *components = [[NSDateComponents alloc]init];
    if (fireDate[@"year"] && fireDate[@"year"] != nil) {
        components.year = [fireDate[@"year"] integerValue];
    }
    if (fireDate[@"month"] && fireDate[@"month"] != nil) {
        components.month = [fireDate[@"month"] integerValue];
    }
    if (fireDate[@"day"] && fireDate[@"day"] != nil) {
        components.day = [fireDate[@"day"] integerValue];
    }
    if (fireDate[@"hour"] && fireDate[@"hour"] != nil) {
        components.hour = [fireDate[@"hour"] integerValue];
    }
    if (fireDate[@"minute"] && fireDate[@"minute"] != nil) {
        components.minute = [fireDate[@"minute"] integerValue];
    }
    if (fireDate[@"second"] && fireDate[@"second"] != nil) {
        components.second = [fireDate[@"second"] integerValue];
    }
    if (fireDate[@"weekday"] && fireDate[@"weekday"] != nil) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *date = [calendar dateFromComponents:components];
        NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:date];
        components.weekday = weekday +1;
    }
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of timing,the fire date is included in a dictionary,provide a customized alert sound`->`定时推送,推送时间包含在字典内,可设置自定义提示音`
- (void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier fireDate:(NSDictionary *)fireDate soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    if (soundName) {
        content.sound = [UNNotificationSound soundNamed:soundName];
    }else{
        content.sound = [UNNotificationSound defaultSound];
    }
    
    NSDateComponents *components = [[NSDateComponents alloc]init];
    if (fireDate[@"year"] && fireDate[@"year"] != nil) {
        components.year = [fireDate[@"year"] integerValue];
    }
    if (fireDate[@"month"] && fireDate[@"month"] != nil) {
        components.month = [fireDate[@"month"] integerValue];
    }
    if (fireDate[@"day"] && fireDate[@"day"] != nil) {
        components.day = [fireDate[@"day"] integerValue];
    }
    if (fireDate[@"hour"] && fireDate[@"hour"] != nil) {
        components.hour = [fireDate[@"hour"] integerValue];
    }
    if (fireDate[@"minute"] && fireDate[@"minute"] != nil) {
        components.minute = [fireDate[@"minute"] integerValue];
    }
    if (fireDate[@"second"] && fireDate[@"second"] != nil) {
        components.second = [fireDate[@"second"] integerValue];
    }
    if (fireDate[@"weekday"] && fireDate[@"weekday"] != nil) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *date = [calendar dateFromComponents:components];
        NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:date];
        components.weekday = weekday +1;
    }
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of interactive`->`交互推送`
- (void)interactivePushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier identifierArray:(NSArray<NSString *> *)identifierArray actionArray:(NSArray<UNNotificationAction *> *)actionArray timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:identifier actions:actionArray intentIdentifiers:identifierArray options:UNNotificationCategoryOptionCustomDismissAction];
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category, nil]];
    
    content.categoryIdentifier = identifier;
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];

    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of interactive,provide a customized alert sound`->`交互推送,可设置自定义提示音`
- (void)interactivePushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier identifierArray:(NSArray<NSString *> *)identifierArray actionArray:(NSArray<UNNotificationAction *> *)actionArray soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    if (soundName) {
        content.sound = [UNNotificationSound soundNamed:soundName];
    }else{
        content.sound = [UNNotificationSound defaultSound];
    }
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:identifier actions:actionArray intentIdentifiers:identifierArray options:UNNotificationCategoryOptionCustomDismissAction];
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category, nil]];
    
    content.categoryIdentifier = identifier;
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeat];

    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of location` ->`定点推送`
- (void)locationPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier longitude:(double)longitude latitude:(double)latitude radius:(NSInteger)radius notifyOnEntry:(BOOL)notifyOnEntey notifyOnExit:(BOOL)notifyOnExit repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude,longitude);
    
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier];
    region.notifyOnEntry = notifyOnEntey;
    region.notifyOnExit = notifyOnExit;
    
    UNLocationNotificationTrigger *trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:repeat];

    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `push notification style of location,provide a customized alert sound,e.g. @"intro.mp3"` ->`定点推送,可设置自定义提示音`
- (void)locationPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier longitude:(double)longitude latitude:(double)latitude radius:(NSInteger)radius notifyOnEntry:(BOOL)notifyOnEntry ontifyOnExit:(BOOL)notifyOnExit soundName:(NSString *)soundName repeat:(BOOL)repeat {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTitle;
    content.body = body;
    content.userInfo = userInfo;
    content.badge = @1;
    
    if (soundName) {
        content.sound = [UNNotificationSound soundNamed:soundName];
    }else{
        content.sound = [UNNotificationSound defaultSound];
    }
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude,longitude);
    
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier];
    region.notifyOnEntry = notifyOnEntry;
    region.notifyOnExit = notifyOnExit;
    
    UNLocationNotificationTrigger *trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:repeat];
    
    [self registerPushNotificationWithIdentifier:identifier content:content trigger:trigger];
}

#pragma mark - `Register Push Notification`->添加推送
- (void)registerPushNotificationWithIdentifier:(NSString *)identifier content:(UNMutableNotificationContent *)content trigger:(UNNotificationTrigger *)trigger API_AVAILABLE(ios(10.0)){
    UNNotificationRequest *request;
    if ([trigger isKindOfClass:[UNCalendarNotificationTrigger class]]) {
        request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    }else if ([trigger isKindOfClass:[UNTimeIntervalNotificationTrigger class]]){
        request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    }else if ([trigger isKindOfClass:[UNLocationNotificationTrigger class]]){
        request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    }

    // `push notification` ->`发送推送`
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//        if (error == nil) {
//            DLog(@"the local notification identifier is: %@ \n and content is:  %@ \n with trigger: %@",request.identifier,content,trigger);
//        }
    }];

    [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
}

#pragma mark - `delete the notification state for pending with param "identifier"` ->`删除指定标识符的未发出的推送`
- (void)iOS10_removePendingLocalNotificationWithIdentifier:(NSString *)identifier {
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifier]];
}

#pragma mark - `delete all the notification state for pending` ->`删除所有未发出的推送`
- (void)iOS10_removeAllPendingLocalNotifications {
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
}

#pragma mark - `delete the notification state for delivered with param "identifier"` ->`删除指定表示符的已发出的推送`
- (void)iOS10_removeDeliveredLocalNotificationWithIdentifier:(NSString *)identifier {
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[identifier]];
}

#pragma mark - `delete all the notification state for delivered` ->`删除所有已发出的推送`
- (void)iOS10_removeAllDeliveredLocalNotifications {
    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
///-------------------------
#pragma mark - iOS 8
///-------------------------
/**!
 * @brief iOS 8 普通推送
 */
- (void)iOS8_localNotificationWithAlertBody:(NSString *)alertBody launchImage:(NSString *)launchImage soundName:(NSString *)soundName userInfo:(NSDictionary *)userInfo identifier:(NSString *)identifier fireDate:(NSDate *)fireDate timeInterval:(NSInteger)timeInterval {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = alertBody;
    
    if ([launchImage isEqualToString:@""]) {
        return;
    } else {
        localNotification.alertLaunchImage = launchImage;
    }
    
    if (soundName) {
        localNotification.soundName = [NSString stringWithFormat:@"%@",soundName];
    } else {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }
 
    localNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
    localNotification.userInfo = userInfo;
    localNotification.category = identifier;
    
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = timeInterval;        // 0 means don't repeat
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - `delete the notification with param "key" from userInfo` ->`通过指定标识符删除推送`
- (void)iOS8_removeLocalNotificationWithKey:(NSString *)key {
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (!notifications || notifications.count <= 0) {
        return;
    }
    for (UILocalNotification *notification in notifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            NSString *info = userInfo[key];
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}

#pragma mark - `delete all notifications in queue` ->`删除队列中所有的推送`
- (void)iOS8_removeAllLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
#pragma clang diagnostic pop

///-------------------------
#pragma mark - 角标 Badge
///-------------------------
- (void)clearNotificationBadges {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end
