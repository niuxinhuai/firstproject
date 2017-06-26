//
//  Tool.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "Tool.h"
#import <sys/utsname.h>

@implementation Tool
static Tool* tool = nil;
+(instancetype)shareTool{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        tool = [[Tool alloc]init];
    });
    return tool;
    
}

+ (UIImage *)imageViewWithName:(NSString *)imageName
{
    UIImage *indexPic = [UIImage imageNamed:imageName];
    UIImage *indexPicT = [indexPic imageWithRenderingMode:UIImageRenderingModeAutomatic];
    return indexPicT;
}

+(void)getNetWorkWithUrl:(NSString *)url WithParamaters:(NSString *)paramater success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    [manager GET:url parameters:paramater progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
    
    
}
+ (CGSize)widthWithText:(NSString *)text Font:(UIFont *)font
{
    
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    return size;
}
+ (BOOL)checkPhoneTypeWithString:(NSString *)string checkingType:(CJKTCheckingType)type{
    
    if (type&passwordChecking) {
        return  string.length>=6 && string.length<=18 ? YES : NO;
    }
    if (type&captchaChecking) {
        return string.length ==6? YES:NO;
    }
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange stringRange =NSMakeRange(0, string.length);
    
    if (type&phoneChecking) {
        NSRegularExpression *phoneRE = [NSRegularExpression regularExpressionWithPattern:@"^1[\\d]{10}$" options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *phoneArray = [phoneRE matchesInString:string options:NSMatchingReportProgress range:stringRange];
        if (phoneArray.count) {
            return YES;
        }
    }
    
    if (type&EmailChecking) {
        NSRegularExpression *mailRE = [NSRegularExpression regularExpressionWithPattern:@"^([a-zA-Z0-9]+[_|\\_|\\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\\_|\\.]?)*[a-zA-Z0-9]+\\.[a-zA-Z]{2,3}$" options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *mailArray = [mailRE matchesInString:string options:NSMatchingReportProgress range:stringRange];
        if (mailArray.count) {
            return YES;
        }
        
    }
    
    
   
    
    
    return NO;
}
//几秒前，几分钟前，几小时前，几天前    时间间隔
+(NSString *)dateIntervalStr:(NSString *)startDateStr
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1 = [formatter dateFromString:startDateStr];
    NSDate *date2 = [NSDate date];
    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
    
    NSString *intervalDateStr = @"";
    if (aTimer < 60) {
        intervalDateStr = [NSString stringWithFormat:@"%.0f 秒前",aTimer];
    }else if (aTimer >= 60 && aTimer < 3600){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 分钟前",aTimer/60];
    }else if (aTimer >= 3600 && aTimer < 3600*24){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 小时前",aTimer/3600];
    }else if (aTimer >= 3600*24){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 天前",aTimer/(3600*24)];
    }
    return intervalDateStr;
}

+(NSString *)iphoneType{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
    
    
    
}



@end
