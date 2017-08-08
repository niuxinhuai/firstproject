//
//  ThermometerView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/7/31.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "ThermometerView.h"
@interface ThermometerView()
@property (nonatomic, strong)CAShapeLayer * thermometerLayer;


@end
@implementation ThermometerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self getBezierPath];
    [self drawLineOfDashByCAShapeLayer:self lineLength:1 lineSpacing:3 lineColor:[UIColor lightGrayColor] lineDirection:YES];
}

- (void)setFillColors:(UIColor *)fillColors{
    _fillColors = fillColors;
    
}
- (void)setStrokeColors:(UIColor *)strokeColors{
    _strokeColors = strokeColors;
   // self.thermometerLayer.strokeColor = _strokeColors.CGColor;
    
    
}
- (void)setStrokeEndBissniss:(CGFloat)strokeEndBissniss{
    _strokeEndBissniss = strokeEndBissniss;

    
}
- (void)start{
    [self customBezierPath];

}

#pragma mark - 获得路径

- (void)customBezierPath{
    UIBezierPath * bezierPath;
    if (_strokeEndBissniss<0.8) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width*_strokeEndBissniss, self.frame.size.height) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.frame.size.height/2, self.frame.size.height/2)];
    }else{
         bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width*_strokeEndBissniss, self.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.frame.size.height/2, self.frame.size.height/2)];
        
    }

    
    self.thermometerLayer.path = bezierPath.CGPath;
    self.thermometerLayer.fillColor = _fillColors.CGColor;
    self.thermometerLayer.strokeEnd = _strokeEndBissniss;

    

    

    [self.layer addSublayer:self.thermometerLayer];

    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0);
    endAnimation.toValue = @(1);
    
    CAAnimationGroup *step2 = [CAAnimationGroup animation];
    step2.animations = @[endAnimation];
    step2.duration = 10;
    step2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.thermometerLayer addAnimation:step2 forKey:@"changenimationLayer"];
   
}


- (void)getBezierPath{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) cornerRadius:self.frame.size.height/2];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:layer];
   
}
#pragma mark - 绘制layer
- (CAShapeLayer *)thermometerLayer{
    if (!_thermometerLayer) {
        _thermometerLayer = [CAShapeLayer layer];
        
    }
    
    return _thermometerLayer;
}



/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setBounds:lineView.bounds];
    
    if (isHorizonal) {
        
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)*3/4)];
        
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)/2];
    } else {
        
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 7, 0);
    
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame)-6, 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end
