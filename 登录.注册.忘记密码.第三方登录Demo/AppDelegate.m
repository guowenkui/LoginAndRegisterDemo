//
//  AppDelegate.m
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/6.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

#import "MainTabBarViewController.h"
#import "SystemManager.h"
#import "SqliteManager.h"
#import "UMSocialQQHandler.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [SqliteManager shareManager] ;
    
    
    [UMSocialData setAppKey:@"5574fce667e58e2e60001a66"];
    
    //微信
    [UMSocialWechatHandler setWXAppId:@"wx4a0959529ef970e3" appSecret:@"0c1b9f673fffc4adfe2519a8a7daabdc" url:@"http://www.baidu.com"];
    //QQ
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
//    UIStoryboard *str = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
//    UINavigationController *nav = [str instantiateInitialViewController];
//    
//    self.window.rootViewController = nav;
    
    UIStoryboard *str =[UIStoryboard storyboardWithName:@"AppMain" bundle:nil];
    
    MainTabBarViewController *main = [str instantiateInitialViewController];
    
    self.window.rootViewController = main;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //初始化系统转态:applicationDidBecomeActive和applicationWillEnterForeground都要掉用
    [[SystemManager sharedInstance] systemStatusInit];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //初始化系统转态:applicationDidBecomeActive和applicationWillEnterForeground都要掉用
    [[SystemManager sharedInstance] systemStatusInit];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
