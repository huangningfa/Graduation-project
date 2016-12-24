//
//  ResetPwOrSMSLoginController.h
//  xiaofu
//
//  Created by HNF's wife on 2016/12/5.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XFControllerOption) {
    XFControllerOptionResetPassword, // 1.重设密码
    XFControllerOptionSMSCodeLogin  // 2.验证码登录
};

@interface ResetPwOrSMSLoginController : UIViewController

- (instancetype)initWithControllerOption:(XFControllerOption)controllerOption;

@end
