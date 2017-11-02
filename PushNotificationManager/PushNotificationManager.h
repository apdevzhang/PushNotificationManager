// PushNotificationManager.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

///-------------------------
#pragma mark - Utility
///-------------------------
#define IsAvailableString(_ref)   (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]) && ([_ref isKindOfClass:[NSString class]]) && (_ref.length > 0))

///-------------------------
#pragma mark - DEBUG
///-------------------------
#ifdef DEBUG
#define DLog(FORMAT, ...) fprintf(stderr, "%s [Line %zd]\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define DLog(FORMAT, ...) nil
#endif

@interface PushNotificationManager : NSObject
+(instancetype)sharedInstance;

/////////////////////general properities introduce ->通用属性介绍
// @param `title` the title of push notification ->推送主标题
// @param `subTitle` the subTitle of push notification ->推送副标题
// @param `body` the body(main information) of push notification ->推送内容体
// @param `identifier` the identifier of push notification ->推送标识符
// @param `badge` the badge of push notification default is 1 ->推送角标
// @param `soundName` the alert sound of push notification ->推送提示音
// @param `timeInterval` the time interval of push notification ->推送间隔时间
// @param `repeat` if you pick the repeat property 'YES',you require to set the timeInterval value >= 60second ->是否重复,若要重复->时间间隔应>=60s
//////////////;

/**！
 * @brief `push notification style of normal` ->`普通推送`
 */
-(void)normalPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of normal,provide a customized alert sound,e.g. @"intro.mp3"` ->`普通推送,可设置自定义提示音`
 */
-(void)normalPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**！
 * @brief `push notification style of graphics,include the format of png、jpg、gif and other graphics formats` ->`图像推送,包含png、jpg、gif等图像格式`
 */
-(void)graphicsPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier fileName:(NSString *)fileName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of graphics,provide a customized alert sound,e.g. @"intro.mp3"` ->`图像推送,可设置自定义提示音`
 */
-(void)graphicsPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier fileName:(NSString *)fileName soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of graphics,provide a graphics download from internet` ->`图像推送,可以通过链接下载`
 */
-(void)graphicsPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier urlString:(NSString *)urlString timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of graphics,provide a graphics download from internet and a customized alert sound,e.g. @"intro.mp3"` ->`图像推送,可以通过链接下载,可设置自定义提示音`
 */
-(void)graphicsPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier urlString:(NSString *)urlString soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of video` ->`视频推送`
 */
-(void)videoPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier fileName:(NSString *)fileName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of video,provide a customized alert sound,e.g. @"intro.mp3"` ->`视频推送,可设置自定义提示音`
 */
-(void)videoPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier fileName:(NSString *)fileName soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of video,provide a video download from internet` ->`视频推送,可以通过链接下载`
 */
-(void)videoPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier urlString:(NSString *)urlString timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of video,provide a video download from internet and a customized alert sound,e.g. @"intro.mp3"`` ->`视频推送,可以通过链接下载,可设置自定义提示音`
 */
-(void)videoPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier urlString:(NSString *)urlString soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of timing` ->`定时推送`
 */
-(void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier weekday:(NSString *)weekday hour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of timing,provide a customized alert sound,e.g. @"intro.mp3"` ->`定时推送,可设置自定义提示音`
 */
-(void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier weekday:(NSString *)weekday hour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of timing(ex.2017-10-1 5:12)` ->`定时推送(行如2017-10-1 5:12)`
 */
-(void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier year:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of timing(ex.2017-10-1 5:12),provide a customized alert sound,e.g. @"intro.mp3"` ->`定时推送,可设置自定义提示音(行如2017-10-1 5:12)`
 */
-(void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier year:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute second:(NSString *)second soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

//    NSDictionary *dict = @{@"weekday":@1, //the `1` said Monday in China ->`1`等于中国周一,而不是美国周日
//                           @"hour":@2,
//                           @"minute":@20,
//                           @"second":@10
//                           }; // this meaning the fire date is "2:20:10 Monday" ->字典的内容表示中国时间"周一 2:20:10"
/**!
 * @brief `push notification style of timing,the fire date is included in a dictionary,the fireDate usage is as follows` ->`定时推送,推送时间包含在字典内,字典使用方法如下`
 */
-(void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier fireDate:(NSDictionary *)fireDate timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;   // the fire date include the properities,such as era,year,month,day,hour,minute,second,nanosecond,weekday,weekdayOrdinal,quarter,weekOfMonth,weekOfYear,yearForWeekOfYear

/**!
 * @brief `push notification style of timing,the fire date is included in a dictionary,provide a customized alert sound,e.g. @"intro.mp3"` ->`定时推送,推送时间包含在字典内,可设置自定义提示音`
 */
-(void)timingPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier fireDate:(NSDictionary *)fireDate soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of interactive` ->`交互推送`
 */
-(void)interactivePushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier identifierArray:(NSArray<NSString *> *)identifierArray actionArray:(NSArray<UNNotificationAction *> *)actionArray timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of interactive,provide a customized alert sound,e.g. @"intro.mp3"` ->`交互推送,可设置自定义提示音`
 */
-(void)interactivePushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier identifierArray:(NSArray<NSString *> *)identifierArray actionArray:(NSArray<UNNotificationAction *> *)actionArray soundName:(NSString *)soundName timeInterval:(NSInteger)timeInterval repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of location` ->`定点推送`
 */
-(void)locationPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier longitude:(CGFloat)longitude latitude:(CGFloat)latitude radius:(NSInteger)radius notifyOnEntry:(BOOL)notifyOnEntey notifyOnExit:(BOOL)notifyOnExit repeat:(BOOL)repeat;

/**!
 * @brief `push notification style of location,provide a customized alert sound,e.g. @"intro.mp3"` ->`定点推送,可设置自定义提示音`
 */
-(void)locationPushNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body identifier:(NSString *)identifier longitude:(CGFloat)longitude latitude:(CGFloat)latitude radius:(NSInteger)radius notifyOnEntry:(BOOL)notifyOnEntry ontifyOnExit:(BOOL)notifyOnExit soundName:(NSString *)soundName repeat:(BOOL)repeat;

@end
