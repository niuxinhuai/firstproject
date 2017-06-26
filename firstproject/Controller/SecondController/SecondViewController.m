//
//  SecondViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "SecondViewController.h"
#import "HYPageView.h"
#import <GPUImage.h>
@interface SecondViewController ()
@property (nonatomic ,strong)HYPageView * HYview;
@property (nonatomic, strong)UIImageView * barImageView;
@property (nonatomic, strong)NSArray * titleArray;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
    [self setUpNavigationView];
}
-(void)setUpUI{
    [self.view addSubview:self.HYview];
    
}
-(void)setUpNavigationView{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithItemTitle:@"左边" target:self action:@selector(leftTap)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithItemTitle:@"右侧" target:self action:@selector(rightTap)];
    // 设置导航条为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 去除导航条底部黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    // 设置title颜色
    self.navColorType = NavigationTitleColorTypeBlue;
    _barImageView = self.navigationController.navigationBar.subviews.firstObject;
    
    //self.navigationController.viewControllers
}
#pragma mark - 左侧点击
-(void)leftTap{
    
}
#pragma mark - 右侧点击
-(void)rightTap{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat minAlphaOffset = - 64;
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    _barImageView.alpha = alpha;
}
-(HYPageView *)HYview{
    if (!_HYview) {
        _HYview = [[HYPageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withTitles:self.titleArray withViewControllers:@[@"ScienceViewController",@"VideoShowViewController",@"NewInformationsViewController",@"PracticesViewController",@"HaveFunViewController",@"CustomViewController"] withParameters:nil];
        _HYview.defaultSubscript = 0;
        _HYview.selectedColor = [UIColor uiColorFromString:@"#1997eb"];
    }
    
    
    return _HYview;
}

-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"科学",@"直播间",@"新闻资讯",@"自练习",@"快乐的事",@"自定义", nil];
    }
    
    return _titleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
