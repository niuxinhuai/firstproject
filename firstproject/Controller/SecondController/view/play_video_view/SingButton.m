//
//  SingButton.m
//  userMasory
//
//  Created by 牛新怀 on 17/3/13.
//  Copyright © 2017年 CJKT. All rights reserved.
//


#import "SingButton.h"

@implementation SingButton



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 开始触摸屏幕
    UITouch * touche = [touches anyObject];
    CGPoint cuttentPoint = [touche locationInView:self];
    if ([self.delegate respondsToSelector:@selector(touchBeganWithPoint:)]) {
        [self.delegate touchBeganWithPoint:cuttentPoint];
    }
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 结束触摸
    UITouch * touche = [touches anyObject];
    CGPoint cuttentPoint = [touche locationInView:self];
    if ([self.delegate respondsToSelector:@selector(touchEndWithPoint:)]) {
        [self.delegate touchEndWithPoint:cuttentPoint];
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 移动手指
    UITouch * touche = [touches anyObject];
    CGPoint cuttentPoint = [touche locationInView:self];
    if ([self.delegate respondsToSelector:@selector(touchMoveWithPoint:)]) {
        [self.delegate touchMoveWithPoint:cuttentPoint];
    }
}

@end
