//
//  VideoBottomView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/26.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
typedef NS_ENUM(NSInteger,BottomButtonTag){
    BottomButtonLeftTag = 10,
    BottomButtonCenterOneTag,
    BottomButtonCenterTwoTag, 
    BottomButtonCenterThreeTag
};

#import <UIKit/UIKit.h>
@class VideoBottomView;
@protocol VideoBottomViewDelegate <NSObject>

-(void)didSelectaView:(VideoBottomView *)view withSelectButtonTag:(NSInteger)tag;

@end
@interface VideoBottomView : UIView
@property (nonatomic, weak)id<VideoBottomViewDelegate>delegate;
@property (nonatomic, assign)BottomButtonTag buttonTagType;
@end
