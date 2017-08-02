//
//  ScienceViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "ScienceViewController.h"
#import "ThermometerView.h"
@interface motionView : UIView
@property (nonatomic, strong)CAShapeLayer * motionLayer;

@end



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


    


    __weak typeof (self)weakSelf =self;
    dispatch_queue_t q_concurrent = dispatch_queue_create("my_concurrent_queues", DISPATCH_QUEUE_CONCURRENT);
    

        dispatch_async(q_concurrent, ^{
            dispatch_async(q_concurrent, ^{
                [weakSelf strokeEndAniationWithStroke:0.01 withLayer:_sanjiaoLayer];
                
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                dispatch_async(q_concurrent, ^{
                    
                    _rightVerLayer = [self huizhiShapeLayer];
                    _rightVerLayer.path = [weakSelf rightVerticalBezierPath].CGPath;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [weakSelf.layer addSublayer:_rightVerLayer];
                        
                         });
                        [weakSelf strokeEndAnimationWithLayer:_rightVerLayer];
                });

                    
                    
                    
                    
                });

            });
            dispatch_async(q_concurrent, ^{
                [weakSelf strokeEndAniationWithStroke:0 withLayer:_bottomLayer];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        dispatch_async(q_concurrent, ^{
                            
                            _leftVerLayer = [self huizhiShapeLayer];
                            
                            _leftVerLayer.path = [weakSelf leftVerticalBezierPath].CGPath;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [weakSelf.layer addSublayer:_leftVerLayer];
                                [weakSelf strokeEndAnimationWithLayer:_leftVerLayer];
                            });
                            
                            
                            
                        });
                
                    });
                
                
            });

            
        });

}
- (void)endAnimationVithStop{
    //结束，暂停动画
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//
//
//    });
 

        
        

    __weak typeof (self)weakSelf =self;

    dispatch_queue_t q_concurrent = dispatch_queue_create("my_concurrent_queuess", DISPATCH_QUEUE_CONCURRENT);
    
    // dispatch_async(q_concurrent, ^{
    dispatch_async(q_concurrent, ^{

        dispatch_async(q_concurrent, ^{
            [weakSelf strokeEndAniationWithStroke:0.01 withLayer:_leftVerLayer];
            
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    dispatch_async(q_concurrent, ^{
                        _sanjiaoLayer = [weakSelf huizhiShapeLayer];
                        _sanjiaoLayer.path = [weakSelf sanjiaoBezierPath].CGPath;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [weakSelf.layer addSublayer:_sanjiaoLayer];
                            
                        });
                        [weakSelf animationWthLayer:_sanjiaoLayer];
                        
                        
                    });

            
                });
            
        });
        dispatch_async(q_concurrent, ^{
            [weakSelf strokeEndAniationWithStroke:0.01 withLayer:_rightVerLayer];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    dispatch_async(q_concurrent, ^{
                        _bottomLayer = [weakSelf huizhiShapeLayer];
                        _bottomLayer.path = [weakSelf bottomBezierPath].CGPath;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [weakSelf.layer addSublayer:_bottomLayer];
                            
                        });
                        [weakSelf animationWthLayer:_bottomLayer];
                        
                    });

            
                });
            
        });

        
    });
    
}

- (void)strokeEndAniationWithStroke:(CGFloat)strokeValues withLayer:(CAShapeLayer *)layer{
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.duration = 0.5;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.toValue = @(strokeValues);
    dispatch_async(dispatch_get_main_queue(), ^{
        [layer addAnimation:pathAnimation forKey:@"strokeEnd"];
        
        
    });
    
    
}
#pragma mark - 左右垂直线条抖动动画
- (void)strokeEndAnimationWithLayer:(CAShapeLayer *)layer{
    CAKeyframeAnimation * keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    keyAnimation.values = @[@0.3,@0.5,@0.7,@.9,@1.0,@0.9,@0.8,@0.9,@1.0];
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.duration = 1.3;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [layer addAnimation:keyAnimation forKey:@"moveKeyAnimations"];
    });
}
#pragma mark - 起始界面绘制三角形动画
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
#pragma mark - 根据路径做动画， 未用到
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
    shapeLayer.lineWidth = 2.0f;
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

- (UIBezierPath *)leftVerticalBezierPath{// 绘制左侧垂直线条路径
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, _viewCenterHeight*2)];
    return path;
}
-(UIBezierPath *)rightVerticalBezierPath{// 绘制右侧垂直线条路径
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_viewWidth, _viewCenterHeight)];
    [path addLineToPoint:CGPointMake(_viewWidth, 0)];
    [path addLineToPoint:CGPointMake(_viewWidth, _viewCenterHeight*2)];
    [path addLineToPoint:CGPointMake(_viewWidth, 0)];

    
    return path;
}

@end

@interface ScienceViewController ()
{
    BOOL is_select;
}
@property (nonatomic, strong)AnimationButtonView * purse_startView;
@property (nonatomic, strong)UIView * animation_xAnimationView;
@property (nonatomic, strong)ThermometerView * rmometerView;
@end

@implementation ScienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    is_select = NO;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor uiColorFromString:@"#1997eb"];
    [self.view addSubview:self.purse_startView];
   // [self.view addSubview:self.animation_xAnimationView];
    [self.view addSubview:self.rmometerView];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"123");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)animation_xAnimationView{
    if (!_animation_xAnimationView) {
        _animation_xAnimationView = [[UIView alloc]init];
        _animation_xAnimationView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-200);
        _animation_xAnimationView.bounds = CGRectMake(0, 0, 100, 20);
        _animation_xAnimationView.layer.cornerRadius = 10;
        _animation_xAnimationView.clipsToBounds = YES;
        _animation_xAnimationView.backgroundColor = [UIColor orangeColor];
        
    }
    
    return _animation_xAnimationView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self strokeEndAniationWithStroke:0.8 withLayer:self.animation_xAnimationView.layer];

}
- (void)strokeEndAniationWithStroke:(CGFloat)strokeValues withLayer:(CALayer *)layer{
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.duration = 0.5;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.toValue = @(strokeValues);
    dispatch_async(dispatch_get_main_queue(), ^{
        [layer addAnimation:pathAnimation forKey:@"strokeEnd"];
        
        
    });
    
    
}


- (AnimationButtonView *)purse_startView
{
    if (!_purse_startView) {
        _purse_startView = [[AnimationButtonView alloc]init];
        _purse_startView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64)/2);
        _purse_startView.bounds = CGRectMake(0, 0, 20, 25);
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

- (ThermometerView *)rmometerView{
    if (!_rmometerView) {
        _rmometerView = [[ThermometerView alloc]init];
        _rmometerView.frame = CGRectMake(50, 60, 100, 20);
        _rmometerView.fillColors = [UIColor redColor];
       // _rmometerView.strokeColors = [UIColor lightGrayColor];
        _rmometerView.strokeEndBissniss = 0.7;
        _rmometerView.backgroundColor = [UIColor clearColor];
    }
    
    return _rmometerView;
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
