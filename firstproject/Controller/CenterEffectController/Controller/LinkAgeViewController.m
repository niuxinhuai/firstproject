//
//  LinkAgeViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/23.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "LinkAgeViewController.h"

@interface LinkAgeViewController ()

@end

@implementation LinkAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dissMissVC)];
    self.navigationItem.leftBarButtonItem = item;
    self.title = @"二级联动";
}
- (void)dissMissVC{
    
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
