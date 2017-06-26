//
//  FoucesView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/26.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "FoucesView.h"
@interface FoucesView()
@property (nonatomic, strong) UILabel * fouseLabel;
@end
@implementation FoucesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor cyanColor];
    
    self.fouseLabel.center = CGPointMake(rect.size.width/2, rect.size.height/2)
    ;
    CGSize size = [Tool widthWithText:self.fouseLabel.text Font:[UIFont systemFontOfSize:14]];
    self.fouseLabel.bounds = CGRectMake(0, 0, size.width, size.height);
    
    
    
}

-(UILabel *)fouseLabel{
    if (!_fouseLabel) {
        _fouseLabel = [[UILabel alloc]init];
        _fouseLabel.textColor = [UIColor blackColor];
        _fouseLabel.font = [UIFont systemFontOfSize:14];
        _fouseLabel.text = @"你已关注改用户，后续更新会有提醒";
        [self addSubview:_fouseLabel];
    }
    
    return _fouseLabel;
}

@end
