//
//  SingButton.h
//  userMasory
//
//  Created by 牛新怀 on 17/3/13.
//  Copyright © 2017年 CJKT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SingButtonDelegate <NSObject>
@optional
-(void)touchBeganWithPoint:(CGPoint)point;
-(void)touchEndWithPoint:(CGPoint)point;
-(void)touchMoveWithPoint:(CGPoint)point;

@end
@interface SingButton : UIButton
@property (nonatomic,weak)id<SingButtonDelegate>delegate;
@end
