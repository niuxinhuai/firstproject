//
//  CircleViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/6/7.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "CircleViewController.h"

@interface CircleViewController ()

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    // Do any additional setup after loading the view.
    UILabel * label = [[UILabel alloc]init];
    label.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    label.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    label.font = [UIFont systemFontOfSize:20];
    label.textColor  =[UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSStringFromClass([self class]);
    [self.view addSubview:label];
    
   
    
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
