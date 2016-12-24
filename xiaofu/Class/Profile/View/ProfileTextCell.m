//
//  ProfileTextCell.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/16.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "ProfileTextCell.h"

@interface ProfileTextCell () <UITextViewDelegate>

@end

@implementation ProfileTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //NSLog(@"frameW %f", self.textView.frame.size.width);
    //NSLog(@"contentH %f W%f", self.textView.contentSize.height, self.textView.contentSize.width);
    if ([keyPath isEqualToString:@"contentSize"]){
        UITextView *tv = object;
        CGFloat deadSpace = ([tv bounds].size.height - tv.contentSize.height);
        //NSLog(@"deadspace %f", deadSpace);
        CGFloat inset = MAX(-2, deadSpace/2.0);
        tv.contentInset = UIEdgeInsetsMake(inset, tv.contentInset.left, inset, tv.contentInset.right);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger len = textView.text.length;
    if (len > 0) {
        self.placeholder.hidden = YES;
    }else {
        self.placeholder.hidden = NO;
    }
    if (textView.markedTextRange == nil && textView.text.length > 20) {
        textView.text = [textView.text substringToIndex:20];
    }
}


- (void)dealloc {
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
}

@end
