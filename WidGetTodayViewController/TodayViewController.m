//
//  TodayViewController.m
//  WidGetTodayViewController
//
//  Created by 牛新怀 on 2017/7/11.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, strong) UIImageView * customImageView;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    [self.view addSubview:self.customImageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    NSLog(@"maxWidth %f maxHeight %f",maxSize.width,maxSize.height);
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact)
    {
        self.preferredContentSize = CGSizeMake(maxSize.width, 110);
    }
    else
    {
        self.preferredContentSize = CGSizeMake(maxSize.width, 200);
    }
}
-(UIImageView *)customImageView{
    if (!_customImageView) {
        _customImageView = [[UIImageView alloc]init];
        _customImageView .frame = CGRectMake(20, 20, 40, 40);
        _customImageView.image = [UIImage imageNamed:@"m8.jpg"];
        _customImageView.contentMode = UIViewContentModeScaleAspectFill;
        _customImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveToRefreshToAnotherViewController)];
        [_customImageView addGestureRecognizer:gesture];
    }
    
    return _customImageView;
}
-(void)moveToRefreshToAnotherViewController{
    //通过extensionContext借助host app调起app
    [self.extensionContext openURL:[NSURL URLWithString:@"firstproject://type=image"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];
}
@end
