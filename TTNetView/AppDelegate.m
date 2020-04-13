//
//  AppDelegate.m
//  TTNetView
//
//  Created by Avicii on 2020/4/11.
//  Copyright © 2020 Avicii. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBar.h"
#import "TTNetView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    BaseTabBar *barVC = [BaseTabBar new];
    self.window.rootViewController = barVC;
    [self.window makeKeyAndVisible];
    
    [[TTNetView shareManager] AFNReachability]; ///运行即监控网络状态

    return YES;
}

@end
