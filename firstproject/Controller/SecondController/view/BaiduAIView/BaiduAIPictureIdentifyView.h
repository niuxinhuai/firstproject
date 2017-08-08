//
//  BaiduAIPictureIdentifyView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/8/4.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaiduAIPictureIdentifyView;
@protocol PictureIdentifyDelegate <NSObject>
- (void)baiduAiViewClassNameView:(BaiduAIPictureIdentifyView *)view;


@end
@interface BaiduAIPictureIdentifyView : UIView
@property (weak, nonatomic)id<PictureIdentifyDelegate>delegate;
+ (instancetype)shareInstanceView;
@property (strong, nonatomic)UIImage * imageNamed;
@end
