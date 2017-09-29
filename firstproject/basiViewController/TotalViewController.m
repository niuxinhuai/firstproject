//
//  TotalViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#define APP_ENVIRON 2

#if (APP_ENVIRON == 0)

//开发环境
#define HOST_USER @"http://192.168.18.200:10100/"
#define HOST_BASE @"http://192.168.18.200:10200/"
#define HOST_BEFEXAM @"http://192.168.18.200:10300/"
#define HOST_AFTEXAM @"http://192.168.18.200:10400/"
#define HOST_PAY @"http://192.168.18.200:10500/"
#define HOST_NEWS @"http://192.168.18.200:10600/"
#define HOST_FILE @"http://192.168.18.200:10700/"
#define HOST_NITOCE @"http://192.168.18.200:10800/"
#define HOST_MONITOR @"http://192.168.18.200:10900/"
#define HOST_SYS @"http://192.168.18.200:11000/"
#define HOST_Hulaquan @"http://192.168.18.200:12000/"
//#define HOST_Hulaquan @"http://192.168.18.134/"
#define HOST_CHUXING @"http://192.168.18.200:14000/"
#define HOST_TPL @"http://192.168.18.200:80/"
#define HOST_ADVERT @"http://192.168.18.200:15000/"//广告
#define HOST_TPL_HLQ @"http://tpl.51bm.net.cn/hlq/#/"


#elif (APP_ENVIRON == 1)
//测试
#define HOST_USER @"http://192.168.18.202:10100/"
#define HOST_BASE @"http://192.168.18.202:10200/"
#define HOST_BEFEXAM @"http://192.168.18.202:10300/"
#define HOST_AFTEXAM @"http://192.168.18.202:10400/"
#define HOST_PAY @"http://192.168.18.202:10500/"
#define HOST_NEWS @"http://192.168.18.202:10600/"
#define HOST_FILE @"http://192.168.18.202:10700/"
#define HOST_NITOCE @"http://192.168.18.202:10800/"
#define HOST_MONITOR @"http://192.168.18.202:10900/"
#define HOST_SYS @"http://192.168.18.202:11000/"
#define HOST_Hulaquan @"http://192.168.18.202:12000/"
#define HOST_CHUXING @"http://192.168.18.202:14000/"
#define HOST_TPL @"http://192.168.18.202:80/"
#define HOST_ADVERT @"http://192.168.18.202:15000/"//广告
#define HOST_TPL_HLQ @"http://tpl.51bm.net.cn/hlq/#/"

#elif (APP_ENVIRON == 2)
//演示
#define HOST_USER @"http://user.51bm.net.cn/"
#define HOST_BASE @"http://base.51bm.net.cn/"
#define HOST_BEFEXAM @"http://befexam.51bm.net.cn/"
#define HOST_AFTEXAM @"http://aftexam.51bm.net.cn/"
#define HOST_PAY @"http://pay.51bm.net.cn/"
#define HOST_NEWS @"http://news.51bm.net.cn/"
#define HOST_FILE @"http://filecenter.51bm.net.cn/"
#define HOST_NITOCE @"http://notice.51bm.net.cn/"
#define HOST_MONITOR @"http://monitor.51bm.net.cn/"
#define HOST_SYS @"http://sys.51bm.net.cn/"
#define HOST_Hulaquan @"http://hulaquan.51bm.net.cn/"
#define HOST_CHUXING @"http://chuxing.51bm.net.cn/"
#define HOST_TPL @"http://tpl.51bm.net.cn/"
#define HOST_ADVERT @"http://advert.51bm.net.cn/"//广告
#define HOST_TPL_HLQ @"http://tpl.51bm.net.cn/hlq/#/"

#else
//生产
#define HOST_USER @"https://user.artstudent.cn/"
#define HOST_BASE @"https://base.artstudent.cn/"
#define HOST_BEFEXAM @"https://befexam.artstudent.cn/"
#define HOST_AFTEXAM @"https://aftexam.artstudent.cn/"
#define HOST_PAY @"https://pay.artstudent.cn/"
#define HOST_NEWS @"https://news.artstudent.cn/"
#define HOST_FILE @"https://filecenter.artstudent.cn/"
#define HOST_NITOCE @"https://notice.artstudent.cn/"
#define HOST_MONITOR @"https://monitor.artstudent.cn/"
#define HOST_SYS @"https://sys.artstudent.cn/"
#define HOST_Hulaquan @"https://hulaquan.artstudent.cn/"
#define HOST_CHUXING @"https://chuxing.artstudent.cn/"
#define HOST_TPL @"https://tpl.artstudent.cn/"
#define HOST_ADVERT @"https://advert.artstudent.cn/"//广告
#define HOST_TPL_HLQ @"https://tpl.artstudent.cn/hlq/#/"
#endif




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
#import "UIViewController+custom.h"
#import "NXUserCenterViewController.h"
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
        _viewControllerArray = [NSMutableArray arrayWithObjects:@"ViewController",@"SecondViewController",@"MainViewController",@"NXUserCenterViewController", nil];
        
    }
    return _viewControllerArray;
}
- (UINavigationController *)className:(NSString *)className
                              vcTitle:(NSString *)vcTitle
                             tabTitle:(NSString *)tabTitle
                             tabImage:(UIImage *)image
                     tabSelectedImage:(UIImage *)selectedImage
{
    UIViewController *vc = [[NSClassFromString(className) alloc] initWithUrl:HOST_TPL];
 
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
