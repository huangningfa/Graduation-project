//
//  ProfileCell.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/16.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "ProfileCell.h"

@interface ProfileCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.maxLength = 5;
    self.selectedBackgroundView = [[UIView alloc] init];
    self.textField.borderStyle = UITextBorderStyleNone;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingChanged)];
}

- (void)textFieldDidChange:(id)sender {
    //NSUInteger length = [self unicodeLengthOfString:self.textField.text];
    //NSLog(@"length1：%ld, length2:%ld", length, self.textField.text.length);
    if (self.textField.text.length > self.maxLength) {
        self.textField.text = [self.textField.text substringToIndex:self.maxLength];
    }
}

//按照中文两个字符，英文数字一个字符计算字符数
- (NSUInteger)unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLeftTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
