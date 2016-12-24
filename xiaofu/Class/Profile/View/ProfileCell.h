//
//  ProfileCell.h
//  xiaofu
//
//  Created by HNF's wife on 2016/12/16.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (assign, nonatomic) NSUInteger maxLength;

- (void)setLeftTitle:(NSString *)title;

@end
