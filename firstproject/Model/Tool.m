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
+(NSMutableDictionary *)getAppInformations{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    
    
    //手机序列号
    NSUUID* identifierNumber = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"手机序列号: %@",identifierNumber);
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [Tool iphoneType];
    NSLog(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    
    [dic setObject:@"app名称" forKey:app_Name];
    [dic setObject:@"app版本" forKey:app_Version];
    [dic setObject:@"app_bulid版本" forKey:app_build];
    [dic setObject:@"手机序列号" forKey:identifierNumber];
    [dic setObject:@"手机别名" forKey:userPhoneName];
    [dic setObject:@"设备名称" forKey:deviceName];
    [dic setObject:@"手机系统版本" forKey:phoneVersion];
    [dic setObject:@"手机型号" forKey:phoneModel];
    [dic setObject:@"国际化区域名称" forKey:localPhoneModel];
//    // 当前应用名称
//    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    NSLog(@"当前应用名称：%@",appCurName);
//    // 当前应用软件版本  比如：1.0.1
//    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"当前应用软件版本:%@",appCurVersion);
//    // 当前应用版本号码   int类型
//    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
//    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    
    
    
    
    return dic;
}
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
- (BOOL)validateIdentityCard {
//    BOOL flag;
//    if (self.length <= 0) {
//        flag = NO;
//        return flag;
//    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}
- (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController*) vc) visibleViewController]];
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        return [self getVisibleViewControllerFrom:[((UITabBarController*) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}
+(void)startMonitoring{
    
    // 监听网络状况
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                break;
            case AFNetworkReachabilityStatusNotReachable: {
               // [SVProgressHUD showInfoWithStatus:@"当前设备无网络"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
              //  [SVProgressHUD showInfoWithStatus:@"当前Wi-Fi网络"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
               // [SVProgressHUD showInfoWithStatus:@"当前蜂窝移动网络"];
                break;
            default:
                break;
        }
    }];
    [mgr startMonitoring];
}
+ (NSString *)removeSpaceAndNewline:(NSString *)str {
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}
+ (BOOL)isBlank:(NSString *)str {
    NSRange _range = [str rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        return YES;
    } else {
        //没有空格
        return NO;
    }
}
+(UIImage *)getAVVideoFirstPictureWithUrl:(NSString *)filePath{
    
    NSURL *url = [NSURL URLWithString:filePath];
    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
    generate1.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 2);
    CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
    UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
    
    return one;
    
}
+ (NSInteger)getVideoTimeByUrlString:(NSString *)urlString {
    NSURL *videoUrl = [NSURL URLWithString:urlString];
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:videoUrl];
    CMTime time = [avUrl duration];
    int seconds = ceil(time.value/time.timescale);
    return seconds;
}
- (BOOL)time_isTodayWithDate:(NSDate*)date{
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era]) {
        // 是今天
        return YES;
    }
    
    return NO;
}
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content{
    
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    
    if (![emailTest evaluateWithObject:content]) {
        
        return YES;
        
    }
    
    return NO;
    
}
+(NSString *) vaildPassWord : (NSString *)passWd

{
    
    NSString *errMsg = nil;
    
    if (passWd == nil || passWd.length == 0) {
        
        errMsg = @"密码为空";
        
    } else if(passWd.length < 6){
        
        errMsg = @"密码长度最少6位";
        
    } else if([self JudgeTheillegalCharacter:passWd]){
        
        errMsg = @"密码中不能包含非法字符";
        
    }
    
    return errMsg;
    
}
-(BOOL)checkPayPWD{
    NSString *validCode = @"^(?:([0-9])\\1{5})$";  //   \\d1{5}$
    NSPredicate *validCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",validCode];
    BOOL res = [validCodePredicate evaluateWithObject:self];
    //自动验证密码是否为6个重复（111111）或连续（123456）的数字
    
    if([@"012345678901234" rangeOfString:self].location !=NSNotFound || res  )//_roaldSearchText
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

//+ (void)getPhoneRAM{
//    mach_port_t host_port;
//    mach_msg_type_number_t host_size;
//    vm_size_t pagesize;
//    
//    host_port = mach_host_self();
//    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
//    host_page_size(host_port, &pagesize);
//    
//    vm_statistics_data_t vm_stat;
//    
//    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
//        NSLog(@"Failed to fetch vm statistics");
//    }
//    
//    /* Stats in bytes */
//    natural_t mem_used = (vm_stat.active_count +
//                          vm_stat.inactive_count +
//                          vm_stat.wire_count) * pagesize;
//    natural_t mem_free = vm_stat.free_count * pagesize;
//    natural_t mem_total = mem_used + mem_free;
//    NSLog(@"已用: %u 可用: %u 总共: %u", mem_used, mem_free, mem_total);
//}


- (NSString *)getNumberFromStr:(NSString *)str
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

- (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:pdfContext];
    UIGraphicsEndPDFContext();
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
}
+(void)openCameraPermissions{
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

@end
