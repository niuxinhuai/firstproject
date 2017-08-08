//
//  PracticesViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "PracticesViewController.h"
#import "SingButton.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoTime.h"
#import "NbPurseView.h"
#import "UIView+BLLandscape.h"

@interface PracticesViewController ()<SingButtonDelegate>
@property (strong,nonatomic) SingButton * button;// 滑动，快进，快退，按钮
@property (assign,nonatomic) Direction direction;
@property (assign, nonatomic)          BOOL  isReadToPlay;//用来判断当前视频是否准备好播放。
@property (strong, nonatomic)          UISlider *avSlider; //用来现实视频的播放进度，并且通过它来控制视频的快进快退
@property (strong, nonatomic)          UIView *playerCustomView;
@property (assign, nonatomic)          CGFloat  getTotalTime;
@property (strong, nonatomic)          AVPlayer * myPlayer;
@property (strong, nonatomic)          AVPlayerItem * playerItems;
@property (nonatomic, strong)          AVPlayerLayer * playerLayers;
@property (assign, nonatomic)          CGPoint startPoint;
@property (assign, nonatomic)          CGFloat startVb;
@property (assign, nonatomic)          CGFloat startVideoRate;
@property (strong, nonatomic)          MPVolumeView * volumeView;
@property (strong, nonatomic)          UISlider * volumeViewSlider;
@property (assign, nonatomic)          CGFloat currentRate;
@property (strong, nonatomic)          UILabel * rightLabel;
@property (strong, nonatomic)          UILabel * timeLabel;
@property (strong, nonatomic)          UIView * backView;
@property (assign, nonatomic)          BOOL isHide;
@property (strong,nonatomic)           UIButton * voiceButton;// 声音按钮
@property (strong,nonatomic)           UIButton * allScreenButton;// 全屏按钮
@property (strong, nonatomic)          NbPurseView * stop_beginButton; // 开始暂停按钮
@property (strong, nonatomic)          UIView * purse_playView;
@property (assign, nonatomic)          BOOL is_start;
@property (strong, nonatomic)          UIImageView * videoFrameImageV;

@end

@implementation PracticesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithVideo{
    [self.view addSubview:self.playerCustomView];
    NSString * str =@"http://baobab.wdjcdn.com/1456665467509qingshu.mp4";
    NSURL * url = [NSURL URLWithString:str];
    _playerItems = [AVPlayerItem playerItemWithURL:url];
    
    
    _myPlayer = [AVPlayer playerWithPlayerItem:_playerItems];
    
    _playerLayers = [AVPlayerLayer playerLayerWithPlayer:_myPlayer];
    _playerLayers.videoGravity =  AVLayerVideoGravityResizeAspectFill;
    [self.playerCustomView.layer addSublayer:_playerLayers];
    _playerLayers.frame = self.playerCustomView.bounds;
    
    // playerLayers.backgroundColor =[UIColor grayColor].CGColor;
    // [self upLoadPlayerWithUrl:url];
    // [_myPlayer play];
    [_playerItems addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
   
    self.button = [[SingButton alloc]initWithFrame:self.playerCustomView.bounds];
    //self.button.backgroundColor = [UIColor cyanColor];
    self.button.delegate = self;
    [self.playerCustomView addSubview:self.button];
     [self.playerCustomView addSubview:self.videoFrameImageV];
    self.backView.hidden = NO;
    self.volumeView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*9.0/16.0);
    _is_start = NO;
    [self.playerCustomView addSubview:self.purse_playView];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chousePlayerLayerPlayOrPuser)];
    [self.button addGestureRecognizer:gesture];
    [self.avSlider addTarget:self action:@selector(touchSliderWithAction) forControlEvents:UIControlEventTouchUpInside|
     UIControlEventTouchUpOutside|
     UIControlEventTouchCancel];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self removeObserver:self forKeyPath:@"status"];
    [self.myPlayer pause];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [self.myPlayer pause];

}
-(UIView *)playerCustomView{
    if (!_playerCustomView) {
        _playerCustomView = [[UIView alloc]init];
        _playerCustomView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 100);
        _playerCustomView.backgroundColor = [UIColor whiteColor];
        CGRect rect = _playerCustomView.frame;
        
        rect.size.height = CGRectGetWidth(_playerCustomView.frame)*9/16;
        _playerCustomView.frame = rect;
    }
    
    
    return _playerCustomView;
}

#pragma mark - SignButtonDelegate
-(void)touchBeganWithPoint:(CGPoint)point{
    
    // 记录首次触摸坐标
    self.startPoint = point;
    //检测用户是触摸屏幕的那个方向，以此判断用户想要调节音量还是亮度／／／左边亮度。右边音量
    if (self.startPoint.x <= self.button.frame.size.width/2) {
        // 亮度
        self.startVb = [UIScreen mainScreen].brightness;
    }else{
        // 音量
        self.startVb = self.volumeViewSlider.value;
    }
    CMTime ctime = self.myPlayer.currentTime;
    self.startVideoRate = ctime.value/ctime.timescale/_getTotalTime;
    
    
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        [self.backView addSubview:_timeLabel];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.view bringSubviewToFront:_timeLabel];
        
        
    }
    
    
    return _timeLabel;
}
-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        [self.backView addSubview:_rightLabel];
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.font = [UIFont systemFontOfSize:12];
        
        
    }
    
    return _rightLabel;
}
-(void)touchMoveWithPoint:(CGPoint)point{
    // 得出手指在button上移动的距离
    CGPoint panPoint = CGPointMake(point.x-self.startPoint.x, point.y-self.startPoint.y);
    // 分析用户滑动的方向
    if (self.direction == DirectionNone) {
        if (panPoint.x >=30 || panPoint.x<=-30) {
            self.direction = DirectionLeftOrRight;
        }else if (panPoint.y >=30 || panPoint.y <=-30){
            // 音量和亮度
            self.direction = DirectionUpOrDown;
        }
    }
    if (panPoint.x >=30 || panPoint.x<=-30) {
        self.direction = DirectionLeftOrRight;
    }else if (panPoint.y >=30 || panPoint.y <=-30){
        // 音量和亮度
        self.direction = DirectionUpOrDown;
    }
    if (self.direction == DirectionNone) {
        return;
    }else if (self.direction == DirectionUpOrDown){
        // 音量和亮度
        if (self.startPoint.x <= self.button.frame.size.width/2.0) {
            //当前屏幕左侧。 调节亮度
            if (panPoint.y <0) {
                // 向上,增加亮度
                [[UIScreen mainScreen] setBrightness:self.startVb+(-panPoint.y/30.0/10)];
            }else{
                // 减少亮度
                [[UIScreen mainScreen] setBrightness:self.startVb-(panPoint.y/30.0/10)];
            }
        }else{
            // 在屏幕右侧。为调控音量
            if (panPoint.y <0) {
                // 增加音量。向上
                [self.volumeViewSlider setValue:self.startVb+(-panPoint.y/30.0/10) animated:YES];
                if (self.startVb+(-panPoint.y/30/10)-self.volumeViewSlider.value >=1) {
                    [self.volumeViewSlider setValue:0.1 animated:NO];
                    [self.volumeViewSlider setValue:self.startVb+(-panPoint.y/30.0/10) animated:YES];
                }
                
                
            }else{
                // 减少音量
                [self.volumeViewSlider setValue:self.startVb-(panPoint.y/30.0/10) animated:YES];
            }
        }
    }else if (self.direction == DirectionLeftOrRight){
        // 进度
        CGFloat rate = self.startVideoRate+(panPoint.x/30.0/20.0);
        
        
        if (rate >1) {
            rate =1;
        }else if (rate <0){
            rate =0;
        }
        self.videoFrameImageV.hidden = NO;
        UIImage * getImage = [VideoTime thumbnailImageForVideo:[NSURL URLWithString:@"http://baobab.wdjcdn.com/1456665467509qingshu.mp4"] atTime:rate];
        self.videoFrameImageV.image = getImage;
        [self performSelector:@selector(issMissImageV) withObject:nil afterDelay:1];
        self.currentRate = rate;
    }
    
}
-(void)issMissImageV{
    self.videoFrameImageV.hidden = YES;
}
-(void)touchEndWithPoint:(CGPoint)point{
    if (self.direction == DirectionLeftOrRight) {
        [self.myPlayer seekToTime:CMTimeMakeWithSeconds(_getTotalTime*self.startVideoRate, 1) completionHandler:^(BOOL finished) {
            
            
            
            
            
        }];
    }
    
    
}
#pragma mark - KVO_Video
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    //if ([keyPath isEqualToString:@"contentOffset"]) {
    //  NSLog(@"%@",change);
    //可以监测到scroll的偏移量
    
    
    // return;
    // }
    
    // 取出status的新值
    AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
    switch (status) {
        case AVPlayerItemStatusFailed:{
            NSLog(@"itme有误");
            self.isReadToPlay = NO;
            break;
        }
        case AVPlayerItemStatusReadyToPlay:{
            NSLog(@"已经准备好播放");
            self.isReadToPlay = YES;
            self.avSlider.maximumValue = _playerItems.duration.value/_playerItems.duration.timescale;
            //  CMTime dutation = _playerItems.duration;// 获取视频总长度
            CGFloat totalSeconds = _playerItems.duration.value/_playerItems.duration.timescale;// 转换成秒
            NSString * totalStr = [VideoTime convertTime:totalSeconds];// 转换成播放时间
            NSLog(@"%@",totalStr);
            _getTotalTime = [totalStr floatValue];
            self.rightLabel.text = totalStr;
            CGSize rightSize = [self.rightLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            self.rightLabel.center = CGPointMake(CGRectGetMaxX(self.avSlider.frame)+14, CGRectGetHeight(self.backView.frame)/2);
            self.rightLabel.bounds = CGRectMake(0, 0, rightSize.width, 20);
            self.timeLabel.text = @"00:00";
            CGSize size = [self.timeLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
            self.timeLabel.center = CGPointMake(CGRectGetMinX(self.avSlider.frame)-15, CGRectGetHeight(self.backView.frame)/2);
            self.timeLabel.bounds = CGRectMake(0, 0, size.width, 20);
            __weak typeof (self) weakSelf = self;
            
            
            [_playerLayers.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
                CGFloat currentSecond = _playerItems.currentTime.value/_playerItems.currentTime.timescale;// 计算当前的第几秒
                //            weakSelf.avSlider.maximumValue = currentSecond;
                weakSelf.startVideoRate = currentSecond;
                weakSelf.avSlider.value = currentSecond;
                NSString * timeString = [VideoTime convertTime:currentSecond];
                
                weakSelf.timeLabel.text = timeString;
                CGSize size = [weakSelf.timeLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
                weakSelf.timeLabel.center = CGPointMake(CGRectGetMinX(self.avSlider.frame)-15, CGRectGetHeight(self.backView.frame)/2);
                weakSelf.timeLabel.bounds = CGRectMake(0, 0, size.width, 20);
                
                
                //               weakSelf.timeLabel.frame = CGRectMake(CGRectGetMinX(weakSelf.avSlider.frame)-size.width-10, CGRectGetMaxY(weakSelf.playerCustomView.frame)-23, size.width, 20);
                
            }];
            
            
            break;
        }
        case AVPlayerItemStatusUnknown:{
            NSLog(@"未知错误");
            self.isReadToPlay = NO;
            
            break;
        }
            
        default:
            break;
    }
    
    
    
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        _isHide = YES;
        [self.playerCustomView addSubview:_backView];

//            [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(self.playerCustomView.mas_centerX);
//                make.centerY.mas_equalTo(self.playerCustomView.mas_bottom).offset(-20);
//                make.width.mas_equalTo(self.playerCustomView.mas_width);
//                make.height.mas_equalTo(@40);
//                
//            }];
        _backView.frame = CGRectMake(0, CGRectGetHeight(self.playerCustomView.frame)-40, self.playerCustomView.width, 40);
        
        
        [_backView layoutIfNeeded];
        [_backView addSubview:self.allScreenButton];
        [_backView addSubview:self.voiceButton];
        
        
    }
    
    
    return _backView;
}
-(MPVolumeView *)volumeView{
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc]init];
        [_volumeView sizeToFit];
        for (UIView * view in [_volumeView subviews]) {
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
                self.volumeViewSlider = (UISlider*)view;
            }
        }
        
    }
    
    return _volumeView;
}
// 创建一个进度条
-(UISlider*)avSlider{
    if (!_avSlider) {
        _avSlider = [[UISlider alloc]init];
        _avSlider.center = CGPointMake(self.playerCustomView.frame.size.width/2, 20);
        _avSlider.bounds = CGRectMake(0, 0, CGRectGetWidth(self.playerCustomView.frame)-160, 7);
        [self.backView addSubview:_avSlider];
        _avSlider.maximumTrackTintColor = [UIColor uiColorFromString:@"#9f9f9f"];
        _avSlider.minimumTrackTintColor = [UIColor uiColorFromString:@"#1997eb"];
        // UIImage * image = [self originImage:[UIImage imageNamed:@"极光.jpg"] scaleToSize:CGSizeMake(12, 12)];
        [_avSlider setThumbImage:[self imageWithColor:[UIColor uiColorFromString:@"#1997eb"] size:CGSizeMake(12, 12)] forState:UIControlStateNormal];
        // _avSlider.thumbTintColor = [UIColor purpleColor];// 滑轮的颜色
    }
    
    
    return _avSlider;
}
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    UIImage *image = nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark - 静音
-(UIButton *)voiceButton{
    if (!_voiceButton) {
        _voiceButton = [VideoTime createButtonWithImageName:@"haveVoices" withTag:UserChouseButtonTagWithVoice];
        _voiceButton.frame = CGRectMake(10, 5, 30, 30);
        [_voiceButton addTarget:self action:@selector(doAnythingWithTag:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    
    return _voiceButton;
    
}
-(UIButton *)allScreenButton{
    if (!_allScreenButton) {
        _allScreenButton = [VideoTime createButtonWithImageName:@"fillScreen" withTag:UserChouseButtonTagWithFillScreen];
        _allScreenButton.frame = CGRectMake(SCREEN_WIDTH-40, 5, 30, 30);
        [_allScreenButton addTarget:self action:@selector(doAnythingWithTag:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    
    return _allScreenButton;
}

- (UIImageView *)videoFrameImageV{
    if (!_videoFrameImageV) {
        _videoFrameImageV = [[UIImageView alloc]init];
        _videoFrameImageV.center = CGPointMake(SCREEN_WIDTH/2, CGRectGetHeight(self.playerCustomView.frame)/2);
        _videoFrameImageV.bounds = CGRectMake(0, 0, 80, 80);
        _videoFrameImageV.contentMode = UIViewContentModeScaleAspectFill;
        _videoFrameImageV.hidden = YES;
        
    }
    
    return _videoFrameImageV;
}

-(void)doAnythingWithTag:(UIButton*)sender{
    sender.hidden = NO;
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case UserChouseButtonTagWithBegin:{// 开始暂停
            BOOL playerPlay =sender.selected ? YES :NO;
            if (playerPlay) {
                [self.myPlayer play];
                [sender setImage:[UIImage imageNamed:@"stopPlay"] forState:UIControlStateNormal];
            }else{
                [self.myPlayer pause];
                [sender setImage:[UIImage imageNamed:@"beginPlay"] forState:UIControlStateNormal];
            }
            [UIView animateWithDuration:4 animations:^{
                sender.hidden = YES;
                
            }];
            
            break;
        }
        case UserChouseButtonTagWithVoice:{// 是否开启声音／第一次点击为关闭
            BOOL voicePlays =sender.selected ? YES :NO;
            if (voicePlays) {
                [sender setImage:[UIImage imageNamed:@"noVoices"] forState:UIControlStateNormal];
                [self.volumeViewSlider setValue:0 animated:YES];
            }else{
                [self.volumeViewSlider setValue:0.3 animated:YES];
                [sender setImage:[UIImage imageNamed:@"haveVoices"] forState:UIControlStateNormal];
            }
            
            break;
        }
        case UserChouseButtonTagWithFillScreen:{// 是否全屏
            BOOL screenPlays =sender.selected ? YES :NO;

            if (screenPlays) {// 横屏
                [self.playerCustomView bl_landscapeAnimated:YES animations:^{
                 
                    [self landscapeAnimationView];
                    [sender setImage:[UIImage imageNamed:@"noFillScreen"] forState:UIControlStateNormal];

                } complete:^{
                    
                    
                }];
                
                


            }else{
                [self.playerCustomView bl_protraitAnimated:YES animations:^{
                    [self protraitAnimation];
                    [sender setImage:[UIImage imageNamed:@"fillScreen"] forState:UIControlStateNormal];

                } complete:^{
                    
                    
                }];

                
            }
//            
//            
            break;
        }
//            
        default:
            break;
    }
    
    
    
}
#pragma mark - 横屏需要
- (void)landscapeAnimationView{
    /*
     需要横屏的视图
     */
     _playerLayers.frame = self.playerCustomView.bounds;
    /*
     底部承载空间的视图
     */
       self.backView.frame = CGRectMake(0, self.playerCustomView.bounds.size.height-40, self.playerCustomView.bounds.size.width, 40);
    /*
     中间开始暂停控件
     */
    self.purse_playView.center =CGPointMake(SCREEN_HEIGHT/2, SCREEN_WIDTH/2);
    self.purse_playView.bounds = CGRectMake(0, 0, 30, 30);
    
    /*
     底部Slider
     */
    self.avSlider.center = CGPointMake(CGRectGetWidth(self.playerCustomView.bounds)/2, 20);
    self.avSlider.bounds = CGRectMake(0, 0, CGRectGetWidth(self.backView.frame)-160, 7);
    
    CGSize rightSize = [self.rightLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.rightLabel.center = CGPointMake(CGRectGetMaxX(self.avSlider.frame)+14, CGRectGetHeight(self.backView.frame)/2);
    self.rightLabel.bounds = CGRectMake(0, 0, rightSize.width, 20);
    
     self.allScreenButton.frame = CGRectMake(CGRectGetWidth(self.backView.frame)-40, 5, 30, 30);
    self.button.frame = CGRectMake(0, 0, self.playerCustomView.height, self.playerCustomView.width);
    
}
#pragma mark - 竖屏需要
- (void)protraitAnimation{
    
    self.backView.frame = CGRectMake(0, CGRectGetHeight(self.playerCustomView.frame)-40, self.playerCustomView.width, 40);
    _playerLayers.frame = self.playerCustomView.bounds;
    /*
     中间开始暂停控件
     */
    self.purse_playView.center =CGPointMake(CGRectGetWidth(self.playerCustomView.bounds)/2, CGRectGetHeight(self.playerCustomView.frame)/2);
    self.purse_playView.bounds = CGRectMake(0, 0, 30, 30);
    
    /*
     下边滚动条
     */
    self.avSlider.center = CGPointMake(CGRectGetWidth(self.playerCustomView.bounds)/2, 20);
    self.avSlider.bounds = CGRectMake(0, 0, CGRectGetWidth(self.backView.frame)-160, 7);
    
    CGSize rightSize = [self.rightLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.rightLabel.center = CGPointMake(CGRectGetMaxX(self.avSlider.frame)+14, CGRectGetHeight(self.backView.frame)/2);
    self.rightLabel.bounds = CGRectMake(0, 0, rightSize.width, 20);
    self.allScreenButton.frame = CGRectMake(CGRectGetWidth(self.backView.frame)-40, 5, 30, 30);
    self.button.frame = CGRectMake(0, 0, self.playerCustomView.width, self.playerCustomView.height);
    
    
}
#pragma mark - Slider滑动代理
-(void)touchSliderWithAction{
    // slider 的value值为视频的时间
    float seconds = self.avSlider.value;
    // 让视频从制定的CMTime对象处播放
    CMTime startTime = CMTimeMakeWithSeconds(seconds, _playerItems.currentTime.timescale);
    // 让视频从制定处播放
    [self.myPlayer seekToTime:startTime completionHandler:^(BOOL finished) {
        [self chousePlayerLayerPlayOrPuser];
        
    }];
    
    
}
-(void)chousePlayerLayerPlayOrPuser{
    // if (self.isReadToPlay) {
    //  [self.myPlayer play];
    // }else{
    //   NSLog(@"正在加载中。。。");
    //}
    
    _isHide = !_isHide;
    
   // self.backView.hidden = _isHide;
    //self.beginOrStopButton.hidden = _isHide;
    
    if (_isHide ==NO) {
        self.backView.alpha = 1;
       // [self performSelector:@selector(changeViewSHowOrHide) withObject:self afterDelay:3];
    }
    
}
- (UIView *)purse_playView{
    if (!_purse_playView) {
        _purse_playView = [[UIView alloc]init];
        _purse_playView.center =CGPointMake(SCREEN_WIDTH/2, CGRectGetHeight(self.playerCustomView.frame)/2);
        _purse_playView.bounds = CGRectMake(0, 0, 30, 30);
        _purse_playView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        _purse_playView.layer.cornerRadius = 15;
        _purse_playView.clipsToBounds = YES;
        [_purse_playView addSubview:self.stop_beginButton];
    }
    
    
    return _purse_playView;
}



- (NbPurseView *)stop_beginButton{
    if (!_stop_beginButton) {
        _stop_beginButton = [[NbPurseView alloc]init];
        _stop_beginButton.center =CGPointMake(self.purse_playView.width/2, self.purse_playView.height/2);
        _stop_beginButton.bounds = CGRectMake(0, 0, 12, 12);
        _stop_beginButton.userInteractionEnabled = YES;
        _stop_beginButton.backgroundColor = [UIColor clearColor];

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(begin_star_gesture)];
        [_stop_beginButton addGestureRecognizer:tap];
        
    }
    
    
    return _stop_beginButton;
}
- (void)begin_star_gesture{
    _is_start = !_is_start;
    if (_is_start) {
        [self.stop_beginButton setIsPlay:YES];
        [self.myPlayer play];
        
    }else{
        [self.stop_beginButton setIsPlay:NO];
         [self.myPlayer pause];
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
