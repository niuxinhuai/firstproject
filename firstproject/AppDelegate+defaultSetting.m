//
//  AppDelegate+defaultSetting.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/29.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import <WXApi.h>
//新浪微博SDK头文件<
#import <WeiboSDK.h>
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加”-ObjC”
#import "AppDelegate+defaultSetting.h"

static const NSString * ShareAppKey    = @"208f02dc99aa0";
static const NSString * ShareAppSecret = @"91d0deb55119eb201cd7b722a417160c";
static NSString * ZhugeiosAppKey = @"257fd96e6ee54319a0ec385b47410539";
@implementation AppDelegate (defaultSetting)
/*
 @parameter 获取系统设置中setting.bundle中的个人设置
 如果运行应用后直接直接通过上面的代码获取信息，你会得到null；原因是：
 root.plist实际上只是一个静态文件用来在设置里显示；只有当你对它进行修改，它才会往NSUserDefaults里添加。修改配置后，NSUserDefaults的优先级高于root.plist文件。
 */

+ (void)getSettings{
    //获取SettingsBundle信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"setting.bundle中个人设置title_perference： %@",[userDefaults objectForKey:@"title_perference"]);
    NSLog(@"setting.bundle中个人设置sex_perference: %@",[userDefaults objectForKey:@"sex_perference"]);
    NSLog(@"setting.bundle中个人设置name_preference:  %@",[userDefaults objectForKey:@"name_preference"]);
    NSLog(@"setting.bundle中个人设置enabled_preference:  %@",[userDefaults objectForKey:@"enabled_preference"]);
    NSLog(@"setting.bundle中个人设置slider_preference:  %@",[userDefaults objectForKey:@"slider_preference"]);

}
+ (void)getShareSDK{
    /**初始化ShareSDK应用
     @param activePlatforms
     使用的分享平台集合
     @param importHandler (onImport)
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     @param configurationHandler (onConfiguration)
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     */
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeMail),
                                        @(SSDKPlatformTypeSMS),
                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformTypeRenren),
                                        @(SSDKPlatformTypeFacebook),
                                        @(SSDKPlatformTypeTwitter),
                                        @(SSDKPlatformTypeGooglePlus),
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
             [ShareSDKConnector connectWeChat:[WXApi class]];
             break;
             case SSDKPlatformTypeQQ:
             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
             break;
             case SSDKPlatformTypeSinaWeibo:
             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
             break;
//             case SSDKPlatformTypeRenren:
//             [ShareSDKConnector connectRenren:[RennClient class]];
//             break;
             default:
             break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
             //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
             [appInfo SSDKSetupSinaWeiboByAppKey:@"2573116776"
                                       appSecret:@"5c4924e835505adad709033c37ffdc5b"
                                     redirectUri:@"http://www.sharesdk.cn"
                                        authType:SSDKAuthTypeBoth];
             break;
             case SSDKPlatformTypeWechat:
             [appInfo SSDKSetupWeChatByAppId:@"wxe52dbd332cc60316"
                                   appSecret:@"152bdb0bfa3a1eb9a90a07d38e5c8829"];
             break;
             case SSDKPlatformTypeQQ:
             [appInfo SSDKSetupQQByAppId:@"100477688"
                                  appKey:@"392214bf9f4aa719da7e2d0c2a2dc0d0"
                                authType:SSDKAuthTypeBoth];
             break;
             case SSDKPlatformTypeRenren:
             [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                             appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                          secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                           authType:SSDKAuthTypeBoth];
             break;
             case SSDKPlatformTypeFacebook:
             [appInfo SSDKSetupFacebookByApiKey:@"107704292745179"
                                      appSecret:@"38053202e1a5fe26c80c753071f0b573"
                                    displayName:@"shareSDK"
                                       authType:SSDKAuthTypeBoth];
             break;
             case SSDKPlatformTypeTwitter:
             [appInfo SSDKSetupTwitterByConsumerKey:@"LRBM0H75rWrU9gNHvlEAA2aOy"
                                     consumerSecret:@"gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G"
                                        redirectUri:@"http://mob.com"];
              break;
              case SSDKPlatformTypeGooglePlus:
              [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                                        clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                         redirectUri:@"http://localhost"];
               break;
               default:
               break;
               }
               }];
    //      [appInfo SSDKSetupWeChatByAppId:@"wx519424286509f4aa"
//appSecret:@"279e4df1b2c3352abb992dc6a759a6b7"];
}

+ (void)getZhugeioWithDictionary:(NSDictionary *)launchOptions{
    [[Zhuge sharedInstance].config setDebug:YES];
    [[Zhuge sharedInstance] startWithAppKey:ZhugeiosAppKey launchOptions:launchOptions];
}
@end
