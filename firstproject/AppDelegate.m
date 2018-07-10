//
//  AppDelegate.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/9.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
#define LBSMAPKEY @"feaddf64a473c866213d342e680287ac"
#define BaiduAIURL @"https://aip.baidubce.com/oauth/2.0/token"
#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "TotalViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AipOcrService.h"
#import "AppDelegate+defaultSetting.h"
@interface AppDelegate ()<WXApiDelegate,UITabBarControllerDelegate>

@end
static const NSString * BaiduAppID = @"9966378";
static const NSString * BaiduApiKey = @"sLdWP9rGQ7iu63Pi4hvUP3qw";
static const NSString * BaiduSecretKey = @"WF2fWKb8lQ2bfGB5MAAsixIGXCUzWipX";


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /**
     *  向微信终端注册ID，这里的APPID一般建议写成宏,容易维护。@“测试demo”不需用管。这里的id是假的，需要改这里还有target里面的URL Type
     */
    [WXApi registerApp:@"wx519424286509f4aa"];
    [[AMapServices sharedServices] setApiKey:LBSMAPKEY];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    TotalViewController * totalVc = [[TotalViewController alloc]init];
    totalVc.delegate = self;
    
    self.window.rootViewController = totalVc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self getBaiduAIAccessToken];
    [AppDelegate getSettings];
    [AppDelegate getShareSDK];
    [AppDelegate getZhugeioWithDictionary:launchOptions];
    // Override point for customization after application launch.
    return YES;
}

//设置tabbar上第三个按钮为不可选中状态，其他的按钮为可选择状态
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//   // return ![viewController isEqual:tabBarController.viewControllers[2]];
//}
#pragma mark - 获取百度AIAccess Token。有效期为30天
- (void)getBaiduAIAccessToken{
    /*
     请求URL数据格式
     
     向授权服务地址https://aip.baidubce.com/oauth/2.0/token发送请求（推荐使用POST），并在URL中带上以下参数：
     
     grant_type： 必须参数，固定为client_credentials；
     client_id： 必须参数，应用的API Key；
     client_secret： 必须参数，应用的Secret Key；

     https://aip.baidubce.com/oauth/2.0/token?
     grant_type=client_credentials&
     client_id=Va5yQRHlA4Fq4eR3LT0vuXV4&
     client_secret= 0rDSjzQ20XUj5itV7WRtznPQSzr5pVw2&
     
     
     */
//    [[AipOcrService shardService] authWithAK:@"sLdWP9rGQ7iu63Pi4hvUP3qw" andSK:@"WF2fWKb8lQ2bfGB5MAAsixIGXCUzWipX"];

    
    
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:@"client_credentials" forKey:@"grant_type"];
    [dictionary setObject:BaiduApiKey forKey:@"client_id"];
    [dictionary setObject:BaiduSecretKey forKey:@"client_secret"];
    
    
    [NetWorkTool postNetWorkWithURL:BaiduAIURL paramaters:dictionary success:^(id object) {
        NSLog(@"%@",object);
        NSString * access_token = [object objectForKey:@"access_token"];
        NSString * expiresHaveTime = [NSString stringWithFormat:@"%@",[object objectForKey:@"expires_in"]];
        [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:AccessTokenKey];
        [[NSUserDefaults standardUserDefaults] setObject:expiresHaveTime forKey:TokenValidity];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSInteger validityTime = [expiresHaveTime integerValue];
        if (validityTime <=0 || !validityTime) {
            UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"Warring" message:@"您使用的百度AI识别功能Access_Token已失效，请重新获取" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
                    
                    
                }];
                
            }];
            
            [alertC addAction:confirmAction];
            [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
            
            
        }
        
    } failure:^(id failure) {
        
        NSLog(@"%@",failure);
    }];
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return self.window.rootViewController.supportedInterfaceOrientations;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    NSLog(@"%@",url.scheme);
    if ([url.scheme isEqualToString:@"scheme"]) {
        [self alipayUrlAction:url];
        return YES;
        
    }else if ([url.scheme isEqualToString:@"XHUPPaySigin"]){
        [self UnionpayUrlAction:url];
        return YES;
    }else{
        // 微信支付
        return [WXApi handleOpenURL:url delegate:self];
        
    }

}
#pragma mark - 银联支付
/*
 @parameter返回示例
 {
 data = "pay_result=success&tn=889767731714282290900&cert_id=68759585097";
 sign = "sXo/qtpebq97dOC24zot/z5JrmTRFYkgIXJMo/hefw5BYkW4lwbp/byxqXausUGWOowMlK8ffLNrWL9i8AeTjgRjyx2FfL0JyzjFM3+mjvvPKivEwO8aom42drNfYoTDFJim6S3M4NHJYQZCYuiNYO3ClA/etFTm2tKbVU01tIHFG7XIwIGz/eNvf0ZqD5qAj/rgQOrk7Kj7woPy0rv7mtBTeuFQs/shz0cubHyzTbMtRULNcy+y+28tjGRspSWp3LZHPKWa2De+J7iOLYiQ+pDDVLIOssiF8+ELa7PtX7RDBZ1wsGePXBHIaDF5BP+LGUMF/JMcrdcyA3yM2wIvJw==";
 }
 @parameter
 @parameter
 @parameter
 测试卡号信息：
 借记卡：6226090000000048
 手机号：18100000000
 密码：111101
 短信验证码：123456
 （短信验证码记得点下获取验证码之后再输入）
 
 贷记卡：6226388000000095；
 手机号：18100000000；
 cvn2：248；
 有效期：1219；
 短信验证码：123456
 （短信验证码记得点下获取验证码之后再输入）
 */
- (void)UnionpayUrlAction:(NSURL *)url{
    
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        NSLog(@"%@",data);
        if ([code isEqualToString:@"success"]) {
            if (data ==nil) {
                // 如果没有签名数据，建议商户app后台查询交易结果
                return ;
            }
            NSData * signData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString * sign = [[NSString alloc]initWithData:signData encoding:NSUTF8StringEncoding]
            ;
            // 此处验证verify ， 成功展示支付结果UI界面给用户，失败提示交易结果被篡改，商户app后台查询最后支付结果
            
        }else if ([code isEqualToString:@"fail"]){
            NSLog(@"交易失败");
        }else if ([code isEqualToString:@""]){
            NSLog(@"交易取消");
        }
        
    }];
}
#pragma mark - 支付宝
-(void)alipayUrlAction:(NSURL *)url{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        int status = [[resultDic valueForKey:@"resultStatus"] intValue];
        if ([[resultDic valueForKey:@"resultStatus"] intValue] == 9000) {
            if ([_aliDelegate respondsToSelector:@selector(alipaydidSuccess)]) {
                [_aliDelegate alipaydidSuccess];
            }
        }else{
            if ([_aliDelegate respondsToSelector:@selector(ailipaydidFaildWithAliPayFaildIdentifier:)]) {
                [_aliDelegate ailipaydidFaildWithAliPayFaildIdentifier:status];
            }
        }
    }];
}
#pragma mark - WXApiDelegate
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
        NSLog(@"微信支付结果回掉： %@",payResoult);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([url.scheme isEqualToString:@"scheme"]) {
        [self alipayUrlAction:url];
        return YES;

    }else{
        // 微信支付
        return [WXApi handleOpenURL:url delegate:self];

    }
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"scheme"]) {
        [self alipayUrlAction:url];
        return YES;
        
    }else{
        // 微信支付
        return [WXApi handleOpenURL:url delegate:self];
        
    }
  
    
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"你点击了%@按钮",[url host]] delegate:nil cancelButtonTitle:@"好的👌" otherButtonTitles:nil, nil];
//        [alert show];

}



@end
