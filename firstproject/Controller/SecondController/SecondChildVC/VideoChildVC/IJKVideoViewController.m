//
//  IJKVideoViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "IJKVideoViewController.h"
#import <IJKMediaFramework/IJKFFMoviePlayerController.h>
#import "VideoTopView.h"
#import "VideoBottomView.h"
#import "FoucesView.h"
#import "ThumbAnimationView.h"
#import "ShareView.h"

@interface IJKVideoViewController ()<VideoTopViewDelegate,VideoBottomViewDelegate>
@property (nonatomic, strong)UIImageView * bgBackImageView;
@property (nonatomic, strong)IJKFFMoviePlayerController * player;
@property (nonatomic, strong)VideoTopView * topView;
@property (nonatomic, strong)VideoBottomView * BottomView;
@property (nonatomic, strong)UILabel * liveNameLabel;
@property (nonatomic, strong)FoucesView * foucesView;
@property (nonatomic, strong)UIScrollView * BgScrollView;
@property (nonatomic, strong)UIView * leftBottomView;
@property (nonatomic, strong)UIScrollView * rightBottomScrollView;
@property (nonatomic, strong)ThumbAnimationView * animationView;
@property (nonatomic, strong)ShareView * shareView;

@end

@implementation IJKVideoViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UISwipeGestureRecognizer * gesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(disMissVc)];
    [self.view addGestureRecognizer:gesture];
}
-(void)disMissVc{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setVideoStream_addr:(NSString *)videoStream_addr{
    _videoStream_addr = videoStream_addr;
    if (!_videoStream_addr) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSString * str = @"192.168.2.219:8080/app/supervise/lookPhoto/599bff4ed4aa3a27ecc33ecd";
    NSURL * url = [NSURL URLWithString:_videoStream_addr];
    IJKFFMoviePlayerController * playerVC = [[IJKFFMoviePlayerController alloc]initWithContentURL:url withOptions:nil];
    // 准备播放
    [playerVC prepareToPlay];
    // 强引用， 防止正在播放被销毁
    _player = playerVC;
    playerVC.view.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:playerVC.view];
    [playerVC play];
    self.BgScrollView.backgroundColor = [UIColor clearColor];
    [self.BgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];

    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_player pause];
    [_player stop];
    _player = nil;
}
//- (void)dealloc{
//    [_player pause];
//    [_player stop];
//    _player = nil;
//}

-(void)setVideoLives:(YKLives *)videoLives{
    _videoLives = videoLives;
    if (!_videoLives) {
        return;
    }
    self.topView.videoLives = _videoLives;
    self.BottomView.backgroundColor = [UIColor clearColor];

    if (_videoLives.name) {
         self.liveNameLabel.textColor = [UIColor yellowColor];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
         
            [UIView animateWithDuration:10.0 animations:^{
                CGRect rect = self.liveNameLabel.frame;
                rect.origin.x = -SCREEN_WIDTH;
                self.liveNameLabel.frame = rect;
                
            } completion:^(BOOL finished) {
                self.liveNameLabel.hidden = YES;
                
            }];
            
        });
    }
 

    
    
}

-(void)setScrollArray:(NSArray *)scrollArray{
    _scrollArray = scrollArray;
    if (_scrollArray.count ==0) {
        return;
    }
    self.topView.topArray = _scrollArray;
    
    
}
-(UILabel *)liveNameLabel{
    if (!_liveNameLabel) {
        _liveNameLabel = [[UILabel alloc]init];
       
        _liveNameLabel.text = [NSString stringWithFormat:@"直播标题 : %@",_videoLives.name];
        _liveNameLabel.font = [UIFont systemFontOfSize:15];
        _liveNameLabel.textAlignment = NSTextAlignmentCenter;
        CGSize size = [Tool widthWithText:_liveNameLabel.text Font:[UIFont systemFontOfSize:15]];
        _liveNameLabel.frame = CGRectMake(SCREEN_WIDTH, CGRectGetMaxY(self.topView.frame)+20, size.width+20, size.height+10);
        _liveNameLabel.layer.cornerRadius = CGRectGetHeight(_liveNameLabel.frame)/2;
        _liveNameLabel.clipsToBounds = YES;
        [_liveNameLabel.layer setBorderColor:[UIColor yellowColor].CGColor];
        [_liveNameLabel.layer setBorderWidth:1.0];
        [self.view addSubview:_liveNameLabel];
    }
    
    
    return _liveNameLabel;
}
-(VideoTopView*)topView{
    if (!_topView) {
        _topView = [[VideoTopView alloc]init];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        _topView.backgroundColor = [UIColor clearColor];
        _topView.delegate = self;
        [self.rightBottomScrollView addSubview:_topView];
        
    }
    
    return _topView;
}
-(VideoBottomView *)BottomView{
    if (!_BottomView) {
        _BottomView = [[VideoBottomView alloc]init];
        _BottomView.frame = CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200);
        _BottomView.delegate = self;
        [self.rightBottomScrollView addSubview:_BottomView];
    }
    
    return _BottomView;
}
-(FoucesView *)foucesView{
    if (!_foucesView) {
        _foucesView = [[FoucesView alloc]init];
        _foucesView.frame = CGRectMake(0, -100, SCREEN_WIDTH, 100);
        [self.view addSubview:_foucesView];
    }
    
    return _foucesView;
}
#pragma mark - VideoTapViewDelegate
-(void)didSelectTableViewWithCell:(VideoTopView *)cellWithFoucesLive{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"StartOnce"]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"StartOnce"]isEqualToString:@"秦时明月"]) {
            return;
        }
    }
    // 自定义用户点击了关注按钮，弹出提醒框
    self.foucesView.backgroundColor = [UIColor cyanColor]
    ;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.foucesView.frame;
        rect.origin.y = 0;
        self.foucesView.frame = rect;
        
    } completion:^(BOOL finished) {
      
        
    }];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect = self.foucesView.frame;
            rect.origin.y = -100;
            self.foucesView.frame = rect;
            
        } completion:^(BOOL finished) {
            self.foucesView.hidden = YES;
            
        }];
    
        
    });

    [[NSUserDefaults standardUserDefaults]setObject:@"秦时明月" forKey:@"StartOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];


    
}
-(void)UserDidSelectView:(VideoTopView *)view withSelectImageTag:(NSInteger)tag{
    // 点击用户头像做弹框
    
}
-(void)dissMIssChildV{
    if (self.shareView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.center = CGPointMake(self.shareView.center.x, SCREEN_HEIGHT+120);
            
        }];
    }
   
}

#pragma mark - VideoBottomViewDelegate
-(void)didSelectaView:(VideoBottomView *)view withSelectButtonTag:(NSInteger)tag{
    switch (tag) {
        case BottomButtonLeftTag:
        {
            NSLog(@"点击了评论");
            self.shareView.backgroundColor = [UIColor clearColor];
            [UIView animateWithDuration:0.3 animations:^{
                self.shareView.center = CGPointMake(self.shareView.center.x, SCREEN_HEIGHT-120);
                
            }];

            break;
        }
        case BottomButtonCenterOneTag:
        {
            NSLog(@"点击了礼物");
         

            break;
        }
        case BottomButtonCenterTwoTag:
        {
            NSLog(@"点击了点赞");
            self.animationView.backgroundColor = [UIColor clearColor];

            [self.animationView startAnimation];
            break;
        }
        case BottomButtonCenterThreeTag:
        {
            NSLog(@"点击了退出界面");
   
          
          
            [self.navigationController popViewControllerAnimated:YES];


            break;
        }
            
        default:
            break;
    }
    
}


-(UIScrollView *)BgScrollView{
    if (!_BgScrollView) {
        _BgScrollView = [[UIScrollView alloc]init];
        _BgScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _BgScrollView.pagingEnabled = YES;
        _BgScrollView.scrollEnabled = YES;
        _BgScrollView.showsVerticalScrollIndicator = NO;
        _BgScrollView.showsHorizontalScrollIndicator = NO;
        _BgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
        [self.view addSubview:_BgScrollView];
        [_BgScrollView addSubview:self.leftBottomView];
        [_BgScrollView addSubview:self.rightBottomScrollView];
    }
    return _BgScrollView;
    
}
-(UIView *)leftBottomView{
    if (!_leftBottomView) {
        _leftBottomView = [[UIView alloc]init];
        _leftBottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _leftBottomView.userInteractionEnabled=  YES;
        _leftBottomView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissMissVC)];
        tap.numberOfTapsRequired = 2;
        [_leftBottomView addGestureRecognizer:tap];
    }
    return _leftBottomView;
}
-(UIScrollView *)rightBottomScrollView{
    if (!_rightBottomScrollView) {
        _rightBottomScrollView = [[UIScrollView alloc]init];
        _rightBottomScrollView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _rightBottomScrollView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissMIssChildV)];
        [_rightBottomScrollView addGestureRecognizer:gesture];
    }
    
    return _rightBottomScrollView;
}
-(ThumbAnimationView *)animationView{
    if (!_animationView) {
        _animationView = [[ThumbAnimationView alloc]init];
        _animationView.frame = CGRectMake(SCREEN_WIDTH-200, 0, 200, CGRectGetHeight(self.BottomView.frame)-40);
        [self.BottomView addSubview:_animationView];
    }
    
    
    return _animationView;
}
-(void)dissMissVC{
    [self.navigationController popViewControllerAnimated:YES];

}
-(UIImageView *)bgBackImageView{
    if (!_bgBackImageView) {
        _bgBackImageView = [[UIImageView alloc]init];
        _bgBackImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _bgBackImageView.backgroundColor = [UIColor clearColor];
    }
    
    return _bgBackImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(ShareView *)shareView{
    if (!_shareView) {
        _shareView = [[ShareView alloc]init];
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240);
        [self.rightBottomScrollView addSubview:_shareView];
    }
    
    return _shareView;
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
