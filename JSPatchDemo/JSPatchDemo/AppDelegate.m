//
//  AppDelegate.m
//  JSPatchDemo
//
//  Created by LiJie on 2017/2/8.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "AppDelegate.h"
#import <JSPatchPlatform/JSPatch.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /**  下面是JSPatch 所以的API */
    
    //执行过程中的事件回调
    [JSPatch setupCallback:^(JPCallbackType type, NSDictionary *data, NSError *error) {
        switch (type) {
            case JPCallbackTypeUpdate: {
                NSLog(@"脚本有更新 %@ %@", data, error);
                break;
            }
            case JPCallbackTypeRunScript: {
                NSLog(@"执行脚本 %@ %@", data, error);
                break;
            }
            case JPCallbackTypeException:{
                //JS 脚本执行出错
                NSAssert(NO, data[@"msg"]);
            }
            default:
                break;
        }
    }];
    
    
    [JSPatch startWithAppKey:@"5ee592994bd95ff4"];
    
    //用于发布前测试脚本，调用后，会在当前项目的 bundle 里寻找 main.js 文件执行
    //不能同时调用 +startWithAppKey:
//    [JSPatch testScriptInBundle];
    
    
    
    //设置 条件下发的 条件。
    [JSPatch setupUserData:@{@"userId": @(10010), @"name":@"xiaoming"}];
    
    //自定义 RSA key，在 +sync: 之前调用
    //[JSPatch setupRSAPublicKey:@""];
    
    //默认开启 HTTPS，若有特殊需求，可以在调用 [JSPatch sync] 之前调用这个接口，请求降为 http
    //[JSPatch setupHttp];
    
    
    
    [JSPatch sync];//开始同步 ，也可以放在applicationDidBecomeActive  里面
    
    
    //会打一些请求和执行的log，默认是以 NSLog() 打出
    [JSPatch setupLogger:^(NSString *msg) {
        NSLog(@"logMessage...:%@", msg);
    }];
    
    
    
    //开发预览模式，下发补丁时若选择开发预览模式下发，
    //只会对调用过 +setupDevelopment 的客户端生效
    //[JSPatch setupDevelopment];
    
    
    //调用后，在 statusBar 会出现 JSPatch 调试按钮
    //点击后，会弹起显示 JSPatch 所有相关 log，方便调试问题
    [JSPatch showDebugView];
    
    
    //不在 statusBar 显示调试按钮，直接弹起显示 JSPatch 所有相关 log。
    //[JSPatch presentDebugViewController];
    
    
    
    return YES;
    
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
