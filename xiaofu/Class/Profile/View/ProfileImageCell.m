//
//  ProfileImageCell.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/16.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "ProfileImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface ProfileImageCell ()


@end

@implementation ProfileImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedBackgroundView = [[UIView alloc] init];
    [self.headView sd_setImageWithURL:[XFUser getUserHeadImageURL]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
