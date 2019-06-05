//
//  AppDelegate.m
//  ASChatKit
//
//  Created by Lifee on 2019/6/5.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "AppDelegate.h"
#import <JMessage/JMessage.h>

@interface AppDelegate ()<JMessageDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //    监听事件通知。
    [JMessage addDelegate:self withConversation:nil];
    [JMessage setupJMessage:launchOptions
                     appKey:@"03cbe0624ce789790736acdf"
                    channel:@""
           apsForProduction:NO
                   category:nil
             messageRoaming:NO];
    [self loginUser:@"13063481502" Password:@"123456"];
    return YES;
}
- (void)loginUser:(NSString *)username Password:(NSString *)password {
    [JMSGUser registerWithUsername:username password:password completionHandler:^(id resultObject, NSError *error) {
        [JMSGUser loginWithUsername:username password:password completionHandler:^(id resultObject, NSError *error) {
            if (error) {
                NSLog(@"登录失败");
            }
        }];
    }];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JMessage registerDeviceToken:deviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
