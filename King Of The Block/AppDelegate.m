//
//  AppDelegate.m
//  King Of The Block
//
//  Created by Calvin on 10/18/14.
//  Copyright (c) 2014 hackNY. All rights reserved.
//

#import "AppDelegate.h"
#import "Controllers/ActiveRunViewController.h"
#import "Controllers/ProfileViewController.h"
#import "Masonry.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [UIWindow new];
    [self.window makeKeyAndVisible];
    self.window.frame = [[UIScreen mainScreen] bounds];
    
    // Override point for customization after application launch.
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    // Add Active Run View Controller
    ActiveRunViewController *activeRunViewController = [[ActiveRunViewController alloc] init];
    UITabBarItem *activeRunTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Run" image:nil selectedImage:nil];
    [activeRunViewController setTabBarItem:activeRunTabBarItem];
    [tabBarController addChildViewController:activeRunViewController];
    // Add Profile View Controller
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    [profileViewController setUsername:@"mary"];
    UINavigationController *profileNavigationController = [[UINavigationController alloc] init];
    [profileNavigationController pushViewController:profileViewController animated:false];
    UITabBarItem *profileTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:nil selectedImage:nil];
    [profileNavigationController setTabBarItem:profileTabBarItem];
    [tabBarController addChildViewController:profileNavigationController];
    
    [tabBarController setSelectedIndex:0];
    [self.window setRootViewController: tabBarController];
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
