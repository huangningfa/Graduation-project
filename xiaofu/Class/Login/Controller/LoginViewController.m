//
//  LoginViewController.m
//  xiaofu
//
//  Created by HNF's wife on 2016/11/20.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "LoginViewController.h"
#import "AniTextField.h"
#import "SMSCodeView.h"
#import "UILabel+Extension.h"
#import "XFConfig.h"
#import "Utils.h"
#import <BmobSDK/Bmob.h>
#import "RegisterViewController.h"
#import "RootTool.h"
#import "AlertView.h"
#import "ResetPwOrSMSLoginController.h"

@interface LoginViewController () <AniTextFieldDelegate>

@property (nonatomic, weak) UILabel *logo;
@property (nonatomic, weak) UIButton *loginBtn;

@property (nonatomic, weak) UIButton *registerBtn;

@property (nonatomic, weak) UIView *loginView;
@property (nonatomic, weak) AniTextField *loginAccountView;
@property (nonatomic, weak) AniTextField *loginPasswordView;

@property (nonatomic, weak) UIView *registerView;
@property (nonatomic, weak) AniTextField *registerSMSView;
@property (nonatomic, weak) AniTextField *registerPhoneView;
@property (nonatomic, weak) AniTextField *registerPasswordView;
@property (nonatomic, weak) SMSCodeView *smsCodeView;

@property (nonatomic, assign) BOOL loginViewVisible;
@property (nonatomic, assign) BOOL keyboardUp;

@end

@implementation LoginViewController

- (UIView *)registerView {
    if (!_registerView) {
         AniTextField *registerSMSView = [[AniTextField alloc] initWithLeftTitle:@"" titleFontSize:16 placeholder:@"输入验证码" placeholderFontSize:14];
         [registerSMSView addObserver:self forKeyPath:@"textInput" options:(NSKeyValueObservingOptionNew) context:nil];
         registerSMSView.isNumber = YES;
        
         AniTextField *registerPhoneView = [[AniTextField alloc] initWithLeftTitle:@"" titleFontSize:16 placeholder:@"输入手机号" placeholderFontSize:14];
         [registerPhoneView addObserver:self forKeyPath:@"textInput" options:(NSKeyValueObservingOptionNew) context:nil];
         registerPhoneView.isNumber = YES;
        
         AniTextField *registerPasswordView = [[AniTextField alloc] initWithLeftTitle:@"" titleFontSize:16 placeholder:@"登录密码(不少于6位的数字或字母)" placeholderFontSize:14];
         registerPasswordView.isPassword = YES;
         [registerPasswordView  addObserver:self forKeyPath:@"textInput" options:(NSKeyValueObservingOptionNew) context:nil];
        
         SMSCodeView *smsCodeView = [[SMSCodeView alloc] init];
         [smsCodeView addTarget:self action:@selector(getSMSCode:) forControlEvents:(UIControlEventTouchUpInside)];
        self.smsCodeView = smsCodeView;
        
         registerSMSView.delegate = self;
         registerPhoneView.delegate = self;
         registerPasswordView.delegate = self;
        self.registerSMSView = registerSMSView;
        self.registerPhoneView = registerPhoneView;
         self.registerPasswordView = registerPasswordView;
        
         UIView *registerView = [[UIView alloc] init];
         registerView.backgroundColor = [UIColor clearColor];
         [self.view addSubview:registerView];
         [registerView addSubview:registerSMSView];
         [registerView addSubview:registerPhoneView];
         [registerView addSubview:registerPasswordView];
         [registerView addSubview:smsCodeView];
         _registerView = registerView;
         
         [registerView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(SizeMake(375, 30*3+15*2));
         make.left.equalTo(self.view.mas_right).offset(0);
         make.top.equalTo(self.logo.mas_bottom).offset(40*SizeScale);
         }];
         
         [registerSMSView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.offset(0);
         make.size.mas_equalTo(SizeMake(320, 30));
         //make.left.equalTo(registerPasswordView.mas_left).offset(0);
         make.centerX.offset(0);
         }];
         
         [registerPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.equalTo(registerSMSView.mas_top).offset(-15*SizeScale);
         make.size.mas_equalTo(SizeMake(320, 30));
         make.centerX.offset(0);
         }];
         
         [registerPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.equalTo(registerPasswordView.mas_top).offset(-15*SizeScale);
         make.centerX.offset(0);
         make.size.mas_equalTo(SizeMake(320, 30));
         }];
        
         [smsCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.size.mas_equalTo(SizeMake(90, 30));
             make.bottom.offset(30/2*SizeScale);
             //make.right.equalTo(registerPasswordView.mas_right).offset(90/2*SizeScale);
             make.right.equalTo(registerSMSView.mas_right).offset(90/2*SizeScale);
         }];
    }
    return _registerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.loginViewVisible = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setViewToNormal) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [self setupLogo];
    
    [self setupLoginView];
    
    [self setupLoginBtn];
    
    [self setupRegesterBtn];
    
}

- (void)setupLogo {
    UILabel *logo = [UILabel labelWithTitle:@"校服" color:[UIColor blackColor] fontSize:25];
    self.logo = logo;
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50*SizeScale);
        make.centerX.offset(0);
    }];
}

- (void)setupLoginView {
    AniTextField *loginAccountView = [[AniTextField alloc] initWithLeftTitle:@"" titleFontSize:16 placeholder:@"手机号" placeholderFontSize:14];
    [loginAccountView addObserver:self forKeyPath:@"textInput" options:(NSKeyValueObservingOptionNew) context:nil];
    self.loginAccountView = loginAccountView;
    loginAccountView.delegate = self;
    
    AniTextField *loginPasswordView = [[AniTextField alloc] initWithLeftTitle:@"" titleFontSize:16 placeholder:@"密码" placeholderFontSize:14];
    [loginPasswordView addObserver:self forKeyPath:@"textInput" options:(NSKeyValueObservingOptionNew) context:nil];
    loginPasswordView.isPassword = YES;
    self.loginPasswordView = loginPasswordView;
    loginPasswordView.delegate = self;
    
    UIView *loginView = [[UIView alloc] init];
    loginView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loginView];
    [loginView addSubview:loginAccountView];
    [loginView addSubview:loginPasswordView];
    self.loginView = loginView;
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SizeMake(375, 30*3+15*2));
        make.centerX.offset(0);
        make.top.equalTo(self.logo.mas_bottom).offset(40*SizeScale);
    }];
    
    [loginPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.size.mas_equalTo(SizeMake(320, 30));
        make.centerX.offset(0);
    }];
    
    [loginAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginPasswordView.mas_top).offset(-15*SizeScale);
        make.centerX.offset(0);
        make.size.mas_equalTo(SizeMake(320, 30));
    }];
}


- (void)setupLoginBtn {
    UIButton *loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    loginBtn.userInteractionEnabled = NO;
    [loginBtn setTitle:@"登 录" forState:(UIControlStateNormal)];
    [loginBtn setBackgroundColor:RGB(242, 148, 148)];
    loginBtn.titleLabel.font = FontSize(16);
    loginBtn.layer.cornerRadius = 4;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SizeMake(320, 40));
        make.top.equalTo(self.logo.mas_bottom).offset((30*3+15*2+40+30)*SizeScale);
        make.centerX.offset(0);
    }];
}

- (void)loginBtnClicked:(UIButton *)btn {
    [self setViewToNormal];
    
    if (self.loginViewVisible) {
        // 登录
        [XFProgressHUD showLoading:@"正在登录..."];
        [BmobUser loginInbackgroundWithAccount:self.loginAccountView.textInput andPassword:self.loginPasswordView.textInput block:^(BmobUser *user, NSError *error) {
            [XFProgressHUD hide];
            if (error) {
                // 登录失败
                [XFProgressHUD showInfoMsg:@"账号或密码错误"];
            }else {
                // 登录成功,进入主界面
                [RootTool enterMainViewController];
            }
        }];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [XFProgressHUD hide];
//            [RootTool enterMainViewController];
//        });
    }else {
        if (![Utils checkPassword:self.registerPasswordView.textInput]) {
            [XFProgressHUD showInfoMsg:@"密码不符合格式"];
            return;
        }
        // 注册第一步，验证手机验证码
        [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.registerPhoneView.textInput andSMSCode:self.registerSMSView.textInput resultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) { // 进入注册vc
                RegisterViewController *registerVC = [[RegisterViewController alloc] init];
                registerVC.phoneNumber = self.registerPhoneView.textInput;
                registerVC.password = self.registerPasswordView.textInput;
                registerVC.SMSCode = self.registerSMSView.textInput;
                [self.navigationController pushViewController:registerVC animated:YES];
            }else {
                [XFProgressHUD showFailure:@"校验失败"];
            }
        }];

    }
}

- (void)setupRegesterBtn {
    UIButton *regesterBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:regesterBtn];
    self.registerBtn = regesterBtn;
    [regesterBtn setTitle:@"没有校服账号？去注册" forState:(UIControlStateNormal)];
    [regesterBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    regesterBtn.titleLabel.font = FontSize(14);
    [regesterBtn addTarget:self action:@selector(regesterBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [regesterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(10*SizeScale);
        make.centerX.offset(0);
    }];
}

- (void)regesterBtnClicked:(UIButton *)btn {
    [self.view endEditing:YES];
    if (self.loginViewVisible) {
        if (self.keyboardUp) {
            // 无法登录
            AlertView *alerView = [[AlertView alloc] initWithFirstTitle:@"重设密码" secondTitle:@"手机验证码登录" target:self firstAction:@selector(resetPassword) secondAction:@selector(smsCodeLogin)];
            [alerView show];
        }else {
            [btn setTitle:@"已有校服账号？去登录" forState:(UIControlStateNormal)];
            [self hideLoginView];
            [self.loginBtn setTitle:@"注 册" forState:(UIControlStateNormal)];
        }
        
    }else {
        if (self.keyboardUp) {
#warning 校服协议未写
            NSLog(@"遵守协议");
        }else {
            [btn setTitle:@"没有校服账号？去注册" forState:(UIControlStateNormal)];
            [self showLoginView];
            [self.loginBtn setTitle:@"登 录" forState:(UIControlStateNormal)];
        }

    }
    [self setButtonEnable:NO];
}

- (void)resetPassword {
    ResetPwOrSMSLoginController *resetVC = [[ResetPwOrSMSLoginController alloc] initWithControllerOption:(XFControllerOptionResetPassword)];
    [self presentViewController:resetVC animated:YES completion:^{
        [self setViewToNormal];
    }];
}

- (void)smsCodeLogin {
    ResetPwOrSMSLoginController *resetVC = [[ResetPwOrSMSLoginController alloc] initWithControllerOption:(XFControllerOptionSMSCodeLogin)];
    [self presentViewController:resetVC animated:YES completion:^{
        [self setViewToNormal];
    }];
}

- (void)hideLoginView {
    if (!self.loginViewVisible) {
        return;
    }
    self.loginViewVisible = NO;
    
    // login view
    [UIView animateWithDuration:0.5 animations:^{
        self.loginView.transform = CGAffineTransformMakeTranslation(-ScreenWidth, 0);
    } completion:^(BOOL finished) {
        [self.loginPasswordView backToOriginal];
    }];
    
    // register view
    [UIView animateWithDuration:0.5 animations:^{
        self.registerView.transform = CGAffineTransformMakeTranslation(-ScreenWidth, 0);
    }];

}

- (void)showLoginView {
    self.loginViewVisible = YES;
    
    // login view
    [UIView animateWithDuration:0.5 animations:^{
        self.loginView.transform = CGAffineTransformIdentity;
    }];
    
    // register view
    [UIView animateWithDuration:0.5 animations:^{
        self.registerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.registerPasswordView backToOriginal];
    }];
    
}

- (void)checkPhoneNumRegister {
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"mobilePhoneNumber" equalTo:self.registerPhoneView.textInput];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [XFProgressHUD showInfoMsg:@"服务器异常/(ㄒoㄒ)/"];
                [self.smsCodeView backToOriginal];
            });
        }else if (array.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [XFProgressHUD showInfoMsg:@"该手机号已注册"];
                [self.smsCodeView backToOriginal];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sendSMSCode];
            });
        }
        
    }];
}

- (void)sendSMSCode {
    // 从后台获取验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.registerPhoneView.textInput andTemplate:nil resultBlock:^(int number, NSError *error) {
        if (error) {
            [XFProgressHUD showInfoMsg:@"服务器异常/(ㄒoㄒ)/"];
        }else {
            [self.smsCodeView setCounting];
        }
    }];
}

- (void)getSMSCode:(SMSCodeView *)sender {
    [self setViewToNormal];
    if (![Utils checkTelNumber:self.registerPhoneView.textInput]) {
        [XFProgressHUD showFailure:@"请输入正确的手机号"];
        [self.smsCodeView backToOriginal];
        return;
    }
    
    [self checkPhoneNumRegister];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self setViewToNormal];
}

- (void)setViewToNormal {
    [self.view endEditing:YES];

    if (self.keyboardUp) {
        self.keyboardUp = NO;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
        if (self.loginViewVisible) {
            [self changeRegisterBtnTitle:@"没有校服账号？去注册"];
        }else {
            [self changeRegisterBtnTitle:@"已有校服账号？去登录"];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.loginViewVisible) {
        if (self.loginAccountView.textInput.length != 0 && self.loginPasswordView.textInput.length != 0) {
            [self setButtonEnable:YES];
        }else {
            [self setButtonEnable:NO];
        }
    }else {
        if (self.registerSMSView.textInput.length != 0 && self.registerPhoneView.textInput.length != 0 && self.registerPasswordView.textInput.length != 0) {
            [self setButtonEnable:YES];
        }else {
            [self setButtonEnable:NO];
        }
    }
}

- (void)changeRegisterBtnTitle:(NSString *)title {
    [self.registerBtn setTitle:title forState:(UIControlStateNormal)];
    
    CATransition *transition = [[CATransition alloc] init];
    transition.type = kCATransitionFade;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.duration = 0.6f;
    [self.registerBtn.layer addAnimation:transition forKey:nil];
}

- (void)setButtonEnable:(BOOL)enable {
    if (enable) {
        [self.loginBtn setBackgroundColor:RGB(255, 89, 89)];
        self.loginBtn.userInteractionEnabled = YES;
    }else {
        [self.loginBtn setBackgroundColor:RGB(242, 148, 148)];
        self.loginBtn.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.loginAccountView removeObserver:self forKeyPath:@"textInput"];
    [self.loginPasswordView removeObserver:self forKeyPath:@"textInput"];
    [self.registerSMSView removeObserver:self forKeyPath:@"textInput"];
    [self.registerPhoneView removeObserver:self forKeyPath:@"textInput"];
    [self.registerPasswordView removeObserver:self forKeyPath:@"textInput"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - AniTextFieldDelegate
- (void)aniTextFieldDidBeginEditing:(AniTextField *)aniTextField {
    if (!self.keyboardUp) {
        self.keyboardUp = YES;
        CGFloat upHeight = CGRectGetMaxY(self.logo.frame);
        [UIView animateWithDuration:0.3f animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -upHeight);
        }];
        if (self.loginViewVisible) {
            [self changeRegisterBtnTitle:@"无法登录？"];
        }else {
            [self changeRegisterBtnTitle:@"注册并同意校服协议"];
        }
    }
}

@end
