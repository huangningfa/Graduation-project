//
//  AppDelegate.m
//  xiaofu
//
//  Created by HNF's wife on 2016/11/20.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "AppDelegate.h"
#import "DeckViewController.h"
#import "LeftTableViewController.h"
#import "ServiceViewController.h"
#import "LoginViewController.h"
#import "LoginNavigationController.h"
#import <BmobSDK/Bmob.h>
#import "RootTool.h"
#import "XFUser.h"

#import "RegisterViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self registerBmob];
    
    [self updateUser];
    
    [self chooseRootViewController];
//    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:[[ServiceViewController alloc] init]];
//    LeftTableViewController *leftVC = [[LeftTableViewController alloc] init];
//    DeckViewController *deckVC = [[DeckViewController alloc] initWithDrawerStyle:DeckDrawerStyleDefault mainViewController:navc leftViewController:leftVC];
//    
//    self.window.rootViewController = deckVC;
    
//    self.window.rootViewController = [[LoginNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];

    [self setupDefaultApprance];
    
    [self.window makeKeyAndVisible];
    
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

- (void)registerBmob {
    [Bmob registerWithAppKey:@"2e5c2c85f65c12536a065dd1976dd0ac"];
}

- (void)updateUser {
//    BmobUser *user = [BmobUser getCurrentUser];
//    NSLog(@"!!%@", user);
//    if (user) {
//        [BmobUser loginWithUsernameInBackground:user.username password:user.password block:^(BmobUser *user, NSError *error) {
//            if (error == nil) {
//                NSLog(@"success");
//                NSLog(@"AFTER%@", user);
//            }
//        }];
//    }
}

- (void)setupDefaultApprance {
    NSMutableDictionary *titleDic = [NSMutableDictionary dictionary];
    titleDic[NSForegroundColorAttributeName] = [UIColor blackColor];
    titleDic[NSFontAttributeName] = XFFontBig;
    [[UINavigationBar appearance] setTitleTextAttributes:titleDic];
    
    NSMutableDictionary *dicNormal = [NSMutableDictionary dictionary];
    dicNormal[NSForegroundColorAttributeName] = XFColor;
    dicNormal[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    
    NSMutableDictionary *dicDisable = [NSMutableDictionary dictionary];
    dicDisable[NSForegroundColorAttributeName] = XFColorDark;
    [[UIBarButtonItem appearance] setTitleTextAttributes:dicNormal forState:(UIControlStateNormal)];
    [[UIBarButtonItem appearance] setTitleTextAttributes:dicDisable forState:(UIControlStateDisabled)];
    
    //[[UIBarButtonItem appearance] setTintColor:[UIColor grayColor]];
}

- (void)chooseRootViewController {
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        // 有本地用户缓存，进入主界面
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:[[ServiceViewController alloc] init]];
        LeftTableViewController *leftVC = [[LeftTableViewController alloc] init];
        DeckViewController *deckVC = [[DeckViewController alloc] initWithDrawerStyle:DeckDrawerStyleDefault mainViewController:navc leftViewController:leftVC];
    
        self.window.rootViewController = deckVC;
        
    }else {
        // 登录界面
        self.window.rootViewController = [[LoginNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }
}

@end
