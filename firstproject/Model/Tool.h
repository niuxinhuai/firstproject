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
+(NSString *)iphoneType;
//几秒前，几分钟前，几小时前，几天前    时间间隔
+(NSString *)dateIntervalStr:(NSString *)startDateStr;
@end
