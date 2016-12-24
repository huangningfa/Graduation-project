//
//  DeckViewController.h
//  ShareTribe
//
//  Created by HNF's wife on 16/7/18.
//  Copyright © 2016年 HNF's wife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeckViewController : UIViewController
/**
 抽屉式架构类型
 - Default: 默认类型
 - Scale:   主视图会根据偏移量自动缩放
 - Cover:   遮罩覆盖式
 */
typedef NS_ENUM(NSInteger, DeckDrawerStyle) {
    DeckDrawerStyleDefault,
    DeckDrawerStyleScale,
    DeckDrawerStyleCover
};

- (instancetype)initWithDrawerStyle:(DeckDrawerStyle)drawerStyle mainViewController:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController;

- (UIViewController *)mainViewController;

- (UIViewController *)leftViewController;

- (void)setMainViewController:(UIViewController *)mainVC;

/**
 当前是否已关闭侧栏
 */
- (BOOL)isCollapsed;

/**
 打开左侧栏
 */
- (void)expandLeftPanel;

/**
 关闭侧栏
 */
- (void)collapsePanel;

/**
 设置滑动手势开关
 */
- (void)setPanGestureEnabled:(BOOL)enabled;

/**
 设置点击手势开关
 */
- (void)setTapGestureEnabled:(BOOL)enabled;

@end
