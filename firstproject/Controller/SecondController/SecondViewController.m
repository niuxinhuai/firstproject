//
//  SecondViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)

#define KBtn_width        200
#define KBtn_height       80
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          80
#define kCellHeight_Normal  50
#define kCellHeight_Manual  145

#define kVCTitle          @"商户测试"
#define kBtnFirstTitle    @"获取订单，开始测试"
#define kWaiting          @"正在获取TN,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define kMode_Development             @"01"
#define kURL_TN_Normal                @"http://101.231.204.84:8091/sim/getacptn"
#define kURL_TN_Configure             @"http://101.231.204.84:8091/sim/app.jsp?user=123456789"
#import "SecondViewController.h"
#import "HYPageView.h"
#import <GPUImage.h>
#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UIView+Fragmentation.h"
@implementation Product


@end
@interface SecondViewController ()<ChouseAliPayDelegate,NSURLConnectionDataDelegate,NSURLSessionDelegate>
{
    UIAlertView* _alertView;
    NSMutableData* _responseData;
}
@property (nonatomic ,strong)HYPageView * HYview;
@property (nonatomic, strong)UIImageView * barImageView;
@property (nonatomic, strong)NSArray * titleArray;
@property(nonatomic, copy)NSString *tnMode;
- (void)startNetWithURL:(NSURL *)url;
@end

@implementation SecondViewController
@synthesize tnMode;
#pragma mark   ==============产生随机订单号==============
- (instancetype)initWithUrl:(NSString *)url{
    self  = [super init];
    if (self) {
    }
    return self;
}

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
    //adjustsScrollViewInsets_NO(, self);
    // Do any additional setup after loading the view from its nib.

    [self setUpUI];
    [self setUpNavigationView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)setUpUI{
    [self.view addSubview:self.HYview];
    
}
-(void)setUpNavigationView{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithItemTitle:@"支付宝" target:self action:@selector(leftTap)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithItemTitle:@"银联支付" target:self action:@selector(rightTap)];
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



#pragma mark - 右侧点击  银联支付
-(void)rightTap{
    self.tnMode = kMode_Development;
    [self startNetWithURL:[NSURL URLWithString:kURL_TN_Normal]];
    
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
        _HYview = [[HYPageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withTitles:self.titleArray withViewControllers:@[@"ScienceViewController",@"VideoShowViewController",@"NewInformationsViewController",@"PracticesViewController",@"HaveFunViewController",@"CustomViewController",@"PictureBrowserViewController"] withParameters:nil];
        _HYview.defaultSubscript = 0;
        _HYview.selectedColor = [UIColor uiColorFromString:@"#1997eb"];
    }
    
    
    return _HYview;
}

-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"科学",@"直播间",@"高德地图",@"视频播放",@"百度AI",@"蓝牙开发",@"图片浏览", nil];
    }
    
    return _titleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 @parameter 增加银联支付测试功能

 */

- (void)startNetWithURL:(NSURL *)url
{
    [self showAlertWait];
    
    NSURLRequest * urlRequest=[NSURLRequest requestWithURL:url];
    NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConn start];
   // [self sessionDownloadTaskDelegate];
}
- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
                                        totalBytesWritten:(NSInteger)totalBytesWritten
                                          totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    long long current = bytesWritten/1024;
    long long totalB = totalBytesWritten/1024;
    long long totalEnd = totalBytesExpectedToWrite/1024;
    NSLog(@"bytesWritten: %.1lld\n totalBytesWritten: %.1lld\n totalBytesExpectedToWrite: %.1lld",current,totalB,totalEnd);
    
    
}

/**
 *  NSURLSessionDownloadTask 代理
 */
- (void)sessionDownloadTaskDelegate
{
    // 创建带有代理方法的自定义 session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 创建任务
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:kURL_TN_Normal]];
    
    // 启动任务
    [task resume];
}
#pragma mark -
#pragma mark -NSURLSessionDownloadDelegate
/**
 *  写入临时文件时调用
 *  @param bytesWritten              本次写入大小
 *  @param totalBytesWritten         已写入文件大小
 *  @param totalBytesExpectedToWrite 请求的总文件的大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //可以监听下载的进度
    CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"downloadTask %f",progress);
}



#pragma mark - connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    NSInteger code = [rsp statusCode];
    if (code != 200)
    {
        
        [self showAlertMessage:kErrorNet];
        [connection cancel];
    }
    else
    {
        
        _responseData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self hideAlert];
    NSString* tn = [[NSMutableString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    if (tn != nil && tn.length > 0)
    {
        
        NSLog(@"tn=%@",tn);
        [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"XHUPPaySigin" mode:self.tnMode viewController:self];
        
    }
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self showAlertMessage:kErrorNet];
}


#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    NSString* msg = [NSString stringWithFormat:kResult, result];
    [self showAlertMessage:msg];
}

#pragma mark - Alert

- (void)showAlertWait
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alertView show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(_alertView.frame.size.width / 2.0f - 15, _alertView.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [_alertView addSubview:aiv];
    
}

- (void)showAlertMessage:(NSString*)msg
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:self cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [_alertView show];
    
}
- (void)hideAlert
{
    if (_alertView != nil)
    {
        [_alertView dismissWithClickedButtonIndex:0 animated:NO];
        _alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _alertView = nil;
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
