//
//  ButtonView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/27.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "ButtonView.h"
#import <UIImageView+WebCache.h>
@implementation ButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect{
    //self.backgroundColor = [UIColor whiteColor];
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-15);
    imageV.bounds = CGRectMake(0, 0, 40, 40);
    imageV.image = [UIImage imageNamed:_imageNamed];
    [self addSubview:imageV];
    CGSize size = [Tool widthWithText:_LabelTitle Font:[UIFont systemFontOfSize:13]];
    UILabel * label = [[UILabel alloc]init];
    label.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+14);
    label.bounds = CGRectMake(0, 0, size.width, size.height);
    label.text = _LabelTitle;
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    
    
    
}
-(void)setImageNamed:(NSString *)imageNamed{
    _imageNamed = imageNamed;
}
-(void)setLabelTitle:(NSString *)LabelTitle{
    _LabelTitle = LabelTitle;
}
@end
