//
//  LLView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/6/7.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "LLView.h"
#import "VideoRootViewController.h"
@interface LLView()<UIScrollViewDelegate>
{
    CGFloat _startOffsetX;
    NSInteger newIndex;
    NSInteger oldIndex;

}
@property (nonatomic, strong) UIScrollView * topTitleScrollView;
@property (nonatomic, strong) UIScrollView * bottomScrollView;
@property (weak, nonatomic) UIViewController *viewController;
@property (nonatomic, strong) UIViewController *currentVC;


@end
static const CGFloat TopScrollHeight = 50.0;
static const CGFloat buttonScale     = 20.0;
static const CGFloat buttonY         = 15.0;
static const CGFloat buttonFont      = 16.0;
static const NSInteger TAG           = 100;
@implementation LLView

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"千与千寻";

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.topTitleScrollView.backgroundColor =[UIColor redColor];
    //self.topScrollBackGroundColorType = ScrollBackColorAlphaWhiteColor;
    self.titleFont = [UIFont systemFontOfSize:buttonFont];
    self.normalColor = [UIColor blackColor];
    self.selectColor = [UIColor cyanColor];
    _childViewControlArray = @[@"SpringViewController",@"VideoShowViewController",@"CalcutViewController",@"PictureViewController",@"HotsViewController",@"CircleViewController",@"SpringViewController",@"CalcutViewController"];
    _topTitleArray =  [NSArray arrayWithObjects:@"关注",@"热门",@"我的视频",@"游戏",@"我的音乐",@"热播",@"头条",@"资讯", nil];
    [self createTopScrollButton];
    [self.view addSubview:self.bottomScrollView];
    [self setUpChildVC];
//    UIToolbar * tool = [[UIToolbar alloc]initWithFrame:self.view.bounds];
//    tool.barStyle = UIBarStyleBlackTranslucent;
//    [self.view addSubview:tool];

}

//-(void)setTopTitleArray:(NSArray *)topTitleArray{
//    _topTitleArray = topTitleArray;
//    if (_topTitleArray.count !=0) {
//    }
//}
//-(void)setChildViewControlArray:(NSArray *)childViewControlArray{
//    _childViewControlArray = childViewControlArray;
//    if (_childViewControlArray.count !=0) {
//     
//
//    }
//}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

-(UIScrollView *)topTitleScrollView{
    if (!_topTitleScrollView) {
        _topTitleScrollView = [[UIScrollView alloc]init];
        _topTitleScrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, TopScrollHeight);
        _topTitleScrollView.showsHorizontalScrollIndicator = NO;
        _topTitleScrollView.scrollEnabled = YES;
        [self.view addSubview:_topTitleScrollView];
        
        
        
        
    }
    
    return _topTitleScrollView;
}
-(void)setTopScrollBackGroundColorType:(ScrollBackColor)topScrollBackGroundColorType{
    UIColor * color;
    switch (topScrollBackGroundColorType) {
        case ScrollBackColorWhite:
        {
            color = [UIColor whiteColor];
            break;
        }
        case ScrollBackColorAlphaWhiteColor:
        {
            color = [UIColor uiColorFromString:@"#00aaf5"];
            break;
        }
            
        default:
            break;
    }
    self.topTitleScrollView.backgroundColor = color;
}
-(void)createTopScrollButton{
    CGFloat totalW = 0;
    for (int idx =0; idx<_topTitleArray.count; idx++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonWidth = [self titleWidthWithTitle:_topTitleArray[idx] withFont:[UIFont systemFontOfSize:buttonFont]];
        
        button.frame = CGRectMake(buttonScale+totalW, buttonY, buttonWidth, buttonScale);
        button.titleLabel.font = [UIFont systemFontOfSize:buttonFont];
        [button setTitle:_topTitleArray[idx] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = idx + TAG;
        if (idx ==0) {
            
            [button setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
            button.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.lineView.center = CGPointMake(button.center.x, CGRectGetHeight(self.topTitleScrollView.frame)-2);
            self.lineView.bounds = CGRectMake(0, 0, buttonWidth, 2);
        }
        [button addTarget:self action:@selector(changeSelectSenderClick:) forControlEvents:UIControlEventTouchUpInside];
        totalW = button.frame.origin.x + button.frame.size.width;
        [self.topTitleScrollView addSubview:button];
        
    }
    self.topTitleScrollView.contentSize = CGSizeMake(totalW+buttonScale, 0);
    
    
    
    
    
    
    
}
-(void)changeSelectSenderClick:(UIButton *)sender{// 选中按钮方法
    if (sender.tag == oldIndex) {
        return;
    }
    for (id empty in self.topTitleScrollView.subviews) {
        if ([empty isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)empty;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.transform = CGAffineTransformIdentity;
        }
    }
    UIButton *btn=(UIButton*)sender;
    CGPoint rect=[self.topTitleScrollView convertPoint:btn.center toView:self.view];//在self.view 中的位置
    float movex;//需要偏移的距离
    float screenWithHalf=SCREEN_WIDTH/2;//屏幕宽度一半
    [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    
   // btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [self buttonDoAnimationWithButton:btn];
    if (self.topTitleScrollView.contentSize.width<=SCREEN_WIDTH) {
        return;
    }
    if (btn.center.x>screenWithHalf &&btn.center.x<self.topTitleScrollView.contentSize.width-screenWithHalf) {
        if (rect.x!=screenWithHalf) {
            movex=rect.x-screenWithHalf;
        }
        self.topTitleScrollView.contentOffset=CGPointMake(self.topTitleScrollView.contentOffset.x+movex, self.topTitleScrollView.contentOffset.y);
    }
    else{
        if (btn.center.x<screenWithHalf) {//滑动到左侧最边缘
            self.topTitleScrollView.contentOffset=CGPointMake(0, self.topTitleScrollView.contentOffset.y);
        }
        else if (btn.center.x>self.topTitleScrollView.contentSize.width-screenWithHalf){//滑动到右侧最边缘
            float  remove=self.topTitleScrollView.contentSize.width-SCREEN_WIDTH;
            self.topTitleScrollView.contentOffset=CGPointMake(remove, self.topTitleScrollView.contentOffset.y);
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.center = CGPointMake(sender.center.x, self.lineView.center.y);
        self.lineView.bounds = CGRectMake(0, 0, sender.frame.size.width, CGRectGetHeight(self.lineView.frame));
        
    }];
    [self.bottomScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(btn.tag-TAG), 0) animated:YES];
          //  UIViewController * vc = [self getChildVCWithClassName:_childViewControlArray[sender.tag-TAG]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSelectButtonLive" object:[NSNumber numberWithInteger:sender.tag]];
    oldIndex = btn.tag;
}
-(void)buttonDoAnimationWithButton:(UIButton *)btn{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.3;
    animation.repeatCount = 1;
    animation.values = @[@1.2,@1,@0.9,@1.2];
    animation.calculationMode = kCAAnimationCubic;
    [btn.layer addAnimation:animation forKey:@""];
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor uiColorFromString:@"#1997eb"];
        _lineView.layer.cornerRadius = 1;
        _lineView.clipsToBounds = YES;
        [self.topTitleScrollView addSubview:_lineView];
    }
    return _lineView;
}
-(UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc]init];
        _bottomScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topTitleScrollView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetHeight(self.topTitleScrollView.frame));
        _bottomScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*_childViewControlArray.count, 0);
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.delegate =self;
    }
    
    return _bottomScrollView;
}

-(void)setUpChildVC{
    for (int idx =0; idx<_childViewControlArray.count; idx++) {
        UIViewController * vc = [self getChildVCWithClassName:_childViewControlArray[idx]];
        vc.view.frame = CGRectMake(CGRectGetWidth(self.bottomScrollView.frame)*idx, 0, CGRectGetWidth(self.bottomScrollView.frame), CGRectGetHeight(self.bottomScrollView.frame));
       // UIViewController * mainVC = [self findViewController:self];
       
       
         [self addChildViewController:vc];
     
            [self.bottomScrollView addSubview:vc.view];
        
        
        
    }
    
    
    
}
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target = sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}
-(UIViewController *)getChildVCWithClassName:(NSString *)className{
    Class class = NSClassFromString(className);
    
    UIViewController *viewController = [[class alloc]init];
    return viewController;
}

//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController NewViewController:(UIViewController *)newViewController{
    [_viewController transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:_viewController];
            _currentVC = newViewController;
        }else{
            _currentVC = oldViewController;
        }
    }];
    [self.bottomScrollView addSubview:_currentVC.view];
}
- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    CGRect frame = self.bottomScrollView.frame;
    frame.origin.y = 0;
    chileViewController.view.frame = frame;
}
//移除所有子视图控制器
//- (void)removeAllChildViewControllers{
//    for (UIViewController *vc in self.childViewControllers) {
//        [vc willMoveToParentViewController:nil];
//        [vc removeFromParentViewController];
//    }
//}

/**
 *  方法说明：
 *  1、addChildViewController:向父VC中添加子VC，添加之后自动调用willMoveToParentViewController:父VC
 *  2、removeFromParentViewController:将子VC从父VC中移除，移除之后自动调用
 didMoveToParentViewController:nil
 *  3、willMoveToParentViewController:  当向父VC添加子VC之后，该方法会自动调用。若要从父VC移除子VC，需要在移除之前调用该方法，传入参数nil。
 *  4、didMoveToParentViewController:  当向父VC添加子VC之后，该方法不会被自动调用，需要显示调用告诉编译器已经完成添加（事实上不调用该方法也不会有问题，不太明白）; 从父VC移除子VC之后，该方法会自动调用，传入的参数为nil,所以不需要显示调用。
 */

/**
 *  注意点：
 要想切换子视图控制器a/b,a/b必须均已添加到父视图控制器中，不然会报错
 */

-(CGFloat)titleWidthWithTitle:(NSString *)title withFont:(UIFont *)font{
    CGFloat w = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
    
    return w;
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sourceIndex = 0 ;
    CGFloat targetIndex = 0 ;
    CGFloat process = 0 ;
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    //左侧滑动
    if (_startOffsetX < contentOffsetX) {
        
        sourceIndex  =floor((contentOffsetX / self.bottomScrollView.frame.size.width));
        targetIndex =  sourceIndex+1;
        
        process =(contentOffsetX / self.bottomScrollView.frame.size.width) - floor((contentOffsetX / self.bottomScrollView.frame.size.width));
        
        if ((contentOffsetX - _startOffsetX)==self.bottomScrollView.frame.size.width) {
            process=1;
            targetIndex=sourceIndex;
        }
    }
    //右侧滑动
    else
    {
        targetIndex = floor((contentOffsetX / self.bottomScrollView.frame.size.width));
        sourceIndex = targetIndex+1;
        process = 1- ((contentOffsetX / self.bottomScrollView.frame.size.width) - floor((contentOffsetX / self.bottomScrollView.frame.size.width)));
        
    }
    
    if (sourceIndex >self.topTitleArray.count-1||targetIndex>self.topTitleArray.count-1||targetIndex<0 ) {
        return;
    }
    UIButton * btn1 = [self.topTitleScrollView viewWithTag:sourceIndex+TAG];
    UIButton * btn2 = [self.topTitleScrollView viewWithTag:targetIndex+TAG];
    CGFloat detailX = btn2.frame.origin.x - btn1.frame.origin.x;
    CGFloat deltaWidth = btn2.frame.size.width- btn1.frame.size.width;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = _lineView.frame;
        rect.origin.x = btn1.frame.origin.x + detailX * process;
        rect.size.width = btn1.frame.size.width + deltaWidth * process;
        _lineView.frame = rect;
        
    }];

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    
    if (scrollView == self.bottomScrollView) {
        
    
    for (id empty in self.topTitleScrollView.subviews) {
        if ([empty isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)empty;
            [button setTitleColor:_normalColor forState:UIControlStateNormal];
            button.transform = CGAffineTransformIdentity;
        }
    }
    NSInteger targetIndex = floor(self.bottomScrollView.contentOffset.x / self.bottomScrollView.frame.size.width);
       
    UIButton * btn = [self.topTitleScrollView viewWithTag:targetIndex +TAG];
    [btn setTitleColor:_selectColor forState:UIControlStateNormal];
    
        if (targetIndex == newIndex) {
            return;
        }
    [self buttonDoAnimationWithButton:btn];
    CGFloat offSet = btn.center.x - self.topTitleScrollView.frame.size.width/2;
    if (offSet<0) {
        offSet = 0;
    }
    CGFloat maxOffsetX =self.topTitleScrollView.contentSize.width - self.topTitleScrollView.frame.size.width;
    if (offSet >maxOffsetX) {
        offSet = maxOffsetX;
    }
    [self.topTitleScrollView setContentOffset:CGPointMake(offSet, 0) animated:NO];
    _lineView.center = CGPointMake(btn.center.x, _lineView.center.y);
    }
    newIndex = floor(self.bottomScrollView.contentOffset.x / self.bottomScrollView.frame.size.width);

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _startOffsetX = scrollView.contentOffset.x;
}
@end
