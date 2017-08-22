//
//  SecondViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "SecondViewController.h"
#import "HYPageView.h"
#import <GPUImage.h>
#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
@implementation Product


@end
@interface SecondViewController ()<ChouseAliPayDelegate>
@property (nonatomic ,strong)HYPageView * HYview;
@property (nonatomic, strong)UIImageView * barImageView;
@property (nonatomic, strong)NSArray * titleArray;

@end

@implementation SecondViewController
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
    [self setUpNavigationView];
}
-(void)setUpUI{
    [self.view addSubview:self.HYview];
    
}
-(void)setUpNavigationView{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithItemTitle:@"支付宝" target:self action:@selector(leftTap)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithItemTitle:@"高德地图" target:self action:@selector(rightTap)];
    // 设置导航条为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 去除导航条底部黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    // 设置title颜色
    self.navColorType = NavigationTitleColorTypeBlue;
    _barImageView = self.navigationController.navigationBar.subviews.firstObject;
    
    //self.navigationController.viewControllers
}
#pragma mark - 左侧点击.支付宝支付
-(void)leftTap{
    // 判断用户是否安装了支付宝
    NSURL * url = [NSURL URLWithString:@"alipay:"];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"Warming" message:@"您尚未安装支付宝" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];

            
        }];
        [controller addAction:cancleAction];
        [controller addAction:confirmAction];
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }
    
    
    
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    Product *product = [[Product alloc]init];
    product.subject = @"3";
    product.body = @"用来测试数据";
    product.price =  0.01f+pow(10,3-2);
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088901354472108";
    NSString *seller = @"2088901354472108";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALEmJB6BqjFODe+igaREimw9E7UehSYBB2aC/1gZpnMRMmwvx6fqrN6TmOjLP3PEIDiaIMEp7p5rJFxIiugG+jqPJH15PO6X0Kz983vyBa14XAzeme9VN/fypwOh0EN/9bkYqg3qqwi1cSQ3O4l08kSghjk2ck2bqullIsOV9kpzAgMBAAECgYA/19IemHaAzHOjUHrOe9EzTxPCK5yq5KYJIN7rnlrpj2IPsWyQLLhegu0RwOY+T4mZPJrfYsBXoZ96Dr7Y/mLBjCOsE+1lOnrXHCwfj6UKJV8RMTMVf/nVct0eHePG6QuiQL6sepg0Ji+HorAY3bHaMEMe68OQNKoo+mY0Pf9seQJBAORfp/BYspA0w41Y94RUW8DJpETkbqNexjTEVn5dsel2YcpdCn/mDbcJ94D1Byhy37cxp2ZwGSaGy5c9yPYiNK0CQQDGlCTpPiPcVw7PyWtca4foAgUN++HBQenc0CRt8XtIoEbWdTCqdhaNbG7x9NVIS5YYq6rqkbA4+26DpayB5T+fAkBjmSw+8BAAQGLAtHpOZhQWAlr4CMAP0/eRb8dhGS/MZ+rCPM2ldgmpOFmPDk3u4BqdZLRjQqRVXxhPf4yze7uJAkEAuaWEAH50nijRkxZ2BXgOHavNt+4Ud0086o+4jwRkQlh9AT+cGLC/ksWdzxwaTTVFBJlw90zul8cP4YmAhguhdwJAF7FthRB8Ae3bsKk6BuEtFZCLndi1wdiqjV7ZXlsl1sRbXwpbqjWG5UE9FiUBfq9f+WdjC806yNJIWpGInDDKmw==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.subject = product.subject; //商品标题
    order.body = product.body; //商品描述
    product.price = 0.01f;
    order.totalFee = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  @"http://www.cjkt.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"scheme";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 支付成功？失败回掉
- (void)alipaydidSuccess{
    //成功
}
-(void)ailipaydidFaildWithAliPayFaildIdentifier:(int)identifier{
    // 失败
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;  // Light content, for use on dark backgrounds
}

- (BOOL)prefersStatusBarHidden
{
    return NO; // 是否隐藏状态栏
}



#pragma mark - 右侧点击  高德地图
-(void)rightTap{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat minAlphaOffset = - 64;
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    _barImageView.alpha = alpha;
}
-(HYPageView *)HYview{
    if (!_HYview) {
        _HYview = [[HYPageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withTitles:self.titleArray withViewControllers:@[@"ScienceViewController",@"VideoShowViewController",@"NewInformationsViewController",@"PracticesViewController",@"HaveFunViewController",@"CustomViewController"] withParameters:nil];
        _HYview.defaultSubscript = 0;
        _HYview.selectedColor = [UIColor uiColorFromString:@"#1997eb"];
    }
    
    
    return _HYview;
}

-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"科学",@"直播间",@"高德地图",@"视频播放",@"百度AI",@"蓝牙开发", nil];
    }
    
    return _titleArray;
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
