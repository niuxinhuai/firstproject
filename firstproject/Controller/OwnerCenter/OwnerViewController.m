//
//  OwnerViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
#import "OwnerViewController.h"
#import "EmojiLayout.h"
#import "EmojiCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "EmojiModel.h"
#import "UIView+ZYDraggable.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "UIViewController+custom.h"
@import WebKit;
@interface OwnerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,WKNavigationDelegate>
{
    UIPageControl * control;
    NSString * urls;
}
@property (nonatomic, strong)UICollectionView * emojiCollection;
@property (nonatomic, strong)NSMutableArray * emojiMArr;
@property (nonatomic, strong)WKWebView * sourceWebView;

@end
static NSString * const  cellID = @"CellIdentifiers";

@implementation OwnerViewController
- (instancetype)initWithUrl:(NSString *)url{
    self  = [super init];
    if (self) {
        dispatch_queue_t q_concurrent = dispatch_queue_create("my_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(q_concurrent, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                urls = url;
                NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urls]];
                [self.sourceWebView loadRequest:request];
                
            });
            
        });



    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",urls);
  
    // Do any additional setup after loading the view from its nib.
//    _emojiMArr = [NSMutableArray arrayWithArray:[EmojiModel getImageArray]];
//    [self.view addSubview:self.emojiCollection];
//    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithItemTitle:@"微信支付" target:self action:@selector(weixinpay)];
//    control = [[UIPageControl alloc]init];
//
//    control.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-65);
//    control.bounds = CGRectMake(0, 0, 5, 5);
//    control.numberOfPages = 6;
//    control.currentPageIndicatorTintColor = [UIColor cyanColor];
//    control.pageIndicatorTintColor = [UIColor redColor];
//    [self.view addSubview:control];
//    UIImageView * animationImageView = [[UIImageView alloc]init];
//    animationImageView.center = CGPointMake(SCREEN_WIDTH/2, 100);
//    animationImageView.bounds = CGRectMake(0, 0, 40, 40);
//    animationImageView.layer.cornerRadius = 20;
//    animationImageView.clipsToBounds = YES;
//    animationImageView.userInteractionEnabled = YES;
//    animationImageView.contentMode = UIViewContentModeScaleAspectFill;
//    animationImageView.image = [UIImage imageNamed:@"lionAnimo"];
//    [self.view addSubview:animationImageView];
//    [animationImageView makeDraggable];

}
- (void)weixinpay{
    // 微信支付
    [self WXPay];
    
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
#pragma mark 微信支付方法
- (void)WXPay{
    
    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = @"wx519424286509f4aa";
    
    // 商家id，在注册的时候给的
    req.partnerId = @"1322256901";
    
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = @"Ymt8986594Cjkt8986594Ymt89865940";
    
    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package   = @"Sign=WXPay";
    
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = @"d1e6ecd5993ad2d06a9f50da607c971c1";
    
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    NSString * stamp = [self generateTradeNO];
    req.timeStamp = stamp.intValue;
    
    // 这个签名也是后台做的
    req.sign = @"Ymt8986594Cjkt8986594Ymt89865940";
    
    //发送请求到微信，等待微信返回onResp
    [WXApi sendReq:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UICollectionView *)emojiCollection{
    if (!_emojiCollection) {
        EmojiLayout * layout = [[EmojiLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
 CGFloat itemW = (SCREEN_WIDTH-20*8)/7;
        _emojiCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-(100+itemW*4)+20, SCREEN_WIDTH, 100+itemW*4) collectionViewLayout:layout];
        _emojiCollection.pagingEnabled = YES;
        _emojiCollection.contentSize = CGSizeMake(6*SCREEN_WIDTH, 0);
        _emojiCollection.showsHorizontalScrollIndicator = NO;
        _emojiCollection.backgroundColor = [UIColor whiteColor];
        _emojiCollection.delegate = self;
        _emojiCollection.dataSource = self;

        [_emojiCollection registerClass:[EmojiCollectionViewCell class] forCellWithReuseIdentifier:cellID];
      
        
   
    }
    
    return _emojiCollection;
}
//每个item的大小(可以根据indexPath定制)
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(30, 30);
//}
//
////每组距离边界的大小，逆时针，上，左，下，右
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(20, 20, 20, 20);
//}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 230;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EmojiCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    // cell.imageV [EmojiModel getImageArray][indexPath.item];
    NSString * imageName = [NSString stringWithFormat:@"face%003ld",(long)indexPath.item];
    if (indexPath.item >142) {
        return cell;
    }
    cell.imageName = imageName;

  
       return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.item);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentX = scrollView.contentOffset.x;
    if (contentX>SCREEN_WIDTH*5) {
        self.emojiCollection.scrollEnabled = NO;
        
    }else{
        self.emojiCollection.scrollEnabled = YES;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger contentX =(NSInteger) (scrollView.contentOffset.x/SCREEN_WIDTH);
    control.currentPage = contentX;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (WKWebView *)sourceWebView{
    if (!_sourceWebView) {
        _sourceWebView = [[WKWebView alloc]initWithFrame:self.view.bounds];
        _sourceWebView.navigationDelegate = self;
        [_sourceWebView sizeToFit];
        [self.view addSubview:_sourceWebView];

    }
    return _sourceWebView;
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"2.WKWebView开始加载页面");
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"4.WKWebView开始返回内容");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"5.WKWebView加载内容结束");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"WKWebView加载内容失败");
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"WKWebView接收到服务器跳转请求");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView
decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"3.7.WKWebView收到响应，决定是否跳转");
    NSLog(@"响应请求为 : %@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
    

}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"1.6.WKWebView在发送请求之前，决定是否跳转");
    NSLog(@"发送请求为 : %@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self deleteWebCache];
}

- (void)deleteWebCache {
    
    if([[UIDevice currentDevice].systemVersion floatValue] >=9.0) {
        
        NSSet*websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        NSDate*dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
     
        
    }else{
        
        NSString*libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES)objectAtIndex:0];
        
        NSString*cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError*errors;
        
        [[NSFileManager defaultManager]removeItemAtPath:cookiesFolderPath error:&errors];
        
    }
    NSLog(@"已经清理完了");
    
}




@end
