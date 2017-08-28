//
//  VideoViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/22.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "VideoViewController.h"
#import "LLView.h"
#import "UIView+Fragmentation.h"
#import "UIImage+XFCircle.h"
@interface TabBarView :UIView
@property (nonatomic, strong)UIButton * btn;
@end
@implementation TabBarView

-(void)drawRect:(CGRect)rect{
  
     
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.center = CGPointMake(SCREEN_WIDTH/2, 0);
    _btn.bounds = CGRectMake(0, 0, 50, 50);
    _btn.layer.cornerRadius = 25;
    _btn.clipsToBounds = YES;
    _btn.backgroundColor = [UIColor cyanColor];
    [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
}
-(void)btnClick{
    NSLog(@"点击了视图");
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView * item = [super hitTest:point withEvent:event];
//    if (item ==self) {
//        CGPoint p = [self convertPoint:point toView:_btn];
//        item = [_btn hitTest:p withEvent:event];
//    }
    if (item == nil) {
        //转换坐标
        CGPoint newPoint = [_btn convertPoint:point fromView:self];
        if (CGRectContainsPoint(_btn.bounds, newPoint)) {
            item = _btn;
        }
    }
    
    return item;
}

@end
@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _startOffsetX;
    CGFloat _startOffSetY;
    CGPoint topScrollStartPoint;
    CGPoint topScrollEndPoint;
    CGPoint bottomTabStartPoint;
    CGPoint bottomTabEndPoint;
    
    UICollectionViewFlowLayout * flowLayout;
}
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) TabBarView * tabBarViews;
@property (nonatomic, strong) UICollectionView * myCollect;
@property (nonatomic, strong) UIScrollView * scroll;
@property (nonatomic, strong) UITableView * customTableView;
@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) LLView * mainView;
@property (nonatomic, strong) UIImageView * screenImageV;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"千与千寻";
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(popViewAnimation)];
    [self.view addGestureRecognizer:swipe];
    [self createTopView];
     self.myCollect.backgroundColor = [UIColor uiColorFromString:@"#f0f3f8"];
    [self.view addSubview:self.tabBarViews];
    //[self.view addSubview:self.mainView];
    self.view.backgroundColor = [UIColor whiteColor];
 
  
}
- (void)removeAllChildViewControllers{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}
-(void)popViewAnimation{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(LLView *)mainView{
    if (!_mainView) {
        _mainView = [[LLView alloc]init];
       // _mainView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
       // _mainView.backgroundColor = [UIColor purpleColor];
        _mainView.topTitleArray = self.titleArray;
        _mainView.childViewControlArray = @[@"SpringViewController",@"VideoShowViewController",@"CalcutViewController",@"PictureViewController",@"HotsViewController",@"CircleViewController",@"SpringViewController",@"CalcutViewController"];
        
    }
    
    
    return _mainView;
}
-(void)createTopView{
    _scroll = [[UIScrollView alloc]init];
    _scroll.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    topScrollStartPoint = _scroll.center;
    topScrollEndPoint = CGPointMake(_scroll.center.x, -40);
    _scroll.backgroundColor = [UIColor cyanColor];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.scrollEnabled = YES;
    [self.view addSubview:_scroll];
    CGFloat scaleWidth = 50;
    CGFloat w =0;
    for (int i=0; i<self.titleArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize size = [Tool widthWithText:self.titleArray[i] Font:[UIFont systemFontOfSize:16]];
        btn.frame = CGRectMake(scaleWidth+w, CGRectGetHeight(_scroll.frame)/2-10, size.width, size.height);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = i+10;
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeSelectSenderClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scroll addSubview:btn];
        if (i ==0) {
            UIView * line = [[UIView alloc]init];
            line.center = CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame)+2);
            line.bounds = CGRectMake(0, 0, size.width, 2);
            line.backgroundColor  = [UIColor uiColorFromString:@"#1997eb"];
            [_scroll addSubview:line];
            _lineView = line;
        }
        w = btn.frame.origin.x+btn.frame.size.width;
        _scroll.contentSize = CGSizeMake(w, 0);
    }
    
    
    
}
-(void)changeSelectSenderClick:(UIButton *)sender{
 
  
    UIButton *btn=(UIButton*)sender;
    CGPoint rect=[_scroll convertPoint:btn.center toView:self.view];//在self.view 中的位置
    float movex;//需要偏移的距离
    float screenWithHalf=SCREEN_WIDTH/2;//屏幕宽度一半
    //分两种情况
    //一种滚动到最边缘
    //一种滚动到中间
   
        if (btn.center.x>screenWithHalf &&btn.center.x<_scroll.contentSize.width-screenWithHalf) {
            if (rect.x!=screenWithHalf) {
                movex=rect.x-screenWithHalf;
            }
            _scroll.contentOffset=CGPointMake(_scroll.contentOffset.x+movex, _scroll.contentOffset.y);
        }
        else{
            if (btn.center.x<screenWithHalf) {//滑动到左侧最边缘
                _scroll.contentOffset=CGPointMake(0, _scroll.contentOffset.y);
            }
            else if (btn.center.x>_scroll.contentSize.width-screenWithHalf){//滑动到右侧最边缘
                float  remove=_scroll.contentSize.width-SCREEN_WIDTH;
                _scroll.contentOffset=CGPointMake(remove, _scroll.contentOffset.y);
            }
        }
    [UIView animateWithDuration:0.25 animations:^{
        _lineView.center = CGPointMake(sender.center.x, _lineView.center.y);
        _lineView.bounds = CGRectMake(0, 0, sender.frame.size.width, CGRectGetHeight(_lineView.frame));
        
    }];
    
    

    
    
}
-(TabBarView *)tabBarViews{
    if (!_tabBarViews) {
        _tabBarViews = [[TabBarView alloc]init];
        _tabBarViews.backgroundColor = [UIColor uiColorFromString:@"#f0f3f8"];
        _tabBarViews.frame = CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44);
        bottomTabStartPoint = _tabBarViews.center;
        bottomTabEndPoint = CGPointMake(_tabBarViews.center.x, SCREEN_HEIGHT+50);
    }
    
    return _tabBarViews;
}

-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"关注",@"热门",@"我的视频",@"游戏",@"我的音乐",@"热播",@"头条",@"资讯", nil];
    }
    
    return _titleArray;
}
-(UICollectionView *)myCollect{
    if (!_myCollect) {
         flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(_scroll.frame)-CGRectGetHeight(self.tabBarViews.frame));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        //flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, <#CGFloat height#>)
        _myCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_scroll.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(_scroll.frame)-CGRectGetHeight(self.tabBarViews.frame)) collectionViewLayout:flowLayout];
        _myCollect.delegate = self;
        _myCollect.dataSource = self;
        _myCollect.pagingEnabled = YES;
        _myCollect.backgroundColor = [UIColor redColor];
        _myCollect.contentSize = CGSizeMake(self.titleArray.count*SCREEN_WIDTH, 0);
        _myCollect.showsHorizontalScrollIndicator = NO;
        [_myCollect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
        [self.view addSubview:_myCollect];
    }
    
    return _myCollect;
}
-(UITableView *)customTableView{
    if (!_customTableView) {
        _customTableView = [[UITableView alloc]init];
        _customTableView.delegate = self;
        _customTableView.dataSource = self;
        _customTableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
       // [_customTableView setSeparatorColor:<#(UIColor * _Nullable)#>]设置cell间分割线的颜色。
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -200, SCREEN_WIDTH, 200)];
        self.headerImageView.image = [UIImage imageNamed:@"lionAnimo"];
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;// 按比例填充
        [_customTableView addSubview:self.headerImageView];
        
    }
    
    return _customTableView;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3, 100, 100);
    label.backgroundColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"第%ld个",indexPath.item];
    label.textColor = [UIColor blackColor];
    [cell.contentView addSubview:label];
    
        self.customTableView.frame = cell.bounds;
        [cell.contentView addSubview:self.customTableView];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"12343123";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 个",indexPath.row];
    cell.textLabel.textColor = [UIColor redColor];
    cell.selectedBackgroundView.backgroundColor = [UIColor cyanColor];// 自定义选中时的背景
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [self.view fragmenttationAnimation];
    [self.navigationController popViewControllerAnimated:NO];
   

   //  self.backBlock(nil);
    dispatch_time_t delayTimes = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_after(delayTimes, dispatch_get_main_queue(), ^{
      
        
        
    });
    
    
}
- (UIImageView *)screenImageV{
    if (!_screenImageV) {
        _screenImageV = [[UIImageView alloc]init];
        [[UIApplication sharedApplication].keyWindow addSubview:_screenImageV];
        _screenImageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _screenImageV;
}

//返回截取到的图片
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

//截取当前屏幕
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sourceIndex = 0 ;
    CGFloat targetIndex = 0 ;
    CGFloat process = 0 ;
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;

    //左侧滑动
    if (_startOffsetX < contentOffsetX) {
        
        sourceIndex  =floor((contentOffsetX / self.myCollect.frame.size.width));
        targetIndex =  sourceIndex+1;
        
        process =(contentOffsetX / self.myCollect.frame.size.width) - floor((contentOffsetX / self.myCollect.frame.size.width));
        
        if ((contentOffsetX - _startOffsetX)==self.myCollect.frame.size.width) {
            process=1;
            targetIndex=sourceIndex;
        }
    }
    //右侧滑动
    else
    {
        targetIndex = floor((contentOffsetX / self.myCollect.frame.size.width));
        sourceIndex = targetIndex+1;
        process = 1- ((contentOffsetX / self.myCollect.frame.size.width) - floor((contentOffsetX / self.myCollect.frame.size.width)));
        
    }
    
    if (sourceIndex >self.titleArray.count-1||targetIndex>self.titleArray.count-1||targetIndex<0 ) {
        return;
    }
    UIButton * btn1 = [_scroll viewWithTag:sourceIndex+10];
    UIButton * btn2 = [_scroll viewWithTag:targetIndex+10];
    CGFloat detailX = btn2.frame.origin.x - btn1.frame.origin.x;
    CGFloat deltaWidth = btn2.frame.size.width- btn1.frame.size.width;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = _lineView.frame;
        rect.origin.x = btn1.frame.origin.x + detailX * process;
        rect.size.width = btn1.frame.size.width + deltaWidth * process;
        _lineView.frame = rect;
        
    }];

    if (scrollView.contentOffset.y < 0) {
        // 向下拉多少
        // 表头就向上移多少

//        //int abs(int i); // 处理int类型的取绝对值
//        //double fabs(double i); //处理double类型的取绝对值
//        //float fabsf(float i); //处理float类型的取绝对值
        CGPoint point = scrollView.contentOffset;
            CGRect f =self.headerImageView.frame;
            f.origin.y = point.y;
            f.size.height = -point.y;
            self.headerImageView.frame = f;

    }else{
        // 复原
        self.headerImageView.y = 0;
        self.headerImageView.height = 200;
      
    }
    
    NSLog(@"开始偏移量 %f,  现在偏移量 %f",_startOffSetY,scrollView.contentOffset.y);
    if (_startOffSetY>=scrollView.contentOffset.y) {
        // 向下
        [UIView animateWithDuration:0.25 animations:^{
            self.scroll.center = topScrollStartPoint;
            self.tabBarViews.center = bottomTabStartPoint;
            flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(_scroll.frame)-CGRectGetHeight(self.tabBarViews.frame));
            self.myCollect.frame = CGRectMake(0, CGRectGetHeight(self.scroll.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(self.scroll.frame)-CGRectGetHeight(self.tabBarViews.frame));
            self.customTableView.frame = self.myCollect.bounds;
        }];
    }else if (_startOffSetY<scrollView.contentOffset.y){
        //向shang
        [UIView animateWithDuration:0.25 animations:^{
            self.scroll.center = topScrollEndPoint;
            self.tabBarViews.center = bottomTabEndPoint;
            flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
            self.myCollect.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.customTableView.frame = self.myCollect.bounds;
        }];
        
    }
    

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _startOffsetX = scrollView.contentOffset.x;
    _startOffSetY = scrollView.contentOffset.y;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger targetIndex = floor(self.myCollect.contentOffset.x / self.myCollect.frame.size.width);
    UIButton * btn = [_scroll viewWithTag:targetIndex +10];
    CGFloat offSet = btn.center.x - _scroll.frame.size.width/2;
    if (offSet<0) {
        offSet = 0;
    }
    CGFloat maxOffsetX =_scroll.contentSize.width - _scroll.frame.size.width;
    if (offSet >maxOffsetX) {
        offSet = maxOffsetX;
    }
    [_scroll setContentOffset:CGPointMake(offSet, 0) animated:YES];

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
