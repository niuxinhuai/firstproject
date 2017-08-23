//
//  CJKTZCodeViewController.h
//  超级课堂
//
//  Created by 牛新怀 on 17/4/25.
//  Copyright © 2017年 刘鹏程. All rights reserved.
//

#import "NBasiViewController.h"
#import <AVFoundation/AVFoundation.h>
typedef void(^CKUniversityBlock)(NSString * contents);
typedef void(^CKNoPermissionsBlock)();
@interface CJKTZCodeViewController : NBasiViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    //会话
    AVCaptureSession *_captureSession;
    //摄像头预览
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
}
@property (nonatomic,assign)BOOL qrcodeFlag ;
@property (nonatomic,copy) CKUniversityBlock wenhuiUniversityConfirmBlock;
@property (nonatomic,copy) CKNoPermissionsBlock noneCameraPermissionsBlock;
@end
