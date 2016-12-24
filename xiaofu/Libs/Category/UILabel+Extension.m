//
//  UILabel+Extension.m
//  Ligo
//
//  Created by HNF's macbook on 16/5/28.
//  Copyright © 2016年 HNF. All rights reserved.
//

#import "UILabel+Extension.h"
#import "XFConfig.h"

@implementation UILabel (Extension)

+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment {
    UILabel *label = [[self alloc] init];
    label.text = title;
    label.textColor = color;
    label.font = FontSize(fontSize);
    label.textAlignment = alignment;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label;
}

+(instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment {
    UILabel *label = [[self alloc] init];
    label.text = title;
    label.textColor = color;
    label.font = font;
    label.textAlignment = alignment;
    label.numberOfLines = 0;
    [label sizeToFit];
    
    return label;
}

+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment lineSpace:(CGFloat)lineSpace {
    UILabel *label = [self labelWithTitle:title color:color fontSize:fontSize alignment:alignment];
    label.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
    label.attributedText = attributedString;
    
    return label;
}

+(instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font {
    return [self labelWithTitle:title color:color font:font alignment:(NSTextAlignmentCenter)];
}

+(instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize {
    return [self labelWithTitle:title color:color fontSize:fontSize alignment:(NSTextAlignmentCenter)];
}
@end
