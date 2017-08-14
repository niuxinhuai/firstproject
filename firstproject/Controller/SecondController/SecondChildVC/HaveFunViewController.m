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
#import <sqlite3.h>
@interface HaveFunViewController ()<PictureIdentifyDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSURLSessionTaskDelegate,AipOcrDelegate>
{
    FMDatabase * _db;
}
@property (nonatomic, strong)BaiduAIPictureIdentifyView * pictureIdentifyView;
@property (nonatomic, strong)UIImage * finalImage;
@property (assign, nonatomic) UIImageOrientation imageOrientation;

@end
static NSString * id_cord_url = @"https://aip.baidubce.com/rest/2.0/ocr/v1/idcard";
static sqlite3 * db = nil;

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
    [self createSqlite];
    [self createBankSqlite];
    

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
    NSString * card_number =result[@"result"][@"bank_card_number"];
    NSString * card_type =result[@"result"][@"bank_card_type"];
    NSString * bank_name = result[@"result"][@"bank_name"];
    
    NSString * sql = [NSString stringWithFormat:@"insert into bank_list(bank_card_type,bank_name,bank_card_number) values('%@','%@','%@');",card_type,bank_name,card_number];
    char * errorMsg;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errorMsg);
    
    if (errorMsg) {
        NSLog(@"失败原因 -%s",errorMsg);
    }else{
        NSLog(@"OK");
    }
    
    
    [message appendFormat:@"卡号：%@\n", card_number];
    [message appendFormat:@"类型：%@\n", card_type];
    [message appendFormat:@"发卡行：%@\n",bank_name];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alertView show];
        
        }];
    
        NSString * sqls = @"select * from bank_list;";
    
        //查询的句柄,游标
        sqlite3_stmt * stmt;
    
        if (sqlite3_prepare(db, sqls.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
    
            //查询数据
            while (sqlite3_step(stmt) == SQLITE_ROW) {
    
                //获取表数据的内容
                //sqlite3_column_text('句柄'，字段索引值)
    
                NSString * name = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
    
                NSLog(@"name = %@",name);
    
            }
        }
    



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

-(void)createSqlite{
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * fileName = [path stringByAppendingPathComponent:@"Sqlite.sqlite"];
    NSLog(@"%@",fileName);
    if ((sqlite3_open(fileName.UTF8String, &db )== SQLITE_OK)) {
        NSLog(@"打开数据库成功");
        NSString * sql = @"create table if not exists t_text (id integer primary key autoincrement,name text);";
        char * errmsg;
        sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"建表失败 -- %s",errmsg);
        }else{
            NSLog(@"建表成功");
        }
    }else{
        NSLog(@"失败");
    }
}

- (void)createBankSqlite{
    
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * fileName = [path stringByAppendingPathComponent:@"Sqlite.sqlite"];
    NSLog(@"%@",fileName);
    if ((sqlite3_open(fileName.UTF8String, &db )== SQLITE_OK)) {
        NSLog(@"打开数据库成功");
        NSString * sql = @"create table if not exists bank_list (id integer primary key autoincrement,bank_card_type text NOT NULL,bank_name text NOT NULL,bank_card_number text NOT NULL);";
        char * errmsg;
        sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"建表失败 -- %s",errmsg);
        }else{
            NSLog(@"建表成功");
        }
    }else{
        NSLog(@"失败");
    }
    
    
}

#pragma mark - 数据库增加数据
//    NSString * sql = [NSString stringWithFormat:@"insert into t_text(name) values('%@');",[NSString stringWithFormat:@"小丸子--%d",arc4random_uniform(20)]];
//    char * errorMsg;
//    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errorMsg);
//    if (errorMsg) {
//        NSLog(@"失败原因 -%s",errorMsg);
//    }else{
//        NSLog(@"OK");
//    }
#pragma mark - 数据库删除数据操作
//    NSString * sql = @"delete from t_text where id > 3 and id < 6;";
//    char * errmsg;
//    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
//    if (errmsg) {
//        NSLog(@"删除失败--%s",errmsg);
//    }else{
//        NSLog(@"删除成功");
//    }
#pragma mark - 数据库更新数据操作
//    NSString * sql = @"update t_text set name = 'hello-world' where id = 9;";
//    char * errmsg;
//    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
//    if (errmsg) {
//        NSLog(@"修改失败--%s",errmsg);
//    }else{
//        NSLog(@"修改成功");
//    }
#pragma mark - 数据库查询操作
//    NSString * sql = @"select * from t_text;";
//
//    //查询的句柄,游标
//    sqlite3_stmt * stmt;
//
//    if (sqlite3_prepare(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
//
//        //查询数据
//        while (sqlite3_step(stmt) == SQLITE_ROW) {
//
//            //获取表数据的内容
//            //sqlite3_column_text('句柄'，字段索引值)
//
//            NSString * name = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
//
//            NSLog(@"name = %@",name);
//
//        }
//    }

@end
