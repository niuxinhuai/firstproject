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
@interface TotalViewController ()
@property (nonatomic, strong) NSMutableArray<UIImage*>* nomalImageArray;
@property (nonatomic, strong) NSMutableArray<UIImage*>* selectImageArray;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) NSMutableArray * viewControllerArray;
@end

@implementation TotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

-(void)setUpUI{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int i=0; i<4; i++) {
        UIViewController * vc = [self createNzvWithTag:i];
        UINavigationController * nav = [[RootNavViewController alloc]initWithRootViewController:vc];
        [array addObject:nav];
    }
    self.viewControllers = array;
    self.tabBar.tintColor = [UIColor uiColorFromString:@"#00aaf5"];
//    AppDelegate * app = [[AppDelegate alloc]init];
//    app.window.rootViewController = self;

    
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
-(UIViewController*)createNzvWithTag:(NSInteger)tag{
    id class = self.viewControllerArray[tag];

    UIImage * nomalImage = self.nomalImageArray[tag];
    UIImage * selectImage = self.selectImageArray[tag];
    NSString * text = self.titleArray[tag];
     NBasiViewController* childVC;
    if ([class isEqualToString:@"ViewController"] ) {
        ViewController * vc = [[ViewController alloc]init];
        
        childVC = vc;
    }else if ([class isEqualToString:@"SecondViewController"]){
        SecondViewController * vc = [[SecondViewController alloc]init];
        childVC = vc;
    }else if ([class isEqualToString:@"MainViewController"]){
        MainViewController * vc = [[MainViewController alloc]init];
        childVC = vc;
        
    }else if ([class isEqualToString:@"OwnerViewController"]){
        OwnerViewController * vc = [[OwnerViewController alloc]init];
        childVC = vc;
    }
   // UINavigationController * nav = [[RootNavViewController alloc]initWithRootViewController:childVC];

   childVC.title = text;
    childVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:text image:nomalImage selectedImage:selectImage];
    
    
    
    
    return childVC;
    
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
