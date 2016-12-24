//
//  AniTextField.h
//  xiaofu
//
//  Created by HNF's wife on 16/7/26.
//  Copyright © 2016年 HNF's wife. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AniTextField;
@protocol AniTextFieldDelegate <NSObject>

- (void)aniTextFieldDidBeginEditing:(AniTextField *)aniTextField;

//- (BOOL)aniTextFieldShouldBeginEditing:(AniTextField *)aniTextField;

@end

@interface AniTextField : UIView

/**
 *  输入的文字内容
 */
@property (copy,nonatomic) NSString *textInput;

@property (nonatomic, weak) id <AniTextFieldDelegate>delegate;

- (instancetype)initWithLeftTitle:(NSString *)title titleFontSize:(CGFloat)titleFontSize placeholder:(NSString *)placeholder placeholderFontSize:(CGFloat)placeholderFontSize;

- (void)resignFirstResponderForTextField;
- (void)becomeFirstResponderForTextField;
- (void)hiddenClearButton;

/**
 *  回到初始状态
 */
- (void)backToOriginal;

/**
 *  输入框是否是密码. 默认NO
 */
@property (nonatomic,assign) BOOL isPassword;

/**
 *  输入框是否是数字
 */
@property (nonatomic, assign) BOOL isNumber;

@end
