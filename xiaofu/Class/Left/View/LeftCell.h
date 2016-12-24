//
//  LeftCell.h
//  xiaofu
//
//  Created by HNF's wife on 2016/11/20.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftCell : UITableViewCell

@property (copy, nonatomic) NSString *imageName;

@property (copy, nonatomic) NSString *text;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
