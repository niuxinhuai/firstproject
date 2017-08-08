//
//  HaveFunViewController.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,UIImagePickerSourceType){
    UIImagePickerSourceTypePhotoLibrary,//相册
    UIImagePickerSourceTypeCamera
};
@interface HaveFunViewController : NBasiViewController
@property (nonatomic, assign)UIImagePickerSourceType imagePickerType;
@end
