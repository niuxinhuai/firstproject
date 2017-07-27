//
//  ScienceViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "ScienceViewController.h"
@interface AnimationButtonView : UIView
@property (nonatomic, assign)CGFloat viewWidth;
@property (nonatomic, assign)CGFloat viewCenterHeight;
@property (nonatomic, assign)CGRect myFrame;
@property (nonatomic, strong)CAShapeLayer * sanjiaoLayer;
@property (nonatomic, strong)CAShapeLayer * bottomLayer;
@property (nonatomic, strong)CAShapeLayer * leftVerLayer;
@property (nonatomic, strong)CAShapeLayer * rightVerLayer;
- (void)beginAnimationWithStart;
- (void)endAnimationVithStop;
@end
@implementation AnimationButtonView
-(void)drawRect:(CGRect)rect{
    _viewWidth = rect.size.width;
    _viewCenterHeight = rect.size.height/2;
    _myFrame = rect;
    _sanjiaoLayer = [self huizhiShapeLayer];
    _sanjiaoLayer.path = [self sanjiaoBezierPath].CGPath;
    //_sanjiaoLayer.strokeColor = [UIColor purpleColor].CGColor;
    [self.layer addSublayer:_sanjiaoLayer];
     _bottomLayer = [self huizhiShapeLayer];
    _bottomLayer.path = [self bottomBezierPath].CGPath;
    [self.layer addSublayer:_bottomLayer];
    [self animationWthLayer:_sanjiaoLayer];
    [self animationWthLayer:_bottomLayer];

}

-(void)beginAnimationWithStart{

    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        _leftVerLayer = [self huizhiShapeLayer];
        
        _leftVerLayer.path = [self leftVerticalBezierPath].CGPath;
        // _leftVerLayer.strokeColor = [UIColor purpleColor].CGColor;
        
            
            [self.layer addSublayer:_leftVerLayer];
        
        [self animationWthLayer:_leftVerLayer];
        
        _rightVerLayer = [self huizhiShapeLayer];
        _rightVerLayer.path = [self rightVerticalBezierPath].CGPath;
        [self.layer addSublayer:_rightVerLayer];
        [self animationWthLayer:_rightVerLayer];
    });
    


    
    dispatch_queue_t q_concurrent = dispatch_queue_create("my_concurrent_queues", DISPATCH_QUEUE_CONCURRENT);
    
   // dispatch_async(q_concurrent, ^{
        dispatch_async(q_concurrent, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:2 animations:^{
                    _sanjiaoLayer.strokeEnd = 0.01;
                    _bottomLayer.strokeEnd = 0.00001;
                    _bottomLayer.strokeColor = [UIColor clearColor].CGColor;
                    
                } completion:^(BOOL finished) {
                    // [_bottomLayer removeFromSuperlayer];
                    if (finished) {
                        //_bottomLayer.strokeColor = [UIColor clearColor].CGColor;
                        
                    }
                    
                    
                }];
                

            });
            
        });
 
        
   // });

}
- (void)endAnimationVithStop{
    //结束，暂停动画
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        _sanjiaoLayer = [self huizhiShapeLayer];
        _sanjiaoLayer.path = [self sanjiaoBezierPath].CGPath;
        //_sanjiaoLayer.strokeColor = [UIColor purpleColor].CGColor;
        [self.layer addSublayer:_sanjiaoLayer];
        _bottomLayer = [self huizhiShapeLayer];
        _bottomLayer.path = [self bottomBezierPath].CGPath;
        [self.layer addSublayer:_bottomLayer];
        [self animationWthLayer:_sanjiaoLayer];
        [self animationWthLayer:_bottomLayer];
    });
 

        
        

    
    dispatch_queue_t q_concurrent = dispatch_queue_create("my_concurrent_queuess", DISPATCH_QUEUE_CONCURRENT);
    
    // dispatch_async(q_concurrent, ^{
    dispatch_async(q_concurrent, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:2 animations:^{
                _leftVerLayer.strokeEnd = 0.1;
                _rightVerLayer.strokeEnd = 0.1;
                _rightVerLayer.strokeColor = [UIColor clearColor].CGColor;
                
            } completion:^(BOOL finished) {
                // [_bottomLayer removeFromSuperlayer];
                if (finished) {
                    //_bottomLayer.strokeColor = [UIColor clearColor].CGColor;
                    
                }
                
                
            }];
            
            
        });
        
    });
    
}


-(void)animationWthLayer:(CAShapeLayer *)layer{// 根据strokeEnd做动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.duration = 1.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    dispatch_async(dispatch_get_main_queue(), ^{
        [layer addAnimation:pathAnimation forKey:@"strokeEnd"];

        
    });
}
- (void)animationWithPosition:(CAShapeLayer *)layer withPath:(UIBezierPath *)path{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 设置动画的路径为心形路径
    animation.path = path.CGPath;
    // 动画时间间隔
    animation.duration = 1.0f;
    // 重复次数为最大值
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 将动画添加到动画视图上
    [layer addAnimation:animation forKey:@"animationPositon"];
    
    
}

- (void)animationWithPathLayer:(CAShapeLayer *)layer wittFromPath:(UIBezierPath *)path1 withEndPath:(UIBezierPath *)path2{
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = 1;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.fromValue = (id)path1.CGPath;
    fillAnimation.toValue = (id)path2.CGPath;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [layer addAnimation:fillAnimation forKey:@"path"];

    });
}
- (CAShapeLayer *)huizhiShapeLayer{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = _myFrame;
    shapeLayer.lineWidth = 5.0f;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    
    return shapeLayer;
}
- (UIBezierPath *)sanjiaoBezierPath{// 绘制上半部分三角形
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    CGPoint firstTopPoint = CGPointMake(0, _viewCenterHeight*2/5);// 第一个点
    CGPoint topPoint = CGPointMake(0, 0);
    CGPoint rightCenterPoint = CGPointMake(_viewWidth, _viewCenterHeight);//第二个点
    [bezierPath moveToPoint:firstTopPoint];
    [bezierPath addLineToPoint:topPoint];
    [bezierPath addLineToPoint:rightCenterPoint];
//    [bezierPath addLineToPoint:bottomPoint];
//    [bezierPath addLineToPoint:firstTopPoint];


    return bezierPath;
}
- (UIBezierPath *)bottomBezierPath{// 下半部分三角
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    CGPoint firstTopPoint = CGPointMake(_viewWidth, _viewCenterHeight);//第yi个点
    CGPoint bottomPoint = CGPointMake(0, _viewCenterHeight*2);
    CGPoint topEndPoint = CGPointMake(0, _viewCenterHeight*2/5);
    [bezierPath moveToPoint:firstTopPoint];
    [bezierPath addLineToPoint:bottomPoint];
    [bezierPath addLineToPoint:topEndPoint];


    return bezierPath;
}

- (UIBezierPath *)leftVerticalBezierPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, _viewCenterHeight*2)];
    return path;
}
-(UIBezierPath *)rightVerticalBezierPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_viewWidth, _viewCenterHeight)];
    [path addLineToPoint:CGPointMake(_viewWidth, 0)];
    [path addLineToPoint:CGPointMake(_viewWidth, _viewCenterHeight*2)];

    
    return path;
}
-(UIBezierPath *)bigLeftAnimationBezierPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGPoint topPoint = CGPointMake(0, 0);
    CGPoint rightCenterPoint = CGPointMake(_viewWidth, _viewCenterHeight);//第二个点
    [path moveToPoint:rightCenterPoint];
    [path addLineToPoint:topPoint];
    [path addLineToPoint:CGPointMake(0, _viewCenterHeight*2)];
    return path;
}
-(UIBezierPath *)bigRightAnimationBeizerPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
     CGPoint topEndPoint = CGPointMake(0, _viewCenterHeight*2/5);
    
    [path moveToPoint:topEndPoint];
    [path addLineToPoint:CGPointMake(0, _viewCenterHeight*2)];
    [path addLineToPoint:CGPointMake(_viewWidth*2/3, _viewCenterHeight*2)];
    [path addLineToPoint:CGPointMake(_viewWidth*2/3, 0)];

    return path;
    
}

@end

@interface ScienceViewController ()
{
    BOOL is_select;
}
@property (nonatomic, strong)AnimationButtonView * purse_startView;
@end

@implementation ScienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    is_select = NO;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor uiColorFromString:@"#1997eb"];
    [self.view addSubview:self.purse_startView];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"123");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (AnimationButtonView *)purse_startView
{
    if (!_purse_startView) {
        _purse_startView = [[AnimationButtonView alloc]init];
        _purse_startView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64)/2);
        _purse_startView.bounds = CGRectMake(0, 0, 30, 40);
        _purse_startView.backgroundColor = [UIColor clearColor];
        _purse_startView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAnimatio)];
        [_purse_startView addGestureRecognizer:tap];
    }
    
    return _purse_startView;
}
-(void)changeAnimatio{
    is_select = !is_select;
    if (is_select) {
        [self.purse_startView beginAnimationWithStart];
    }else{
        [self.purse_startView endAnimationVithStop];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
