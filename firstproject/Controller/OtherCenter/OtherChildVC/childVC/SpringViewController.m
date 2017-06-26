//
//  SpringViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/6/7.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "SpringViewController.h"
#import "SpringTableViewCell.h"
@interface SpringViewController ()<UITableViewDelegate,UITableViewDataSource,SpringTableViewCellDelegate>
{
    NSInteger selectRow;
    CGFloat selectHeight;
    BOOL isSelectRow;
    UILabel * _detailLabels;
    UILabel * labes;
    
    CGFloat cellheight;
}
@property (strong, nonatomic) UITableView * videoTableView;
@end

@implementation SpringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectHeight =  150;
    // Do any additional setup after loading the view.
    UILabel * label = [[UILabel alloc]init];
    label.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    label.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    label.font = [UIFont systemFontOfSize:20];
    label.textColor  =[UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSStringFromClass([self class]);
    [self.view addSubview:label];
    self.videoTableView.backgroundColor = [UIColor whiteColor];
}
-(UITableView *)videoTableView{
    if (!_videoTableView) {
        _videoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _videoTableView.delegate = self;
        _videoTableView.dataSource = self;
        _videoTableView.backgroundColor = [UIColor whiteColor];
        _videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_videoTableView];
        

    }
    
    
    return _videoTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"CELLID";
    SpringTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SpringTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
     cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //删除cell的所有子视图
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    cell.tags = indexPath.row+10;
   


    return cell;
    
}
-(void)getCellHeightWithHeight:(CGFloat)h{
    cellheight = h;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (isSelectRow &&selectRow == indexPath.row ) {
        return 130;
    }else{
        return 80;
    }
   
  
   
}

-(void)changeCellHeigh:(CGFloat)h withselectTag:(NSInteger)tagss withSelect:(BOOL)isSelect{
    selectHeight = h;
    selectRow = tagss-10;
    isSelectRow = isSelect;
   // [_videoTableView reloadData];
    
    [_videoTableView beginUpdates];
    NSIndexPath * path = [NSIndexPath indexPathForRow:tagss-10 inSection:0];
    [_videoTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    [_videoTableView endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
