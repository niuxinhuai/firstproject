//
//  VideoTableViewCell.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoTableViewCell;
@protocol VideoTableViewCellDelegate <NSObject>
// 行高
-(void)videoTableViewCellWithCell:(VideoTableViewCell *)cell withCellHeight:(CGFloat)height;

@end
@interface VideoTableViewCell : UITableViewCell
@property (nonatomic , weak)id<VideoTableViewCellDelegate>delegate;
@property (nonatomic, strong)YKLives * videoLives;
@end
