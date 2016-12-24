//
//  UIBarButtonItem+Extension.m
//  Ligo
//
//  Created by HNF's macbook on 16/5/30.
//  Copyright © 2016年 HNF. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:(UIControlStateHighlighted)];
    //button.size = CGSizeMake(30, 30);
    [button sizeToFit];
    //button.size = button.currentBackgroundImage.size;
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (NSArray *)itemsWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    negativeSpacer.width = -5;
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithImageName:imageName highImageName:highImageName target:target action:action];
    
    return @[negativeSpacer, item];
}

@end
