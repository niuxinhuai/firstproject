//
//  Tool.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
typedef NS_ENUM(NSInteger, CJKTCheckingType) {
    phoneChecking       =  1 << 0,//手机号
    EmailChecking       =  1 << 1,//邮箱
    captchaChecking     =  1 << 2,//验证码
    passwordChecking    =  1 << 3 //密码
    
};
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class NSError;
@interface Tool : NSObject
+(instancetype)shareTool;
+ (UIImage *)imageViewWithName:(NSString *)imageName;
+(void)getNetWorkWithUrl:(NSString *)url WithParamaters:(NSString *)paramater success:(void (^)(id response))success
                         failure:( void (^)(NSError *error))failure;
//文本自适应宽度
+ (CGSize)widthWithText:(NSString *)text Font:(UIFont *)font;
//验证手机号
+ (BOOL)checkPhoneTypeWithString:(NSString *)string checkingType:(CJKTCheckingType)type;
//判断手机类型
+ (NSString *)iphoneType;
//几秒前，几分钟前，几小时前，几天前    时间间隔
+ (NSString *)dateIntervalStr:(NSString *)startDateStr;
+ (NSMutableDictionary *)getAppInformations;// 获取设备基本信息
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;// json 字符串转换字典
- (BOOL)validateIdentityCard;// 身份证号验证
- (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc;
// 获取到当前正在显示的vc
+ (void)startMonitoring;// 监听网络状态
+ (NSString *)removeSpaceAndNewline:(NSString *)str;// 移除字符串中的空格和换行
+ (BOOL)isBlank:(NSString *)str;// 判断字符串中是否包含有空格
+ (UIImage *)getAVVideoFirstPictureWithUrl:(NSString *)filePath;// 获取一个视频的第一帧图片
+ (NSInteger)getVideoTimeByUrlString:(NSString *)urlString;// 获取视频时常
- (BOOL)time_isTodayWithDate:(NSDate*)date;// 判断nsdate是不是今天
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;// 判断字符串中是否包含非法字符
+ (NSString *) vaildPassWord : (NSString *)passWd; // 判断密码有效性
<<<<<<< HEAD
-(BOOL)checkPayPWD;// 验证支付密码，不能重复连续的数字
+ (void)getPhoneRAM;// 获取手机容量
+ (NSString *)getNumberFromStr:(NSString *)str;// 获取字符串中的全部数字
=======
- (BOOL)checkPayPWD;// 验证支付密码，不能重复连续的数字
+ (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;// 将一个view保存为pdf格式
>>>>>>> master
@end

