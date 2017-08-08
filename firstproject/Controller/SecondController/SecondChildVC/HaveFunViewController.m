//
//  HaveFunViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "HaveFunViewController.h"
#import "BaiduAIPictureIdentifyView.h"
#import "UIImage+XFCircle.h"
#import "AipOcrSdk.h"
#import "AipOcrService.h"
#import <AipBase/AipBase.h>
#import "AipOcrDelegate.h"
#import "AipCaptureCardVC.h"
@interface HaveFunViewController ()<PictureIdentifyDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSURLSessionTaskDelegate,AipOcrDelegate>
@property (nonatomic, strong)BaiduAIPictureIdentifyView * pictureIdentifyView;
@property (nonatomic, strong)UIImage * finalImage;
@property (assign, nonatomic) UIImageOrientation imageOrientation;

@end
static NSString * id_cord_url = @"https://aip.baidubce.com/rest/2.0/ocr/v1/idcard";
@implementation HaveFunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initWithView{
    [self.view addSubview:self.pictureIdentifyView];
    self.imageOrientation = UIDeviceOrientationPortrait;
    [[AipOcrService shardService] clearCache];
    [[AipOcrService shardService] authWithAK:@"sLdWP9rGQ7iu63Pi4hvUP3qw" andSK:@"WF2fWKb8lQ2bfGB5MAAsixIGXCUzWipX"];

    // 若未添加至主工程，则[NSBundle mainBundle]修改为对应bundle
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    [[AipOcrService shardService] getTokenSuccessHandler:^(NSString *token) {
        
        NSLog(@"%@",token);
    } failHandler:^(NSError *error) {
        NSLog(@"%@",error);

        
    }];
    

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BaiduAIPictureIdentifyView *)pictureIdentifyView{
    if (!_pictureIdentifyView) {
        _pictureIdentifyView = [[BaiduAIPictureIdentifyView alloc]init];
        _pictureIdentifyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _pictureIdentifyView.backgroundColor = [UIColor cyanColor];
        _pictureIdentifyView.delegate = self;
        
    }
    
    return _pictureIdentifyView;
}

- (void)baiduAiViewClassNameView:(BaiduAIPictureIdentifyView *)view{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"百度AI" message:@"请先选择类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"身份证正面拍照识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self idcardOCROnline];

    }];
    UIAlertAction * confirmActions = [UIAlertAction actionWithTitle:@"身份证反面拍照识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self idcardOCRBackOnline];
    }];
    UIAlertAction * confirmAction1 = [UIAlertAction actionWithTitle:@"银行卡正面拍照识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self bankCardOCROnline];
    }];
    UIAlertAction * confirmAction2 = [UIAlertAction actionWithTitle:@"机动车车牌识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self controllerButtonSelectSourceType:UIImagePickerSourceTypeCamera];
    }];
    
    UIAlertAction * confirmAction3 = [UIAlertAction actionWithTitle:@"用户头像审核" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self controllerButtonSelectSourceType:UIImagePickerSourceTypePhotoLibrary];
    }];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }];
    [cancleAction setValue:[UIColor redColor] forKey:@"titleTextColor"];

    [controller addAction:cancleAction];
    [controller addAction:confirmAction];
    [controller addAction:confirmActions];
    [controller addAction:confirmAction1];
    [controller addAction:confirmAction2];
    [controller addAction:confirmAction3];
    [self presentViewController:controller animated:YES completion:nil];

}
#pragma mark - 银行卡识别
- (void)bankCardOCROnline{
    
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard andDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 身份证正面识别
- (void)idcardOCROnline {
    
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont andDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 身份证反面识别
- (void)idcardOCRBackOnline{
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardBack andDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)controllerButtonSelectSourceType:(UIImagePickerSourceType)type{
    switch (type) {
        case UIImagePickerSourceTypeCamera:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;//是否可以编辑
            
            //打开相机
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:nil];
            
            break;
        }
        case UIImagePickerSourceTypePhotoLibrary:
        {
//            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
//            picker.delegate = self;
//            picker.allowsEditing = YES;//是否可以编辑
//            
//            //打开相册选择照片
//            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            
//            [self presentViewController:picker animated:YES completion:nil];
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;//是否可以编辑
            
            //打开相机
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:nil];
            
            break;
        }
        default:
            break;
    }
    
    
}
#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary || picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
           
            image = [UIImage resizeImage:image];
            self.finalImage = [UIImage sapicamera_rotateImageEx:image.CGImage orientation:self.imageOrientation];
            self.pictureIdentifyView.imageNamed = image;
            
            NSData *data;
            if (UIImagePNGRepresentation(image) == nil) {
                data = UIImageJPEGRepresentation(image, 1.0);
            } else {
                data = UIImagePNGRepresentation(image);
            }
            data = UIImagePNGRepresentation(image);
            NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
//            NSString *strUrl = [imageStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//            NSString * access_token = [[NSUserDefaults standardUserDefaults] objectForKey:AccessTokenKey];
//            NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
//           // [dic setObject:access_token forKey:@"access_token"];
//            [dic setObject:strUrl forKey:@"image"];
//            [dic setObject:@"front" forKey:@"id_card_side"];
           // [self my_recodeIdentifyWithParamater:dic withImageStr:imageStr];
            [self carCardWithImage:image];

        }
    }];
}

#pragma mark - 机动车车牌号识别 / 用户头像审核
- (void)carCardWithImage:(UIImage *)image{
    switch (self.imagePickerType) {
        case UIImagePickerSourceTypeCamera:
        {
            [NetWorkTool postNetWorkWithImage:image types:CardTypeCarCard withURL:nil paramaters:nil success:^(id object) {
                NSLog(@"%@",object);
                [self ocrOnCarCardSuccessful:object];
                
            } failure:^(id failure) {
                
                [self ocrOnFail:failure];
            }];
            break;
        }
        case UIImagePickerSourceTypePhotoLibrary:
        {
            [NetWorkTool postNetWorkWithImage:image types:CardTypeFaceProfileAudit withURL:nil paramaters:nil success:^(id object) {
                NSLog(@"%@",object);
                [self ocrOnFaceProplieAutie:object];
                
            } failure:^(id failure) {
                
                [self ocrOnFail:failure];
            }];
            break;
        }
        default:
            break;
    }

}
- (void)ocrOnFaceProplieAutie:(id)result{
   // NSString *msg = [NSString stringWithFormat:@"%@", result];
     NSMutableString *message = [NSMutableString string];
    NSArray * array1 = result[@"result"];
    NSDictionary * dic = array1[0];
    
    NSArray * array = dic[@"data"][@"ocr"][@"words_result"];
    for (int idx =0; idx<array.count; idx++) {
        NSDictionary * dic = array[idx];
        [message appendFormat:@"图片内容: %@\n", dic[@"words"]];

    }

   // [message appendFormat:@"图片内容：%@\n", result[@"words_result"][@"color"]];
    [message appendFormat:@"其他信息：%@\n", dic[@"data"][@"face"][@"result"][0]];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"用户头像审核" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}


- (void)ocrOnCarCardSuccessful:(id)result{
    NSLog(@"%@", result);
    NSString *title = nil;
    NSMutableString *message = [NSMutableString string];
    title = @"机动车车牌信息";
    //    [message appendFormat:@"%@", result[@"result"]];
    [message appendFormat:@"颜色：%@\n", result[@"words_result"][@"color"]];
    [message appendFormat:@"车牌号：%@\n", result[@"words_result"][@"number"]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)ocrOnBankCardSuccessful:(id)result {
    NSLog(@"%@", result);
    NSString *title = nil;
    NSMutableString *message = [NSMutableString string];
    title = @"银行卡信息";
    //    [message appendFormat:@"%@", result[@"result"]];
    [message appendFormat:@"卡号：%@\n", result[@"result"][@"bank_card_number"]];
    [message appendFormat:@"类型：%@\n", result[@"result"][@"bank_card_type"]];
    [message appendFormat:@"发卡行：%@\n", result[@"result"][@"bank_name"]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)ocrOnFail:(id)error {
    NSLog(@"%@", error);
    NSString *msg = [NSString stringWithFormat:@"%@", error];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}

- (void)ocrOnIdCardSuccessful:(id)result {
    NSLog(@"%@", result);
    NSString *title = nil;
    NSMutableString *message = [NSMutableString string];
    NSDictionary *dic = result[@"words_result"];
    if(dic&&dic.count >0){
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
        }];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"保存图片",nil];
        alertView.tag = 255;
        [alertView show];
    }];
}

@end
