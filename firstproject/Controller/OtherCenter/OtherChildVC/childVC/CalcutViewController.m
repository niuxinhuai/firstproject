//
//  CalcutViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/6/7.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "CalcutViewController.h"

@interface CalcutViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UILabel * label;
}
@property (nonatomic, strong) UIPickerView * pickerViews;
@property (nonatomic, assign) NSInteger maxCount;


@end
static const NSInteger maxT = 20000;
static const NSInteger minT = 1000;
@implementation CalcutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    _maxCount = maxT/minT;
  //  [self.view addSubview:self.pickerViews];
    label = [[UILabel alloc]init];
    label.center = CGPointMake(SCREEN_WIDTH/2, CGRectGetMaxY(self.pickerViews.frame)+30);
    label.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    label.font = [UIFont systemFontOfSize:20];
    label.textColor  =[UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSStringFromClass([self class]);
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIPickerView *)pickerViews{
    if (!_pickerViews) {
        _pickerViews = [[UIPickerView alloc]init];
        _pickerViews.center = self.view.center;
        _pickerViews.bounds = CGRectMake(0, 0, 240, 240);
        [_pickerViews.layer setBorderColor:[UIColor cyanColor].CGColor];
        [_pickerViews.layer setBorderWidth:1.0];
        _pickerViews.delegate = self;
        _pickerViews.dataSource = self;
        _pickerViews.backgroundColor = [UIColor whiteColor];
    }
    
    return _pickerViews;
}
// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
// 返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _maxCount;
}
// 返回pickerView 每行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [NSString stringWithFormat:@"%ld",(row+1)*minT];
}
// 选中行显示在label上
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    label.text = [NSString stringWithFormat:@"%ld",(row+1)*minT];
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
