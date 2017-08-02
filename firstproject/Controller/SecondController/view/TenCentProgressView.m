//
//  TenCentProgressView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/1.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "TenCentProgressView.h"

@implementation TenCentProgressView

- (void)tencentStartAnimation{
//    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
//    rotationAnimation.duration = 1;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = MAXFLOAT;
//    [self.animationLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2*M_PI);
    animation.duration = 1.f;
    animation.repeatCount = INT_MAX;
    [self.animationLayer addAnimation:animation forKey:@"keyFrameAnimation"];
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

//    CAShapeLayer * circleLayer = [CAShapeLayer layer];
//    circleLayer.path = [self circlePath].CGPath;
//    circleLayer.strokeColor = [UIColor lightGrayColor].CGColor;
//    circleLayer.fillColor = [UIColor clearColor].CGColor;
//    circleLayer.lineWidth = 3.0;
//    [self.layer addSublayer:circleLayer];
    
    
    
    self.animationLayer = [CAShapeLayer layer];
    self.animationLayer.path = [self bezierPaths].CGPath;
    self.animationLayer.fillColor = [UIColor clearColor].CGColor;
    self.animationLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.animationLayer.lineWidth = 2.5;
    self.animationLayer.lineCap = kCALineCapRound;
    self.animationLayer.lineJoin = kCALineJoinRound;
   
    [self.layer addSublayer:self.animationLayer];


    
    

}

- (UIBezierPath *)bezierPaths{
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.height/2 startAngle:-M_PI_4*2 endAngle:M_PI_4 clockwise:YES];
    
    
    return path;
    
}

- (UIBezierPath *)circlePath{
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.height/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    
    return path;
}


@end
