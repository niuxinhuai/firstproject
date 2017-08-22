//
//  EffectViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/22.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "EffectViewController.h"

@interface EffectViewController ()
@property (strong, nonatomic)UIButton * popButton;
@end

@implementation EffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self blurEffectView];
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
//毛玻璃效果
-(void)blurEffectView
{
    //1,效果对象
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //2,创建一个用于显示效果的view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    effectView.frame = self.view.frame;
    [self.view addSubview:effectView];
    [self.view addSubview:self.popButton];
}


- (UIButton *)popButton{
    if (!_popButton) {
        _popButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _popButton.backgroundColor = [UIColor redColor];
        _popButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-20);
        _popButton.bounds = CGRectMake(0, 0, 40, 40);
        [_popButton addTarget:self action:@selector(changPopViewClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popButton;
}
- (void)changPopViewClick{

    self.dismissBlock();
}
@end
