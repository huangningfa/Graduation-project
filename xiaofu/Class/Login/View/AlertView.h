//
//  AlertView.h
//  xiaofu
//
//  Created by HNF's wife on 16/7/26.
//  Copyright © 2016年 HNF's wife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIButton

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *titleColor;

- (instancetype)initWithFirstTitle:(NSString *)first secondTitle:(NSString *)second target:(id)target firstAction:(SEL)firstAction secondAction:(SEL)secondAction;

- (void)show;

@end
