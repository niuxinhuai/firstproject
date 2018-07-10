//
//  NBasiViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NBasiViewController.h"
@interface NBasiViewController ()

@end

@implementation NBasiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBar.translucent = NO;
    //self.automaticallyAdjustsScrollViewInsets =NO;
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[Zhuge sharedInstance] startTrack:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[Zhuge sharedInstance] endTrack:NSStringFromClass([self class]) properties:@{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setColorType:(BarButtonItemTitleColorType)colorType{
    UIColor * color;
    switch (colorType) {
        case ButtonItemTitleColorTypeBlue:{
            color = [UIColor uiColorFromString:@"#1997eb"];
            break;
        }
        case ButtonItemTitleColorTypeWhite:{
            color = [UIColor whiteColor];
            break;
        }
            
        default:
            break;
    }
    self.navigationController.navigationBar.barTintColor = color;

    
}
-(void)setNavColorType:(NavigationTitleColorType)navColorType{
    UIColor * color;
    switch (navColorType) {
        case NavigationTitleColorTypeBlue:{
            color = [UIColor uiColorFromString:@"#1997eb"];

            break;
        }
        case NavigationTitleColorTypeWhite:{
            color = [UIColor whiteColor];

            break;
        }
        default:
            break;
    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
    
}
// 修改状态栏颜色为白色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)popToSpecifiedControllerWithVC:(UIViewController *)viewController{
    NSMutableArray * allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController * specifiedViewController in allViewControllers) {
        if ([specifiedViewController isKindOfClass:[viewController class]]) {
            [self.navigationController popToViewController:specifiedViewController animated:YES];
        }
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
