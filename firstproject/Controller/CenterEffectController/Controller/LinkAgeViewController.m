//
//  LinkAgeViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/23.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "LinkAgeViewController.h"
#import "XHTextView.h"
#import "XHPhotoBrowser.h"
@interface LinkAgeViewController ()
{
    NSString *openOrClouse;
    NSString * locationTitle;
    NSString * beginText;
}
@property (strong, nonatomic) XHTextView * myTextView;
@property (strong, nonatomic) UILabel    * locationLabel;
@property (strong, nonatomic) UISwitch   * locationSwitch;
@property (strong, nonatomic) XHPhotoBrowser * photoView;
@end
static CGFloat paddingTop = 10.0;
@implementation LinkAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dissMissVC)];
    self.navigationItem.leftBarButtonItem = item;
    self.title = @"文章";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithItemTitle:@"发布" target:self action:@selector(sendMessage)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.colorType = ButtonItemTitleColorTypeBlue;
    self.navColorType = NavigationTitleColorTypeWhite;
    [self initWithMyCustomView];
}
#pragma mark - 发布
- (void)sendMessage{
    NSLog(@"发布文章");
}
- (void)dissMissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initWithMyCustomView{
    [self.view addSubview:self.myTextView];
    [self.myTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.equalTo(@(200*OffHeight));
        
    }];
    [self.view addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myTextView.mas_bottom).offset(paddingTop*1.5);
        make.left.mas_equalTo(self.myTextView.mas_left);
        make.height.equalTo(@(20*OffHeight));
        make.width.equalTo(@(300*OffWidth));
        
    }];
    NSString * textTitle = [[NSUserDefaults standardUserDefaults] objectForKey:SubTitleKey];
    self.locationLabel.text = textTitle ? textTitle : @"未能获取用户信息，请稍后重试";
    beginText = self.locationLabel.text;

    [self.view addSubview:self.locationSwitch];
    [self.locationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_right).offset(-60);
        make.top.mas_equalTo(self.myTextView.mas_bottom).offset(paddingTop);
        make.width.equalTo(@(30*OffWidth));
        make.height.equalTo(@(15*OffHeight));
    }];
    
    [self.view addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.locationLabel.mas_bottom).offset(paddingTop);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-paddingTop);
        
    }];
}

- (XHTextView *)myTextView{
    if (!_myTextView) {
        _myTextView= [[XHTextView alloc]init];
        _myTextView.backgroundColor = [UIColor cyanColor];
        _myTextView.font = [UIFont systemFontOfSize:15];
        _myTextView.placeholder = @"请输入内容";
        
    }
    
    return _myTextView;
}
- (UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.textColor = [UIColor lightGrayColor];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _locationLabel;
}

-(UISwitch *)locationSwitch{
    if (!_locationSwitch) {
        _locationSwitch = [[UISwitch alloc]init];
     
        [_locationSwitch setOn:YES animated:YES];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userChangeSwithCloseOrOpenSwitch"] ) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userChangeSwithCloseOrOpenSwitch"] isEqualToString:@"open"]) {
                [_locationSwitch setOn:YES animated:YES];
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userChangeSwithCloseOrOpenSwitch"] isEqualToString:@"close"]){
                [_locationSwitch setOn:NO animated:YES];
            }
            
        }
        _locationSwitch.onTintColor = [UIColor uiColorFromString:@"#1997eb"];
        [_locationSwitch addTarget:self action:@selector(switchIsChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    
    return _locationSwitch;
}
-(void)switchIsChange:(UISwitch *)switchs{
    
    if ([switchs isOn]) {
        NSLog(@"打开状态");
        openOrClouse = @"open";
        locationTitle = beginText;

    }else{
        NSLog(@"关闭");
        openOrClouse = @"close";
        locationTitle = @"您已关闭定位信息";
    }
    [[NSUserDefaults standardUserDefaults] setObject:openOrClouse forKey:@"userChangeSwithCloseOrOpenSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.locationLabel.text = locationTitle;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.myTextView resignFirstResponder];
}
- (XHPhotoBrowser *)photoView{
    if (!_photoView) {
        _photoView = [[XHPhotoBrowser alloc]init];
        
    }
    return _photoView;
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
