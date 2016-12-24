//
//  LoginNavigationController.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/3.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "LoginNavigationController.h"
#import "XFConfig.h"

@interface LoginNavigationController () <UINavigationControllerDelegate>

@end

@implementation LoginNavigationController

+ (void)initialize {
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    // 设置NavigationBar左右两边的属性
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = XFColor;
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:dic forState:(UIControlStateNormal)];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    dic2[NSForegroundColorAttributeName] = XFColorDark;
    [item setTitleTextAttributes:dic2 forState:(UIControlStateDisabled)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barTintColor = [UIColor whiteColor];
    // 设置NavigationBar标题的属性
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationBar setTitleTextAttributes:dic];
    
    self.delegate = self;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count) {
        
//        viewController.navigationItem.leftBarButtonItems = [UIBarButtonItem itemsWithImageName:@"navigationbar_back" highImageName:@"navigationbar_back" target:self action:@selector(popToPre)];
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)popToPre {
    [self popViewControllerAnimated:YES];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isFirstVC = viewController == self.viewControllers[0];
    [self setNavigationBarHidden:isFirstVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
