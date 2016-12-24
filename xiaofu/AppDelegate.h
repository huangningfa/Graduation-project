//
//  AppDelegate.h
//  xiaofu
//
//  Created by HNF's wife on 2016/11/20.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BmobUser;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BmobUser *user;

@end

//-(void)setRequestSmsCodeBtnLogic{
//    
//    //获取手机号
//    NSString *mobilePhoneNumber = self.mobilePhoneNumberTf.text;
//    
//    //请求验证码
//    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:mobilePhoneNumber andTemplate:@"test" resultBlock:^(int number, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//            UIAlertView *tip = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [tip show];
//        } else {
//            //获得smsID
//            NSLog(@"sms ID：%d",number);
//            //设置不可点击
//            [self setRequestSmsCodeBtnCountDown];
//        }
//    }];
//}
//
//-(void)setLoginBtnLogic{
//    //获取手机号、验证码
//    NSString *mobilePhoneNumber = self.mobilePhoneNumberTf.text;
//    NSString *smsCode = self.smsCodeTf.text;
//    
//    //该方法可以进行注册和登录两步操作，如果已经注册过了就直接进行登录
//    [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:mobilePhoneNumber andSMSCode:smsCode block:^(BmobUser *user, NSError *error) {
//        if (user) {
//            //跳转
//            FirstPageViewController *firstPageViewController = [[FirstPageViewController alloc] init];
//            [self.navigationController pushViewController:firstPageViewController animated:NO];
//        } else {
//            NSLog(@"%@",error);
//            UIAlertView *tip = [[UIAlertView alloc] initWithTitle:nil message:@"验证码有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [tip show];
//        }
//    }];
//    
//}
