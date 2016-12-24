//
//  AniTextField.m
//  xiaofu
//
//  Created by HNF's wife on 16/7/26.
//  Copyright © 2016年 HNF's wife. All rights reserved.
//

#import "AniTextField.h"
#import "UILabel+Extension.h"
#import "XFConfig.h"

#define TitleWidth 80*SizeScale

@interface AniTextField () <UITextFieldDelegate>

@property (weak, nonatomic) UITextField *textFiled;
@property (weak, nonatomic) UILabel *placerLabel;
@property (weak, nonatomic) UIButton *clearBtn;

@end

@implementation AniTextField

{
    BOOL isNull;
    CGFloat labelH;
}

-(instancetype)initWithLeftTitle:(NSString *)title titleFontSize:(CGFloat)titleFontSize placeholder:(NSString *)placeholder placeholderFontSize:(CGFloat)placeholderFontSize {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        //默认动画
        isNull = YES;
        labelH = 20;
        
        //左边Title
        UILabel *titleLabel = [UILabel labelWithTitle:title color:[UIColor blackColor] fontSize:titleFontSize alignment:(NSTextAlignmentLeft)];
        //titleLabel.frame = CGRectMake(0, 0, 100, self.height);
        [self addSubview:titleLabel];
        
        //占位符
        UILabel *placeL = [UILabel labelWithTitle:placeholder color:[[UIColor grayColor] colorWithAlphaComponent:0.5]  fontSize:placeholderFontSize alignment:(NSTextAlignmentLeft)];
        //placeL.frame = CGRectMake(titleLabel.right, 0, self.width - titleLabel.width, self.height);
        self.placerLabel = placeL;
        [self addSubview:placeL];
        
        //输入框
        UITextField *tf = [[UITextField alloc] init];
        //tf.frame = CGRectMake(titleLabel.right, 0, self.width - titleLabel.width, self.height);
        tf.borderStyle = UITextBorderStyleNone;
        tf.font = FontSize(titleFontSize);
        tf.delegate = self;
        [tf addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
        self.textFiled = tf;
        [self addSubview:tf];
        
        // ×
        UIButton *clearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [clearBtn setTitle:@"×" forState:(UIControlStateNormal)];
        [self addSubview:clearBtn];
        self.clearBtn = clearBtn;
        clearBtn.hidden = YES;
        clearBtn.titleLabel.font = FontSize(24);
        clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [clearBtn setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:0.5] forState:(UIControlStateNormal)];
        [clearBtn addTarget:self action:@selector(clearText)];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.centerY.equalTo(titleLabel.superview).offset(5);
            if ([title isEqualToString:@""]) {
                make.width.mas_equalTo(0);
            }else {
                make.width.mas_equalTo(80*SizeScale);
            }
            make.height.equalTo(titleLabel.superview.mas_height);
        }];

        [@[placeL, tf] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right);
            make.centerY.equalTo(placeL.superview);
            make.height.equalTo(placeL.superview.mas_height);
            make.right.offset(0);
        }];
        
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.centerY.offset(0);
        }];
        
    }
    return self;
}

-(void)setIsPassword:(BOOL)isPassword {
    _isPassword = isPassword;
    self.textFiled.secureTextEntry = isPassword;

}

- (void)setIsNumber:(BOOL)isNumber {
    _isNumber = isNumber;
    self.textFiled.keyboardType = UIKeyboardTypeNumberPad;
}

-(void)valueChange:(UITextField*)sender{
    
    [self animationBound];
    self.clearBtn.hidden = NO;
    //取出当前输入的文字
    self.textInput = sender.text;
    if (sender.text.length == 0) {
        [self backToOriginal];
    }
    
}

- (void)setTextInput:(NSString *)textInput {
    _textInput = textInput;
    //self.textFiled.text = textInput;
    //_placerLabel.alpha = 0.0;
    
}

- (void)clearText {
    self.textFiled.text = nil;
    [self valueChange:self.textFiled];
}

- (void)backToOriginal {
    isNull = YES;
    self.textInput = nil;
    _placerLabel.alpha = 1.0;
    self.textFiled.text = nil;
    self.clearBtn.hidden = YES;
    self.placerLabel.frame = self.textFiled.frame;
}

- (void)resignFirstResponderForTextField {
    [self.textFiled resignFirstResponder];
}

- (void)becomeFirstResponderForTextField {
    [self.textFiled becomeFirstResponder];
}

- (void)hiddenClearButton {
    [UIView animateWithDuration:0.8 animations:^{
        self.clearBtn.alpha = 0;
    }];
    self.clearBtn.hidden = YES;
}

#pragma mark -弹簧的动画
-(void)animationBound{
    CGRect labelRect = self.placerLabel.frame ;
    if (isNull) {
        isNull = NO;
        labelRect.origin.y = self.textFiled.frame.origin.y - self.textFiled.frame.size.height + 10*SizeScale;
        //开始描写动画效果
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.placerLabel.frame = labelRect;
        } completion:nil];
    }else if (!_textFiled.text.length){
        isNull = YES;
        labelRect.origin.y = self.textFiled.frame.origin.y;
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.placerLabel.frame = labelRect;
        } completion:nil];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0, self.height);
    CGContextAddLineToPoint(context, self.width, self.height);
    
    [[[UIColor grayColor] colorWithAlphaComponent:0.5] set];
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextStrokePath(context);
    
}

#pragma mark -TextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(aniTextFieldDidBeginEditing:)]) {
        [self.delegate aniTextFieldDidBeginEditing:self];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_textFiled.text.length != 0) {
        [UIView animateWithDuration:0.8 animations:^{
            _placerLabel.alpha = 0.0;
        }];
    }
    
}

@end
