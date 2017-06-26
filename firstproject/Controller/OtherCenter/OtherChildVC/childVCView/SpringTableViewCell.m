//
//  SpringTableViewCell.m
//  firstproject
//
//  Created by 牛新怀 on 2017/6/10.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "SpringTableViewCell.h"
@interface SpringTableViewCell ()
{
   CGFloat  cellHeight;
    CGRect buttonRect;
    NSInteger chouseSelect;
    BOOL isSelects;
}
@end

static const NSString * cellTitles = @"罚款烦恼吗，钉女款女就开始带你看不见的三跪九叩时代发生纠纷了放假了深刻的疯狂了";
@implementation SpringTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {



        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(UILabel *)label{
//    if(!_label ){
//
//    }
//    return _label;
//    
//}
-(UILabel *)detailLabels{
    if (!_detailLabels) {
        _detailLabels = [[UILabel alloc]init];
        _detailLabels.font = [UIFont systemFontOfSize:18];
        _detailLabels.textColor = [UIColor redColor];
        _detailLabels.numberOfLines = 0;
        _detailLabels.text = @"罚款烦恼吗，钉女款女就开始带你看不见的三跪九叩时代发生纠纷了放假了深刻的疯狂了";;
        
        [self addSubview:_detailLabels];
    }
    
    return _detailLabels;
}
-(void)setTags:(NSInteger)tags{
    _tags = tags;
    NSString * titles = @"时尚大方牛筋底女奶咖女金卡空间啊 v 多谋善断贩卖，俺方面，内分泌，收到减肥那地方呐代码，吗，嗯噩梦，呃看你能否是能发生的马放南山的吗钉女款女就开始带你看不见的三跪九叩时";
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    view.backgroundColor = [UIColor cyanColor];
    [self addSubview:view];
    self.circleButton.tag = _tags;
    _label = [[UILabel alloc]init];
    _label.font = [UIFont systemFontOfSize:16];
    _label.textColor = [UIColor blackColor];
    _label.numberOfLines = 0;
    _label.backgroundColor = [UIColor purpleColor];
    _label.frame = CGRectMake(10, 40, SCREEN_WIDTH-20, CGRectGetHeight(self.frame)-30);
    NSLog(@"父视图的高度为 ：%f  \n当前label的高度为 %f",self.contentView.frame.size.height,_label.frame
          .size.height);
    // _label.tag = _tags+90;
    _label.text = @"时尚大方牛筋底女奶咖女金卡空间啊 v 多谋善断贩卖，俺方面，内分泌，收到减肥那地方呐代码，吗，嗯噩梦，呃看你能否是能发生的马放南山的吗钉女款女就开始带你看不见的三跪九叩时";
    [self addSubview:_label];



}
-(UIButton *)circleButton{
    if (!_circleButton) {
        _circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_circleButton setTitle:@"展开" forState:UIControlStateNormal];
        _circleButton.frame = CGRectMake(30, 10, 50, 20);

        [_circleButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_circleButton addTarget:self action:@selector(changeCellHeight:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_circleButton];
    }
    
    
    return _circleButton;
}
-(void)changeCellHeight:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case 10:
        {
            UIButton * btn = [self viewWithTag:sender.tag];
            btn.selected =!btn.selected;
            isSelects = btn.selected;
            if (btn.selected) {
                
                [self.circleButton setTitle:@"闭合" forState:UIControlStateNormal];
            }else{
                [self.circleButton setTitle:@"展开" forState:UIControlStateNormal];
            }
            if ([self.delegate respondsToSelector:@selector(changeCellHeigh:withselectTag:withSelect:)]) {
                [self.delegate changeCellHeigh:300 withselectTag:sender.tag withSelect:btn.selected];
            }
            break;
        }
        case 11:
        {
            UIButton * btn = [self viewWithTag:sender.tag];
            btn.selected =!btn.selected;
            isSelects = btn.selected;
            if (btn.selected) {
                
                [self.circleButton setTitle:@"闭合" forState:UIControlStateNormal];
            }else{
                [self.circleButton setTitle:@"展开" forState:UIControlStateNormal];
            }
            if ([self.delegate respondsToSelector:@selector(changeCellHeigh:withselectTag:withSelect:)]) {
                [self.delegate changeCellHeigh:300 withselectTag:sender.tag withSelect:btn.selected];
            }

            
            break;
        }
        case 12:
        {
            UIButton * btn = [self viewWithTag:sender.tag];
            btn.selected =!btn.selected;
            isSelects = btn.selected;
            if (btn.selected) {
                
                [self.circleButton setTitle:@"闭合" forState:UIControlStateNormal];
            }else{
                [self.circleButton setTitle:@"展开" forState:UIControlStateNormal];
            }
            if ([self.delegate respondsToSelector:@selector(changeCellHeigh:withselectTag:withSelect:)]) {
                [self.delegate changeCellHeigh:300 withselectTag:sender.tag withSelect:btn.selected];
            }
            

            
            break;
        }
        default:
            break;
    }
    
    
    

    
    
   
      


    
  

    
}
@end
