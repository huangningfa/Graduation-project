//
//  DisplayView.h
//  xiaofu
//
//  Created by HNF's wife on 2016/11/30.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayView : UIButton

@property (nonatomic, copy) NSString *text;

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font;

- (void)backToOriginal;

@end
