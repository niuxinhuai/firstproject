//
//  ThumbAnimationView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/26.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "ThumbAnimationView.h"
@interface ThumbAnimationView()
@property (nonatomic, strong)NSArray * imageArray;
@property (nonatomic , strong) CAEmitterLayer * explosionLayer;

@end
@implementation ThumbAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect{
    NSLog(@"走了drawrect方法 ");
    
}
-(void)didselectButton{
    
   
    
    dispatch_queue_t q_concurrent = dispatch_queue_create("my_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(q_concurrent, ^{
         NSInteger tag = arc4random_uniform(3);
        NSLog(@"随机出来的数据为  %ld",tag);
        NSLog(@"并行队列 -- 异步任务 %@", [NSThread currentThread]);
        UIImageView * imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(self.frame.size.width/2+30, CGRectGetHeight(self.frame), 30, 30);
        imageV.image = [UIImage imageNamed:self.imageArray[tag]];
        imageV.alpha = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addSubview:imageV];
            
        });
        [self AnimationWithPathAndImageView:imageV];
     
        dispatch_async(q_concurrent, ^{
            dispatch_async(q_concurrent, ^{
               [self EmitterAnimationWithImageView:imageV];
                
            });
            [UIView animateWithDuration:0.6 animations:^{
                imageV.alpha = 1.0;
                CGAffineTransform transfrom = CGAffineTransformMakeScale(1.1, 1.1);
                imageV.transform = CGAffineTransformScale(transfrom, 1, 1);
                
            } completion:^(BOOL finished) {
                imageV.alpha = 0.7;
                CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
                imageV.transform = CGAffineTransformScale(transfrom, 1, 1);
                
            }];
            [UIView animateWithDuration:1 animations:^{
                imageV.alpha = 0.6;
                CGAffineTransform transfrom = CGAffineTransformMakeScale(1.6, 1.6);
                imageV.transform = CGAffineTransformScale(transfrom, 1, 1);
                
            }];
            
        });
        //粒子动画
//        dispatch_async(q_concurrent, ^{
//            
//        
//        });


     
        
    });
    
    
    
    
}
// 粒子动画
-(void)EmitterAnimationWithImageView:(UIImageView *)imageV{
    _explosionLayer = [CAEmitterLayer layer];
    
    CAEmitterCell *explosionCell = [[CAEmitterCell alloc]init];
    
    explosionCell.name = @"explosion";
    //        设置粒子颜色alpha能改变的范围
    explosionCell.alphaRange = 0.10;
    //        粒子alpha的改变速度
    explosionCell.alphaSpeed = -1.0;
    //        粒子的生命周期
    explosionCell.lifetime = 0.7;
    //        粒子生命周期的范围;
    explosionCell.lifetimeRange = 0.3;
    
    //        粒子发射的初始速度
    explosionCell.birthRate = 2500;
    //        粒子的速度
    explosionCell.velocity = 40.00;
    //        粒子速度范围
    explosionCell.velocityRange = 10.00;
    
    //        粒子的缩放比例
    explosionCell.scale = 0.03;
    //        缩放比例范围
    explosionCell.scaleRange = 0.02;
    
    
    
    
    //        粒子要展现的图片
    explosionCell.contents = (id)([[UIImage imageNamed:@"sparkle"] CGImage]);
    
    _explosionLayer.name = @"explosionLayer";
    
    //        发射源的形状
    _explosionLayer.emitterShape = kCAEmitterLayerCircle;
    //        发射模式
    _explosionLayer.emitterMode = kCAEmitterLayerOutline;
    //        发射源大小
    //    _explosionLayer.emitterSize = CGSize.init(width: 10, height: 0);
    _explosionLayer.emitterSize = CGSizeMake(5, 0);
    
    //        发射源包含的粒子
    _explosionLayer.emitterCells = @[explosionCell];
    //        渲染模式
    _explosionLayer.renderMode = kCAEmitterLayerOldestFirst;
    _explosionLayer.masksToBounds = false;
//    _explosionLayer.birthRate = 0;
     _explosionLayer.position = CGPointMake(imageV.frame.size.width/2, imageV.frame.size.height/2);
    
    
    _explosionLayer.zPosition = 0;
    [imageV.layer addSublayer:_explosionLayer];

    [self startAnimations];
    
    
    
}
- (void)startAnimations{
    _explosionLayer.beginTime = CACurrentMediaTime();
    //每秒生成多少个粒子
    _explosionLayer.birthRate = 1;
    //    perform(#selector(STPraiseEmitterBtn.stopAnimation), with: nil, afterDelay: 0.15);
    [self performSelector:@selector(stopAnimation) withObject:self afterDelay:0.15];
}
- (void)stopAnimation{
    _explosionLayer.birthRate = 0;
}


-(void)startAnimation{
    NSLog(@"走了开始动画的方法");
    [self didselectButton];
    
    
    
    
}
-(void)AnimationWithPathAndImageView:(UIImageView *)view{



    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 设置动画的路径为心形路径
    animation.path = [self getBezierPathWithAnimation].CGPath;
     animation.duration = 2.0;
    animation.repeatCount = 1;
   
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:@"123456"];
 
 
    /*
     放大缩小动画
     */
    //    CAAnimationGroup * groupAnimation = [CAAnimationGroup animation];

//    CABasicAnimation * scaleAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation1.toValue = @(1.2);
//    CABasicAnimation * scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation1.toValue = @(1.5);
//    CABasicAnimation * scaleAnimation3= [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation1.toValue = @(2.0);
//    CABasicAnimation * opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacityAnimation.toValue = [NSNumber numberWithFloat:0.6];
//    groupAnimation.fillMode = kCAFillModeForwards;//不恢复原态
//    
//    groupAnimation.removedOnCompletion = NO;
//    groupAnimation.animations = @[animation,scaleAnimation1,scaleAnimation2,opacityAnimation,scaleAnimation3];
//    // 重复次数为最大值
//
//    groupAnimation.repeatCount = 1;
//    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    // 动画时间间隔
//
//    groupAnimation.duration = 2.0;
//    // 将动画添加到动画视图上
//    [view.layer addAnimation:groupAnimation forKey:[NSString stringWithFormat:@"%uThing",arc4random_uniform(10000)]];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
        
        
    });

    
}

-(UIBezierPath *)getBezierPathWithAnimation{
    UIBezierPath * path =[UIBezierPath bezierPath];
    // 设置第一个起始点，固定点
    CGPoint sstartpoint = CGPointMake(self.frame.size.width/2+30, CGRectGetHeight(self.frame));
    [path moveToPoint:sstartpoint];
    // 设置第一个终点的位置
    CGPoint firstEndPoint = CGPointMake(self.frame.size.width/2-30 +arc4random_uniform(self.frame.size.width/2+30), CGRectGetHeight(self.frame)/2);
    [path addLineToPoint:firstEndPoint];
    // 设置第二个终点的位子
    CGPoint endpoint = CGPointMake(self.frame.size.width/2-40 +arc4random_uniform(self.frame.size.width/2+40), 10);
    [path addLineToPoint:endpoint];
    
    return path;
}

-(NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSArray arrayWithObjects:@"ThunmButton0",@"ThunmButton1",@"ThunmButton2",@"ThunmButton3", nil]
        ;
    }
    
    return _imageArray;
}
@end
