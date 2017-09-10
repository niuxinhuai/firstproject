//
//  PictureBrowserViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/9/9.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "PictureBrowserViewController.h"
#import "PhotoBrowser.h"
@interface PictureBrowserViewController ()
{
    CGRect normalRect;
    UIView * views;
}
@property (strong ,nonatomic) UIImageView * normalImage;
@property (strong, nonatomic) NSMutableArray     * imageArray;
@property (nonatomic, strong) UIImageView         *imgView;

@end

@implementation PictureBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageArray = [PhotoBrowser imageDataSourceArray];
    NSLog(@"%@",self.imageArray);
    UIImage *img = [UIImage imageNamed:@"m8.jpg"];
    CGSize size;
    size.height = 120;
    size.width = size.height / img.size.height * img.size.width;
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 70, size.width, size.height)];
    normalRect = CGRectMake(70, 70, size.width, size.height);
    _imgView.image = img;
    _imgView.userInteractionEnabled = YES;
    [self.view addSubview:_imgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSecond)];
    [_imgView addGestureRecognizer:tap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}
- (void)pushSecond{
     views  = [[UIView alloc]init];
    views.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:views];
//    [UIView animateWithDuration:1 animations:^{
//        _imgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//        CGSize size = [self backImageSize:_imgView.image];
//        _imgView.bounds = CGRectMake(0, 0, size.width, size.height);
//        
//    } completion:^(BOOL finished) {
//        
//        
//    }];
    [views addSubview:_imgView];
    views.backgroundColor = [UIColor blackColor];
    
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _imgView.frame = [self backScreenImageViewRectWithImage:_imgView.image];
        views.alpha = 1;
        
    } completion:^(BOOL finished) {
        if (finished) {
            UITapGestureRecognizer * taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleGesture)];
            [_imgView addGestureRecognizer:taps];
        }

    }];

}
- (void)cancleGesture{
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [views removeFromSuperview];

         [self.view addSubview:_imgView];
        _imgView.frame = normalRect;
//        views.alpha = 0;
        
    } completion:^(BOOL finished) {
        if (finished) {

           
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSecond)];
            [_imgView addGestureRecognizer:tap];
        }
        
    }];
}
//返回imageView在window上全屏显示时的frame
- (CGRect)backScreenImageViewRectWithImage:(UIImage *)image{
    
    CGSize size = image.size;
    CGSize newSize;
    newSize.width = SCREEN_WIDTH;
    newSize.height = newSize.width / size.width * size.height;
    
    CGFloat imageY = (SCREEN_HEIGHT - newSize.height) * 0.5;
    
    if (imageY < 0) {
        imageY = 0;
    }
    CGRect rect =  CGRectMake(0, imageY, newSize.width, newSize.height);
    
    return rect;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
