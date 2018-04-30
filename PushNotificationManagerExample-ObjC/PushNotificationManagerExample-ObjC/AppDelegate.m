//
//  AppDelegate.m
//  PushNotificationManagerExample-ObjC
//
//  Created by BANYAN on 2017/9/26.
//  Copyright © 2017年 GREENBANYAN. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "PushNotificationManager.h"
#import <TSMessage.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNAuthorizationOptions types=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    //
                }];
            } else {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success) { }];
            }
        }];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }
  #pragma clang diagnostic pop
    
    [[PushNotificationManager sharedInstance] clearNotificationBadges];
    
    return YES;
}

// iOS8 收到推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    DLog(@"%@", notification.userInfo);
    DLog(@"category:%@", notification.category);
}

#pragma mark - iOS 10 `Receives the push notification in the foreground`->`前台收到推送`
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSString *identifier = notification.request.identifier;
    NSString *categoryIdentifier = notification.request.content.categoryIdentifier;
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //remote notification,do nothing
    }else{
        DLog(@"%@",notification.request.content);
        //reminder
        if (identifier) {
            [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"identifier:%@",identifier] type:TSMessageNotificationTypeMessage];
        }
        if (categoryIdentifier) {
            [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"categoryIdentifier:%@",categoryIdentifier] type:TSMessageNotificationTypeMessage];
        }
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

#pragma mark - iOS 10 `Receives the push notification in the background`->`应用在后台收到推送的处理方法`
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    DLog(@"%@",userInfo);
    
    NSString *identifier =  response.notification.request.identifier;
    NSString *categoryIdentifier = response.notification.request.content.categoryIdentifier;
    DLog(@"identifier:%@\n,categoryIdentifier:%@",identifier,categoryIdentifier);
    
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //remote notification,do nothing
    }else{
        if ([identifier isEqualToString:@"5-2"]) {
            if ([response.actionIdentifier isEqualToString:@"reply"]) {
                UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse *)response;
                DLog(@"%@",textResponse.userText);
                [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"%@",textResponse.userText] type:TSMessageNotificationTypeMessage];
            }else if ([response.actionIdentifier isEqualToString:@"enter"]){
                [TSMessage showNotificationWithTitle:@"进入" type:TSMessageNotificationTypeMessage];
            }else if ([response.actionIdentifier isEqualToString:@"cancel"]){
                [TSMessage showNotificationWithTitle:@"取消" type:TSMessageNotificationTypeMessage];
            }
        }
        
        //reminder
        if (identifier) {
            [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"identifier:%@",identifier] type:TSMessageNotificationTypeMessage];
        }
        if (categoryIdentifier) {
            [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"categoryIdentifier:%@",categoryIdentifier] type:TSMessageNotificationTypeMessage];
        }
    }
    completionHandler();
}

@end
