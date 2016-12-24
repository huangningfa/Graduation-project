//
//  RootTool.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/4.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "RootTool.h"
#import "LeftTableViewController.h"
#import "DeckViewController.h"
#import "ServiceViewController.h"

@implementation RootTool

+ (void)enterMainViewController {
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:[[ServiceViewController alloc] init]];
        LeftTableViewController *leftVC = [[LeftTableViewController alloc] init];
        DeckViewController *deckVC = [[DeckViewController alloc] initWithDrawerStyle:DeckDrawerStyleDefault mainViewController:navc leftViewController:leftVC];
    
        [UIApplication sharedApplication].keyWindow.rootViewController = deckVC;
}

@end
