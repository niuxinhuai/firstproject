//
//  VideoTopView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "VideoTopView.h"
#import <UIImageView+WebCache.h>
#import "UIImage+XFCircle.h"
#import <UIButton+WebCache.h>
@interface VideoTopView()
@property (strong, nonatomic)UIView * leftBgView;
@property (strong, nonatomic)UIImageView *leftUserImageView;
@property (strong, nonatomic)UILabel * liveLabel;
@property (strong, nonatomic)UILabel * onLineLabel;
@property (nonatomic, strong)UILabel * userIDLabel;
@property (strong, nonatomic)UIButton * focusButton;
@property (strong, nonatomic)UIScrollView * topScrollViews;
@property (strong, nonatomic)UIButton * heardButton;
@end
@implementation VideoTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setVideoLives:(YKLives *)videoLives{
    _videoLives = videoLives;
    if (!_videoLives) {
        return;
    }
    [self addSubview:self.leftBgView];
      NSURL * url = [NSURL URLWithString:_videoLives.creator.portrait];
    [self.leftUserImageView sd_setImageWithURL:url];
    self.liveLabel.text = @"直播";
    NSString * str = [NSString stringWithFormat:@"%.f",videoLives.onlineUsers];
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];

    self.onLineLabel.frame = CGRectMake(CGRectGetMinX(self.liveLabel.frame), CGRectGetMaxY(self.liveLabel.frame)+2, size.width, size.height);
    self.onLineLabel.text = str;
    [self.leftBgView addSubview:self.focusButton];
    
    
    
    
}
-(void)setTopArray:(NSArray *)topArray{
    _topArray = topArray;
    self.topScrollViews.backgroundColor = [UIColor clearColor];
    CGFloat scaleW = 5.0;
    CGFloat w=0;
    for (int idx =0; idx<_topArray.count; idx++) {
        YKLives * model = _topArray[idx];
        //UIImage * image = [UIImage imageNamed:model.creator.portrait];
        UIButton * button = [self createButtonWithFrame:CGRectMake(w+scaleW, 0, 30, 30) withImage:nil withButtonTag:idx+10];
        [button sd_setImageWithURL:[NSURL URLWithString:model.creator.portrait] forState:UIControlStateNormal];
        w = button.frame.origin.x+button.frame.size.width;
        [self.topScrollViews addSubview:button];
        self.topScrollViews.contentSize = CGSizeMake(w, 0);
    }

}

-(UIView *)leftBgView{
    if (!_leftBgView) {
        _leftBgView = [[UIView alloc]init];
        _leftBgView.frame = CGRectMake(10, 20, 140, 30);
        _leftBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _leftBgView.layer.cornerRadius = 15;
        _leftBgView.clipsToBounds = YES;
    }
    
    return _leftBgView;
}
-(UIImageView *)leftUserImageView{
    if (!_leftUserImageView) {
        _leftUserImageView = [[UIImageView alloc]init];
        _leftUserImageView.center = CGPointMake(15, 15);
        _leftUserImageView.bounds = CGRectMake(0, 0, 30, 30);
        [self.leftBgView addSubview:_leftUserImageView];
        _leftUserImageView.layer.cornerRadius = 15;
        _leftUserImageView.clipsToBounds = YES;
    }
    
    return _leftUserImageView;
}
-(UILabel *)liveLabel{
    if (!_liveLabel) {
        _liveLabel = [[UILabel alloc]init];
        _liveLabel.frame = CGRectMake(CGRectGetMaxX(self.leftUserImageView.frame)+10, 2, 40, 14);
        _liveLabel.textColor = [UIColor whiteColor];
        _liveLabel.font = [UIFont systemFontOfSize:12];
        [self.leftBgView addSubview:_liveLabel];
    }
    
    
    return _liveLabel;
}

-(UILabel *)onLineLabel{
    if (!_onLineLabel) {
        _onLineLabel = [[UILabel alloc]init];
        _onLineLabel.font = [UIFont systemFontOfSize:10];
        _onLineLabel.textColor = [UIColor whiteColor];
        [self.leftBgView addSubview:_onLineLabel];
        
    }
    
    
    
    return _onLineLabel;
    
}
-(UILabel *)userIDLabel{
    if (!_userIDLabel) {
        _userIDLabel = [[UILabel alloc]init];
        _userIDLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self addSubview:_userIDLabel];
        
    }
    
    
    
    return _userIDLabel;
    
    
}
-(UIButton *)focusButton{
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [_focusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _focusButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _focusButton.frame = CGRectMake(CGRectGetWidth(self.leftBgView.frame)-43, 3, 40, 25);
        _focusButton.layer.cornerRadius = CGRectGetHeight(_focusButton.frame)/2;
        _focusButton.clipsToBounds = YES;
        [_focusButton addTarget:self action:@selector(userChangeFouces:) forControlEvents:UIControlEventTouchUpInside];
        [self createMask];
        _focusButton.backgroundColor =[UIColor cyanColor];

    }
    
    
    return _focusButton;
}




- (void)createMask
{
    /*
     @parameter
     @parameter
     @parameter
     @parameter
     CAGradientLayer *layer = [CAGradientLayer layer];
     layer.frame = _focusButton.bounds;
     layer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor clearColor].CGColor];
     //layer.colors = @[(id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor];
     layer.locations = @[@(0.25),@(0.5),@(0.75)];
     //layer.locations = @[@(0.1),@(0.15),@(0.2)];
     layer.startPoint = CGPointMake(0, 0);
     layer.endPoint = CGPointMake(1, 0);
     _focusButton.layer.mask = layer;
     
     layer.position = CGPointMake(-_focusButton.frame.size.width/4.0, _focusButton.frame.size.height/2.0);
     
     
     */
    UIView * maskView = [[UIView alloc]init];
    maskView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
    maskView.frame = CGRectMake(-10, -10, 10, 80);
    maskView.clipsToBounds = YES;
    [_focusButton addSubview:maskView];
    maskView.transform = CGAffineTransformMakeRotation(M_PI/4);
    
    [self iPhoneFadeWithDuration:1.2 withView:maskView];

    
}

- (void)iPhoneFadeWithDuration:(NSTimeInterval)duration withView:(UIView *)cusV
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"transform.translation.x";
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(60);
    basicAnimation.duration = duration;
    basicAnimation.repeatCount = 2;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [cusV.layer addAnimation:basicAnimation forKey:@"123"];
  //  [cusV.layer. addAnimation:basicAnimation forKey:nil];
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [cusV removeFromSuperview];
//    });
    
}

-(void)userChangeFouces:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectTableViewWithCell:)]) {
        [self.delegate didSelectTableViewWithCell:self];
    }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        sender.hidden = YES;
        // 点击了关注
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect = self.leftBgView.frame;
            rect.size.width = 90;
            self.leftBgView.frame = rect;
            CGRect frame = self.topScrollViews.frame;
            frame.origin.x =CGRectGetMaxX(self.leftBgView.frame)+10;
            frame.size.width =SCREEN_WIDTH-CGRectGetMaxX(self.leftBgView.frame)-10;
            self.topScrollViews.frame = frame;
            
        }];
       
    });

    
    
}
-(UIScrollView *)topScrollViews{
    if (!_topScrollViews) {
        _topScrollViews = [[UIScrollView alloc]init];
        _topScrollViews.scrollEnabled = YES;
        _topScrollViews.frame = CGRectMake(CGRectGetMaxX(self.leftBgView.frame)+10, CGRectGetMinY(self.leftBgView.frame), SCREEN_WIDTH-CGRectGetMaxX(self.leftBgView.frame)-10, 30);
        _topScrollViews.showsHorizontalScrollIndicator = NO;
        [self addSubview:_topScrollViews];
        
        
        
    }
    
    
    return _topScrollViews;
}



-(UIButton *)createButtonWithFrame:(CGRect)rect withImage:(UIImage *)image withButtonTag:(NSInteger)tag{
    UIButton * button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.layer.cornerRadius = rect.size.height/2;
    button.clipsToBounds = YES;
    button.tag = tag;
    [button addTarget:self action:@selector(changeSelectSenderClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return button;
}

-(void)changeSelectSenderClick:(UIButton *)sender{
    
    NSLog(@"%ld",sender.tag);
    if ([self.delegate respondsToSelector:@selector(UserDidSelectView:withSelectImageTag:)]) {
        [self.delegate UserDidSelectView:self withSelectImageTag:sender.tag-10];
    }
    
    
}
@end
