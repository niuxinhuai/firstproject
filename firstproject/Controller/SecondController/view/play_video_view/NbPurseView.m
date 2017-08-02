//
//  NbPurseView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/2.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NbPurseView.h"
@interface NbPurseView()
{
    CAShapeLayer * purseLayer;
    CAShapeLayer * beginLeftLayer;
    CAShapeLayer * beginRightLayer;
    CAShapeLayer * purseAnimationLayer;
    CGRect mainRect;
}

@end
@implementation NbPurseView

- (void)beginLookVideo{
    purseLayer.hidden = YES;
    purseAnimationLayer.hidden = YES;
    beginLeftLayer.hidden = NO;
    beginRightLayer.hidden = NO;
    
    
    
}
- (void)purseLookVideo{
    beginRightLayer.hidden = YES;
    beginLeftLayer.hidden = YES;
    purseAnimationLayer.hidden = NO;
    
    [self animationWithStrokeAniationWithLayer:purseAnimationLayer];


    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    purseLayer = [self getLayer];
    purseLayer.path = [self pursrPath].CGPath;
    purseLayer.hidden = NO;
  
    [self.layer addSublayer:purseLayer];
    

    beginLeftLayer = [self getLayer];
    beginLeftLayer.path = [self beginLeftPath].CGPath;
    [self.layer addSublayer:beginLeftLayer];
    
    beginRightLayer = [self getLayer];
    beginRightLayer.path = [self beginRightPath].CGPath;
    [self.layer addSublayer:beginRightLayer];
    

    purseAnimationLayer = [self getLayer];
    purseAnimationLayer.path = [self purseAnimationPath].CGPath;
    [self.layer addSublayer:purseAnimationLayer];
    

}
- (CAShapeLayer *)getLayer{
    
    CAShapeLayer * layers = [CAShapeLayer layer];
    layers.strokeColor = [UIColor whiteColor].CGColor;
    layers.fillColor = [UIColor clearColor].CGColor;
    layers.lineWidth = 3.0f;
    layers.hidden = YES;
    layers.lineCap = kCALineCapRound;
    layers.lineJoin = kCALineJoinRound;

    return layers;
}

- (UIBezierPath *)pursrPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.width, self.height/2)];
    [path addLineToPoint:CGPointMake(0, self.height)];
    [path addLineToPoint:CGPointMake(0, 0)];
    
    return path;
}

- (UIBezierPath *)beginLeftPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, self.height)];

    return path;
    
}
- (UIBezierPath *)beginRightPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.width, 0)];
    [path addLineToPoint:CGPointMake(self.width, self.height)];
    
    return path;
    
}

- (UIBezierPath *)purseAnimationPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.height)];
    [path addLineToPoint:CGPointMake(self.width, self.height/2)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, self.height)];
    
    
    
    return path;
    
}

- (void)animationWithStrokeAniationWithLayer:(CAShapeLayer *)layers{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.7;
    animation.repeatCount = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    [layers addAnimation:animation forKey:@""];
    
}



- (void)setIsPlay:(BOOL)isPlay{
    _isPlay = isPlay;
    if (_isPlay) {
        [self beginLookVideo];
    }else{
        [self purseLookVideo];
    }
    
    
    
    
}



@end
