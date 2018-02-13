//
//  AppDelegate+Push.m
//  MK100
//
//  Created by 张金山 on 2018/1/2.
//  Copyright © 2018年txooo. All rights reserved.
//

#import "AppDelegate+Push.h"
#import "TXAlertView.h"
#define isIOS10 ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
#define isIOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
//需要替换的部分
#define JPushKey      @"XXXXXXXX"

typedef NS_ENUM(NSInteger,JPushType) {
    JPushType1 = 1,//推送消息类型
};

@implementation AppDelegate (Push)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)setJPush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if (isIOS10) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else if (isIOS8) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } 
    BOOL isProduction;
    NSString *channel;
#if DEBUG
    isProduction = NO;
    channel = @"App Hoc";
#else
    isProduction = YES;
    channel = @"App Store";
#endif
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //iOS 10以下 ios 7以上程序杀死的时候点击收到的通知进行的跳转操作
    if (launchOptions && !isIOS10){
        NSDictionary *pushDict = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        [self handleNotification:pushDict];
    }
}

#pragma clang diagnostic pop

#pragma mark 极光推送的代理的方法
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

//ios 6收到通知的做法 可以抛弃
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    [self handleNotification:userInfo];
}

//ios 7以上 iOS10 以下处理前台和后台通知的做法
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    //前台与后台的处理
    if (application.applicationState == UIApplicationStateActive) {
        __weak __typeof(&*self)weakSelf = self;
        [TXAlertView showAlertWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] cancelButtonTitle:@"好的" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf handleNotification:userInfo];
            }
        } otherButtonTitles:@"去看看", nil];
    }else{
        //当程序在后台运行的时候处理的通知
        [self handleNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//ios 10程序在前台收到通知处理
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //ios 10前台获取推送消息内容
        //前台收到消息直接对消息处理 不点击
    }else {
        // 判断为本地通知
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//ios 10在这里处理通知点击跳转
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //ios  无论程序在前台或者程序在后台点击的跳转处理
        [JPUSHService handleRemoteNotification:userInfo];
        [self handleNotification:userInfo];
    }else {
        // 判断为本地通知
   
    }
    completionHandler();  // 系统要求执行这个方法
}

#pragma clang diagnostic pop
//点击推送弹窗进行的处理
- (void)handleNotification:(NSDictionary *)userInfo{
    NSInteger messageType = [userInfo[@"messageType"] integerValue];
    //外送订单待确认订单消息
    switch (messageType) {
        case JPushType1:{
            //根据消息类型的区分进行相应的跳转处理
        }
            break;
        default:
            break;
    }
}

- (void)JPushDidEnterBackground:(UIApplication *)application{
    //重新设置徽标
    [JPUSHService resetBadge];
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)JPushWillEnterForeground:(UIApplication *)application{
    [application setApplicationIconBadgeNumber:0];
}

@end


