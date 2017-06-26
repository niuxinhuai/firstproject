//
//  RootNavViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "RootNavViewController.h"
#import "UIColor+HexColor.h"
@interface RootNavViewController ()

@end

@implementation RootNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.navigationBar.backgroundColor = [UIColor redColor];
    [self.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"获取" style:UIBarButtonItemStylePlain target:self action:@selector(getDataWithBarButton)];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)getDataWithBarButton{
    NSLog(@"123");
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
