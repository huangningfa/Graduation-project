//
//  GenderView.m
//  xiaofu
//
//  Created by HNF's wife on 2016/11/29.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "GenderView.h"
#import "UILabel+Extension.h"
#import "UIButton+Extension.h"
#import "XFConfig.h"

@interface GenderView ()

@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation GenderView

- (instancetype)initWithTitleFontSize:(CGFloat)titleFontSize {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *genderLabel = [UILabel labelWithTitle:@"性别" color:[[UIColor grayColor] colorWithAlphaComponent:0.5] fontSize:titleFontSize alignment:(NSTextAlignmentLeft)];
        [self addSubview:genderLabel];
        
        UIButton *maleButton = [UIButton buttonWithTitle:@"男" titleColor:[[UIColor grayColor] colorWithAlphaComponent:0.5] font:FontSize(titleFontSize) imageName:@"man" target:self action:@selector(buttonClicked:)];
        [self addSubview:maleButton];
        
        UIButton *femaleButton = [UIButton buttonWithTitle:@"女" titleColor:[[UIColor grayColor] colorWithAlphaComponent:0.5] font:FontSize(titleFontSize) imageName:@"woman" target:self action:@selector(buttonClicked:)];
        [self addSubview:femaleButton];
        
        // 约束
        [genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(0);
        }];
        
        [maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.centerX.offset(-50*SizeScale);
            make.size.mas_equalTo(CGSizeMake(40, 18));
        }];
        
        [femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.centerX.offset(50*SizeScale);
            make.size.mas_equalTo(CGSizeMake(40, 18));
        }];
    }
    return self;
}

- (void)buttonClicked:(UIButton *)sender {
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    self.selectedGender = sender.titleLabel.text;
}

@end
