//
//  AppDelegate.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/9.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
#define LBSMAPKEY @"feaddf64a473c866213d342e680287ac"
#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "TotalViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /**
     *  向微信终端注册ID，这里的APPID一般建议写成宏,容易维护。@“测试demo”不需用管。这里的id是假的，需要改这里还有target里面的URL Type
     */
    [WXApi registerApp:@"wx519424286509f4aa"];
    [[AMapServices sharedServices] setApiKey:LBSMAPKEY];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    TotalViewController * totalVc = [[TotalViewController alloc]init];
    self.window.rootViewController = totalVc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    NSLog(@"%@",url.scheme);
    if ([url.scheme isEqualToString:@"scheme"]) {
        [self alipayUrlAction:url];
        return YES;
        
    }else{
        // 微信支付
        return [WXApi handleOpenURL:url delegate:self];
        
    }

}
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
