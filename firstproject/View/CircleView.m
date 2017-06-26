//
//  CircleView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/16.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "CircleView.h"
@interface CircleView ()
@property (nonatomic, strong)UIBezierPath * bezierPath;
@property (nonatomic, strong)CAShapeLayer * shapeLayer;
@end
@implementation CircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect{
    self.shapeLayer.path = [self getBezierWithSuperFrame:rect].CGPath;
    self.shapeLayer.frame = self.bounds;
    [self.layer addSublayer:self.shapeLayer];
    
}
-(CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineWidth =_lineWidth;
        if (_strokeColors) {
            _shapeLayer.strokeColor = _strokeColors.CGColor;

        }else{
            _shapeLayer.strokeColor = [UIColor cyanColor].CGColor;
        }
        if (_fillColors) {
            _shapeLayer.fillColor =_fillColors.CGColor;

        }else{
            _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        }
        
    }
    
    return _shapeLayer;
}


-(UIBezierPath *)getBezierWithSuperFrame:(CGRect)rect{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft |UIRectCornerTopRight cornerRadii:CGSizeMake(rect.size.width/2, rect.size.width/2)];
    _bezierPath = path;
    
    
    return path;
}


@end
