//
//  MainViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
#import <CoreMotion/CoreMotion.h>
#import "MainViewController.h"
#import "VideoViewController.h"
#import "LLView.h"
#import "UIImage+ImageEffects.h"
#import <Accelerate/Accelerate.h>
@interface MainViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *pushButton;
@property (strong, nonatomic) UIScrollView * verticalScroll;
@property (strong, nonatomic) NSArray * titleArrays;
@property (strong, nonatomic) NSTimer * myTimer;
@property (strong, nonatomic) UILabel * countLabel;
@property (strong, nonatomic) CMPedometer * step;// 计步器
@property (strong, nonatomic) CMMotionManager * CMmanager;
@property (strong, nonatomic) UIImageView * imageV;
@end

@implementation MainViewController


- (instancetype)initWithUrl:(NSString *)url{
    self  = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.colorType = ButtonItemTitleColorTypeBlue;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView * animationImageView = [[UIImageView alloc]init];
    animationImageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    animationImageView.bounds = CGRectMake(0, 0, 200, 200);
//    animationImageView.layer.cornerRadius = 20;
//    animationImageView.clipsToBounds = YES;
    animationImageView.userInteractionEnabled = YES;
   // animationImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage * sourseImage = [UIImage imageNamed:@"cjktLogo"];
    UIImage * endImage = [MainViewController boxblurImage:sourseImage withBlurNumber:1];
    animationImageView.image = endImage;
    [self.view addSubview:animationImageView];
//    UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//  //  UIVibrancyEffect *brancy = [UIVibrancyEffect effectForBlurEffect:effect];
//    UIVisualEffectView * visual = [[UIVisualEffectView alloc]initWithEffect:effect];
//    visual.frame = self.view.bounds;
//  
//    [self.view addSubview:visual];
    
    UIButton * pushButtons = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButtons.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-64);
    pushButtons.bounds = CGRectMake(0, 0, 100, 100);
    pushButtons.backgroundColor = [UIColor whiteColor];
    [pushButtons setTitle:@"PUSH" forState:UIControlStateNormal];
    [pushButtons setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [pushButtons addTarget:self action:@selector(pushViewControllers) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButtons];
    
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.center = CGPointMake(SCREEN_WIDTH/2, CGRectGetMaxY(pushButtons.frame)+20);
    self.countLabel.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.backgroundColor = [UIColor whiteColor];
    self.countLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.countLabel];
    self.step = [CMPedometer new];
    if (![CMPedometer isStepCountingAvailable ]) {
        NSLog(@"不可用");
        return;
    }
    //开始计步
    
    [self.step startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        NSLog(@"%@",pedometerData.numberOfSteps);
        self.countLabel.text =[NSString stringWithFormat:@"%@",pedometerData.numberOfSteps];
    }];
    

    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageNamed:nil target:self action:@selector(pushOtherViewController)];
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changed:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    self.CMmanager = [CMMotionManager new];
//    if ([self .CMmanager isAccessibilityElement]) {
    self.CMmanager.accelerometerUpdateInterval=1.0;
        [self.CMmanager startAccelerometerUpdates];
  //  }
    //开始采集
    [self.CMmanager startAccelerometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        if (error) {
            NSLog(@"出错 %@",error);
        }else{
            CGFloat X=accelerometerData.acceleration.x;
            CGFloat Y=accelerometerData.acceleration.y;
            CGFloat Z=accelerometerData.acceleration.z;
            NSLog(@"%.f\n%.f\n%.f",X,Y,Z);
           // NSLog(@"x轴:%f y轴:%f z轴:%f",X,Y,Z);
        }
    }];

    _imageV = [[UIImageView alloc]init];
    
    _imageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_imageV];
    
    
   
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CMAccelerometerData* data= self.CMmanager.accelerometerData;
    CGFloat X=data.acceleration.x;
    CGFloat Y=data.acceleration.y;
    CGFloat Z=data.acceleration.z;
    NSLog(@"x轴:%f y轴:%f z轴:%f",X,Y,Z);
}


-(void)changed:(NSNotification *)notifier{
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"//////////////靠近了");
    }else{
        
        NSLog(@"------------离开了");
    }
    
}
-(BOOL)canBecomeFirstResponder{
    return YES;// 将当前vc作为第一响应者
}

//开始摇一摇
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    NSLog(@"用户摇一摇");
}
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    //摇一摇被打断(比如摇的过程中来电话)
    NSLog(@"摇一摇被打断(比如摇的过程中来电话)");
    
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    //摇一摇结束的时候操作
    NSLog(@"摇一摇结束的时候操作");
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.verticalScroll.backgroundColor = [UIColor whiteColor];

    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(changeScrollContentOffSetY) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
}
-(void)viewWillDisappear:(BOOL)animated{
    [_myTimer invalidate];
    _myTimer = nil;
}
-(void)changeScrollContentOffSetY{
    //启动定时器
    CGPoint point = self.verticalScroll.contentOffset;
    [self.verticalScroll setContentOffset:CGPointMake(0, point.y+CGRectGetHeight(self.verticalScroll.frame)) animated:YES];
}
-(void)pushOtherViewController{
    LLView * vc = [[LLView alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)pushAnotherViewController:(id)sender {
    VideoViewController * vc = [[VideoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    vc.backBlock = ^(UIImage * image){
//                CATransition *animation = [CATransition animation];
//                animation.duration = 1.5f;
//                animation.timingFunction = UIViewAnimationCurveEaseInOut;
//                animation.fillMode = kCAFillModeForwards;
//                //基本型
//                animation.type = kCATransitionFade;
//                //私有API，字符串型
//                
//               // animation.type = @"cameraIrisHollowOpen";
//                [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
//    };

         
        /*
         以下是基本的四种效果
         kCATransitionPush 推入效果
         kCATransitionMoveIn 移入效果
         kCATransitionReveal 截开效果
         kCATransitionFade 渐入渐出效果
         
         以下API效果可以安全使用
         cube 方块
         suckEffect 三角
         rippleEffect 水波抖动
         pageCurl 上翻页
         pageUnCurl 下翻页
         oglFlip 上下翻转
         cameraIrisHollowOpen 镜头快门开
         cameraIrisHollowClose 镜头快门开
         
         以下API效果请慎用
         spewEffect 新版面在屏幕下方中间位置被释放出来覆盖旧版面.
         genieEffect 旧版面在屏幕左下方或右下方被吸走, 显示出下面的新版面
         unGenieEffect 新版面在屏幕左下方或右下方被释放出来覆盖旧版面.
         twist 版面以水平方向像龙卷风式转出来.
         tubey 版面垂直附有弹性的转出来.
         swirl 旧版面360度旋转并淡出, 显示出新版面.
         charminUltra 旧版面淡出并显示新版面.
         zoomyIn 新版面由小放大走到前面, 旧版面放大由前面消失.
         zoomyOut 新版面屏幕外面缩放出现, 旧版面缩小消失.
         oglApplicationSuspend 像按”home” 按钮的效果.

         */
        
    
    
    
    
}
- (void)fragmenttationAnimationWithView:(UIView *)views{
    // 先截图
    UIView *snapView = [views snapshotViewAfterScreenUpdates:YES];
    
    // 隐藏容器中的子控件
    for (UIView *view in views.subviews) {
        view.hidden = YES;
        
    }
    //self.backgroundColor = [[UIColor purpleColor]colorWithAlphaComponent:0];
    // 保存x坐标的数组
    NSMutableArray *xArray = [[NSMutableArray alloc] init];
    // 保存y坐标
    NSMutableArray *yArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < SCREEN_WIDTH; i = i + 10) {
        [xArray addObject:@(i)];
    }
    for (NSInteger i = 0; i < SCREEN_HEIGHT; i = i + 10) {
        [yArray addObject:@(i)];
    }
    
    
    //这个保存所有的碎片
    NSMutableArray *snapshots = [[NSMutableArray alloc] init];
    for (NSNumber *x in xArray) {
        
        for (NSNumber *y in yArray) {
            CGRect snapshotRegion = CGRectMake([x doubleValue], [y doubleValue], 10, 10);
            
            // resizableSnapshotViewFromRect 这个方法就是根据frame 去截图
            UIView *snapshot      = [snapView resizableSnapshotViewFromRect:snapshotRegion afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame        = snapshotRegion;
            [views addSubview:snapshot];
            [snapshots         addObject:snapshot];
        }
    }
    
    
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         //  self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.05];
                         for (UIView *view in snapshots) {
                             view.frame = CGRectOffset(view.frame, [self randomRange:200 offset:-100], [self randomRange:200 offset:views.frame.size.height/2]);
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         for (UIView *view in snapshots) {
                             [view removeFromSuperview];
                         }
                         //                         [self removeFromSuperview];
                         //                         [self removeFromSuperview];
                         
                     }];
    
    
}
- (CGFloat)randomRange:(NSInteger)range offset:(NSInteger)offset{
    
    return (CGFloat)(arc4random()%range + offset);
}
-(void)pushViewControllers{
    LLView * vc = [[LLView alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIScrollView *)verticalScroll{
    if (!_verticalScroll) {
        _verticalScroll = [[UIScrollView alloc]init];
        _verticalScroll.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        _verticalScroll.bounds = CGRectMake(0, 0, 130, 60);
        //_verticalScroll.pagingEnabled = YES;
        _verticalScroll.showsVerticalScrollIndicator = NO;
        _verticalScroll.scrollEnabled = NO;
        _verticalScroll.bounces = NO;
        _verticalScroll.delegate = self;
        
        [self.view addSubview:_verticalScroll];
        CGFloat scaleH = 20;
        CGFloat Height = 20;
        CGFloat H = 0;
        for (int i =0; i<self.titleArrays.count; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10, H+scaleH, CGRectGetWidth(_verticalScroll.frame)-20, Height);
            [button setTitle:self.titleArrays[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.tag = i+10;
            [_verticalScroll addSubview:button];
            
            
            H = button.frame.origin.y+button.frame.size.height+scaleH;
        }
        _verticalScroll.contentSize = CGSizeMake(0, H);

    }
    return _verticalScroll;
}

-(NSArray *)titleArrays{
    if (!_titleArrays) {
        _titleArrays = [NSArray arrayWithObjects:@"今天是一个好天气",@"温度达到了30度以上",@"可是我并没有感觉很热",@"因为什么呢",@"公司开空调了",@"这个是不是可以有啊",@"今天是一个好天气",@"温度达到了30度以上", nil];
    }
    return _titleArrays;
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"endani");
    if (scrollView.contentOffset.y==scrollView.contentSize.height-CGRectGetHeight(self.verticalScroll.frame)){
        [scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(self.verticalScroll.frame))];
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
