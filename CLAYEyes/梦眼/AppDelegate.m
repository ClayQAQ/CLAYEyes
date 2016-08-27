//
//  AppDelegate.m
//  梦眼
//
//  Created by imac on 15/9/29.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "PastViewController.h"
#import "TodayViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];
    self.window = window;
    [self.window makeKeyAndVisible];

    
    //主标签控制器作为window的根视图控制器
    MainTabBarController *mainTabBarController = [[MainTabBarController alloc] init];
    window.rootViewController = mainTabBarController;
    
    
    TodayViewController *dailyVc = [[TodayViewController alloc] init];
    PastViewController *pastVc = [[PastViewController alloc] init];
    
    
    BaseNavigationController *dailyNv = [[BaseNavigationController alloc] initWithRootViewController:dailyVc];
    BaseNavigationController *pastNv = [[BaseNavigationController alloc] initWithRootViewController:pastVc];
    
    NSArray *nvs = @[dailyNv,pastNv];
    mainTabBarController.viewControllers = nvs;

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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
