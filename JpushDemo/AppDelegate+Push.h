//
//  AppDelegate+Push.h
//  MK100
//
//  Created by 张金山 on 2018/1/8.
//  Copyright © 2018年 txooo. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate (Push) <JPUSHRegisterDelegate>
//极光推送初始化方法
- (void)setJPush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
//进入后台的方法
- (void)JPushDidEnterBackground:(UIApplication *)application;
//将要进入前台的时候的方法
- (void)JPushWillEnterForeground:(UIApplication *)application;

@end
