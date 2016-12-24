//
//  ProfileImageCell.h
//  xiaofu
//
//  Created by HNF's wife on 2016/12/16.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (assign, nonatomic) BOOL modified;

@end
