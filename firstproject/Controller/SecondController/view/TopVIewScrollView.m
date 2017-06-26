//
//  TopVIewScrollView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "TopVIewScrollView.h"
@interface TopVIewScrollView ()
@property (nonatomic, strong)UIButton * button;
@end
@implementation TopVIewScrollView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setExtraLabelArray:(NSArray *)extraLabelArray{
    _extraLabelArray = extraLabelArray;
    self.scrollEnabled = YES;
    for (UIButton * sender in self.subviews) {
        [sender removeFromSuperview];
    }
    CGFloat scaleW = 7;
    CGFloat w=0;
    if (_extraLabelArray.count !=0) {
        for (int idx =0; idx<_extraLabelArray.count; idx++) {
            YKLabel * model = _extraLabelArray[idx];
            _button = [UIButton buttonWithType:UIButtonTypeCustom];
            [_button setTitle:model.tabName forState:UIControlStateNormal];
            [_button setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
            _button.titleLabel.font = [UIFont systemFontOfSize:10];
            CGSize size = [self sizeWithTitle:model.tabName];
            _button.frame = CGRectMake(w+scaleW, 11, size.width+15, size.height+4);
            _button.layer.cornerRadius = (size.height+4)/2;
            _button.clipsToBounds = YES;
            [_button.layer setBorderWidth:1.0];
            [_button.layer setBorderColor:[UIColor cyanColor].CGColor];
            
            w = _button.frame.origin.x+_button.frame.size.width;
            [self addSubview:_button];
             self.contentSize = CGSizeMake(w, self.frame.size.height);
            
        }
    }
   
    
    
    
}
-(CGSize)sizeWithTitle:(NSString *)text{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    return size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
