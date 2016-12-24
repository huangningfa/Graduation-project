//
//  XFProgressHUD.h
//  xiaofu
//
//  Created by HNF's wife on 2016/12/1.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger, XFProgressHUDStatus) {
    
    /** 成功 */
    XFProgressHUDStatusSuccess,
    
    /** 失败 */
    XFProgressHUDStatusError,
    
    /** 提示 */
    XFProgressHUDStatusInfo,
    
    /** 等待 */
    XFProgressHUDStatusWaitting
};

@interface XFProgressHUD : MBProgressHUD

/** 返回一个 HUD 的单例 */
+ (instancetype)sharedHUD;

/** 在 window 上添加一个只显示文字的 HUD */
+ (void)showMessage:(NSString *)text;

/** 在 window 上添加一个提示`信息`的 HUD */
+ (void)showInfoMsg:(NSString *)text;

/** 在 window 上添加一个提示`失败`的 HUD */
+ (void)showFailure:(NSString *)text;

/** 在 window 上添加一个提示`成功`的 HUD */
+ (void)showSuccess:(NSString *)text;

/** 在 window 上添加一个提示`等待`的 HUD, 需要手动关闭 */
+ (void)showLoading:(NSString *)text;

/** 手动隐藏 HUD */
+ (void)hide;



@end
