//
//  XFHeaderView.h
//  xiaofu
//
//  Created by HNF's wife on 2016/12/9.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BmobUser;
@interface XFHeaderView : UIView

@property (nonatomic, assign) CGPoint contentOffset;

@property (nonatomic, strong) BmobUser *user;

- (void)addTargetForHeadImage:(id)target action:(SEL)action;

- (void)setBackgroundImage:(UIImage *)image;

- (void)setHeadImage:(UIImage *)image;

@end
