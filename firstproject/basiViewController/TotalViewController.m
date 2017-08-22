//
//  TotalViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "TotalViewController.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "MainViewController.h"
#import "OwnerViewController.h"
#import "Tool.h"
#import "RootNavViewController.h"
#import "NBasiViewController.h"
#import "RootNavViewController.h"
#import "AppDelegate.h"
#import "UITabBar+baseTabBar.h"
#import "XHTabBar.h"
#import "XHVisualEffectView.h"
#import "EffectViewController.h"
@interface TotalViewController ()<XHTabBarDelegate>
@property (nonatomic, strong) NSMutableArray<UIImage*>* nomalImageArray;
@property (nonatomic, strong) NSMutableArray<UIImage*>* selectImageArray;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) NSMutableArray * viewControllerArray;
@property (nonatomic, strong) EffectViewController * effectView ;
@end

@implementation TotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self.tabBar showBadgeOnItmIndex:4];
  
}

-(void)setUpUI{
    
    XHTabBar * tabbar = [[XHTabBar alloc]init];
    tabbar.myDelegate = self;
    
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int i=0; i<4; i++) {
        UINavigationController * nav = [self className:self.viewControllerArray[i] vcTitle:self.titleArray[i] tabTitle:self.titleArray[i] tabImage:self.nomalImageArray[i] tabSelectedImage:self.selectImageArray[i]];
            [array addObject:nav];
        
      
    }
    self.viewControllers = array;
    self.tabBar.tintColor = [UIColor uiColorFromString:@"#00aaf5"];
    

    


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray<UIImage*>*)nomalImageArray{//默认图片
    if (!_nomalImageArray) {
        _nomalImageArray = [NSMutableArray arrayWithCapacity:4];
         [_nomalImageArray addObject:[Tool imageViewWithName:@"indexImage"]];
         [_nomalImageArray addObject:[Tool imageViewWithName:@"secondImage"]];
         [_nomalImageArray addObject:[Tool imageViewWithName:@"mainImage"]];
         [_nomalImageArray addObject:[Tool imageViewWithName:@"ownerImage"]];

        
    }
    
    return _nomalImageArray;
}
-(NSMutableArray<UIImage*>*)selectImageArray{// 选中状态下的图片
    if (!_selectImageArray) {
        _selectImageArray = [NSMutableArray arrayWithCapacity:4];
        [_selectImageArray addObject:[Tool imageViewWithName:@"indexSelectImage"]];
        [_selectImageArray addObject:[Tool imageViewWithName:@"secondSelectImage"]];
        [_selectImageArray addObject:[Tool imageViewWithName:@"mainSelectImage"]];
        [_selectImageArray addObject:[Tool imageViewWithName:@"ownerSelectImage"]];
        
    }
    return _selectImageArray;
    
}
-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"爱疯",@"有直",@"全部",@"个人中心", nil];
    }
    return _titleArray;
}
-(NSMutableArray *)viewControllerArray{
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray arrayWithObjects:@"ViewController",@"SecondViewController",@"MainViewController",@"OwnerViewController", nil];
        
    }
    return _viewControllerArray;
}
- (UINavigationController *)className:(NSString *)className
                              vcTitle:(NSString *)vcTitle
                             tabTitle:(NSString *)tabTitle
                             tabImage:(UIImage *)image
                     tabSelectedImage:(UIImage *)selectedImage
{
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    vc.title = vcTitle;
    vc.tabBarItem.title = tabTitle;
    vc.tabBarItem.image =image;
    vc.tabBarItem.selectedImage = selectedImage;
    
    UINavigationController *navgation = [[RootNavViewController alloc] initWithRootViewController:vc];
    return navgation;
}
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(XHTabBar *)tabBar withButton:(UIButton *)btn
{

    btn.selected = !btn.selected;

    _effectView = [[EffectViewController alloc]init];
    //判断系统版本
    if ([UIDevice currentDevice].systemVersion.floatValue>=8) {
        
        _effectView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }else{
        _effectView.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_effectView animated:NO completion:nil];
    
    _effectView.dismissBlock = ^{
         [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    };
    
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
