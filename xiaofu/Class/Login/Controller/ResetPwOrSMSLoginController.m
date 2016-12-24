//
//  ResetPwOrSMSLoginController.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/5.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "ResetPwOrSMSLoginController.h"
#import "AniTextField.h"
#import "UIButton+Extension.h"
#import "XFConfig.h"
#import "Utils.h"
#import <BmobSDK/Bmob.h>
#import "RootTool.h"

@interface ResetPwOrSMSLoginController ()

@property (nonatomic, weak) UIButton *cancelButton;

@property (nonatomic, copy) NSString *buttonTitle;

@property (nonatomic, weak) AniTextField *phoneView;

@property (nonatomic, weak) UIButton *button;

@property (nonatomic, weak) AniTextField *smsCodeView;

@property (nonatomic, weak) AniTextField *passwordView;

@end

@implementation ResetPwOrSMSLoginController{
    XFControllerOption option;
    BOOL sent;
}

- (instancetype)initWithControllerOption:(XFControllerOption)controllerOption {
    if (self = [super init]) {
        option = controllerOption;
        sent = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.phoneView becomeFirstResponderForTextField];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
     
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SizeMake(320, 30));
        make.centerX.offset(0);
        make.top.offset(110*SizeScale);

    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SizeMake(320, 40));
        make.centerX.offset(0);
        make.top.equalTo(self.phoneView.mas_bottom).offset(70*SizeScale);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(30);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (!sent) {
        AniTextField *textField = (AniTextField *)object;
        if (textField.textInput.length != 0) {
            [self setButtonEnable:YES];
        }else {
            [self setButtonEnable:NO];
        }
    }else {
        if (option == XFControllerOptionSMSCodeLogin) {
            if (self.smsCodeView.textInput.length != 0) {
                [self setButtonEnable:YES];
            }else {
                [self setButtonEnable:NO];
            }
        }else {
            if (self.smsCodeView.textInput.length != 0 && self.passwordView.textInput.length != 0) {
                [self setButtonEnable:YES];
            }else {
                [self setButtonEnable:NO];
            }
        }
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    
    [self.phoneView removeObserver:self forKeyPath:@"textInput"];
    if (sent) {
        [self.smsCodeView removeObserver:self forKeyPath:@"textInput"];
    }
    if (sent && (option == XFControllerOptionResetPassword)) {
        [self.passwordView removeObserver:self forKeyPath:@"textInput"];
    }
}

#pragma mark - Private Method

- (void)setButtonEnable:(BOOL)enable {
    if (enable) {
        [self.button setBackgroundColor:RGB(255, 89, 89)];
        self.button.userInteractionEnabled = YES;
    }else {
        [self.button setBackgroundColor:RGB(242, 148, 148)];
        self.button.userInteractionEnabled = NO;
    }
}

- (void)checkPhoneNumRegister {
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"mobilePhoneNumber" equalTo:self.phoneView.textInput];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [XFProgressHUD hide];
                [XFProgressHUD showInfoMsg:@"服务器异常/(ㄒoㄒ)/"];
            });
        }else if (array.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sendSMSCode];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [XFProgressHUD hide];
                [XFProgressHUD showInfoMsg:@"该手机号尚未注册"];
            });
            
        }
        
    }];
}

//- (void)sendSMSCodeAndChangeView {
//    //[self sendSMSCode];
//    [XFProgressHUD hide];
//    [self changeView];
//    sent = YES;
//}

- (void)sendSMSCode {
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneView.textInput andTemplate:nil resultBlock:^(int number, NSError *error) {
        [XFProgressHUD hide];
        if (error) {
            [XFProgressHUD showInfoMsg:@"服务器异常/(ㄒoㄒ)/"];
        }else {
            sent = YES;
            [self changeView];
        }
    }];
}

- (void)changeView {
    [self.phoneView hiddenClearButton];
    self.phoneView.userInteractionEnabled = NO;
    
    if (option == XFControllerOptionSMSCodeLogin) {
        [UIView animateWithDuration:0.5 animations:^{
            self.smsCodeView.transform = CGAffineTransformMakeTranslation(-ScreenWidth, 0);
            self.button.transform = CGAffineTransformMakeTranslation(0, (30+10)*SizeScale);
        }];
        [self.button setTitle:@"登 录" forState:(UIControlStateNormal)];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.smsCodeView.transform = CGAffineTransformMakeTranslation(-ScreenWidth, 0);
            self.passwordView.transform = CGAffineTransformMakeTranslation(-ScreenWidth, 0);
            self.button.transform = CGAffineTransformMakeTranslation(0, (30+10)*2*SizeScale);
        }];
        [self.button setTitle:@"重设密码" forState:(UIControlStateNormal)];
    }
    
    [self setButtonEnable:NO];
    [self.smsCodeView becomeFirstResponderForTextField];
}

- (void)loginUser {
    [self.view endEditing:YES];
    [XFProgressHUD showLoading:@"正在登录..."];
    [BmobUser loginInbackgroundWithMobilePhoneNumber:self.phoneView.textInput andSMSCode:self.smsCodeView.textInput block:^(BmobUser *user, NSError *error) {
        [XFProgressHUD hide];
        if (error) {
            [XFProgressHUD showFailure:@"验证码错误"];
        }else if (user) {
            // 登录成功，跳转到主界面
            [RootTool enterMainViewController];
        }
    }];
}

- (void)resetPassword {
    [self.view endEditing:YES];
    [XFProgressHUD showLoading:nil];
    [BmobUser resetPasswordInbackgroundWithSMSCode:self.smsCodeView.textInput andNewPassword:self.passwordView.textInput block:^(BOOL isSuccessful, NSError *error) {
        [XFProgressHUD hide];
        if (error) {
            [XFProgressHUD showInfoMsg:@"服务器异常/(ㄒoㄒ)/"];
        }else if (isSuccessful) {
            [XFProgressHUD showSuccess:@"成功修改密码"];
            WeakSelf;
            [XFProgressHUD sharedHUD].completionBlock = ^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            };
        }
    }];
}

#pragma mark - Target Action

- (void)buttonClicked {
    if (!sent) {
        // 1.检查手机号
        if (![Utils checkTelNumber:self.phoneView.textInput]) {
            [XFProgressHUD showFailure:@"请输入正确的手机号"];
            return;
        }
        [XFProgressHUD showLoading:nil];
        // 2.检查手机号是否已注册
        [self checkPhoneNumRegister];
    }
    
    // 3.重设密码或登录
    if (sent && option == XFControllerOptionSMSCodeLogin) {
        [self loginUser];
    }else if (sent && option == XFControllerOptionResetPassword) {
        if (![Utils checkPassword:self.passwordView.textInput]) {
            [XFProgressHUD showInfoMsg:@"密码不符合格式"];
            return;
        }
        [self resetPassword];
    }
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getters 属性

- (AniTextField *)phoneView {
    if (!_phoneView) {
        AniTextField *phoneView = [[AniTextField alloc] initWithLeftTitle:@"" titleFontSize:16 placeholder:@"手机号" placeholderFontSize:14];
        [phoneView addObserver:self forKeyPath:@"textInput" options:(NSKeyValueObservingOptionNew) context:nil];
        phoneView.isNumber = YES;
        _phoneView = phoneView;
        [self.view addSubview:phoneView];
    }
    return _phoneView;
}

- (UIButton *)button {
    if (!_button) {
        UIButton *button = [UIButton buttonWithTitle:@"发送验证码" titleColor:[UIColor whiteColor] font:XFFont backgroundColor:XFColorDark target:self action:@selector(buttonClicked)];
        _button = button;
        [self.view addSubview:button];
    }
    return _button;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //[button setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:0.5] forState:(UIControlStateNormal)];
        [button setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:(UIControlStateNormal)];
        //button.titleLabel.font = [UIFont boldSystemFontOfSize:27];
        [button addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
         //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _cancelButton = button;
        [self.view addSubview:button];
    }
    return _cancelButton;
}

- (AniTextField *)smsCodeView {
    if (!_smsCodeView) {
        AniTextField *smsCodeView = [[AniTextField alloc] initWithLeftTitle:@"" titleFontSize:16 placeholder:@"验证码" placeholderFontSize:14];
        [smsCodeView addObserver:self forKeyPath:@"textInput" options:(NSKeyValueObservingOptionNew) context:nil];
        smsCodeView.isNumber = YES;
        _smsCodeView = smsCodeView;
        [self.view addSubview:smsCodeView];
        
        [smsCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(SizeMake(320, 30));
            make.left.equalTo(self.view.mas_right).offset(self.phoneView.x);
            make.top.equalTo(self.phoneView.mas_bottom).offset(20*SizeScale);
        }];
    }
    return _smsCodeView;
}

- (AniTextField *)passwordView {
    if (!_passwordView) {
        AniTextField *passwordView = [[AniTextField alloc] initWithLeftTitle:@"" titleFontSize:16 placeholder:@"新密码(不少于6位的数字或字母)" placeholderFontSize:14];
        [passwordView addObserver:self forKeyPath:@"textInput" options:(NSKeyValueObservingOptionNew) context:nil];
        passwordView.isPassword = YES;
        _passwordView = passwordView;
        [self.view addSubview:passwordView];
        
        [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(SizeMake(320, 30));
            make.left.equalTo(self.view.mas_right).offset(self.phoneView.x);
            make.top.equalTo(self.smsCodeView.mas_bottom).offset(20*SizeScale);
        }];
    }
    return _passwordView;
}

@end
