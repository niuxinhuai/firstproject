//
//  VideoTopView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoTopView;
@protocol VideoTopViewDelegate <NSObject>

// 用户点击了关注直播
-(void)didSelectTableViewWithCell:(VideoTopView *)cellWithFoucesLive;
// 用户点击了上方某个人的头像
-(void)UserDidSelectView:(VideoTopView *)view withSelectImageTag:(NSInteger)tag;

@end

@interface VideoTopView : UIView
@property (nonatomic, weak)id<VideoTopViewDelegate>delegate;
@property (nonatomic, strong)YKLives * videoLives;
@property (nonatomic, strong)NSArray * topArray;
@end
