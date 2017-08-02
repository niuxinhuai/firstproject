//
//  NewInformationsViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NewInformationsViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>

@interface NewInformationsViewController ()<AMapNaviDriveManagerDelegate,AMapNaviDriveViewDelegate>
@property (nonatomic, strong) AMapNaviDriveManager * driveManager;
@property (nonatomic, strong) AMapNaviDriveView    * driveView;
@end

@implementation NewInformationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDriveManager];
    [self initDriveView];
    [self configDriveNavi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
}

- (void)initDriveView
{
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        [self.driveView setDelegate:self];
        //将导航界面的界面元素进行隐藏，然后通过自定义的控件展示导航信息
        [self.driveView setShowUIElements:NO];
    }
}
- (void)configDriveNavi
{
    [self.driveManager addDataRepresentative:self.driveView];
    [self.view addSubview:self.driveView];
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
