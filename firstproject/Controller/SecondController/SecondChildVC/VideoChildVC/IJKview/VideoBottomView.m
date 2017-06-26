//
//  VideoBottomView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/26.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "VideoBottomView.h"
@interface VideoBottomView()
@property (nonatomic, strong)NSArray * imageNamedArray;
@end
@implementation VideoBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect{
    
    CGFloat bottomY = CGRectGetHeight(self.frame)-40;
    CGFloat bottomX = 10.0;
    CGFloat buttonWidth = 30;
    CGFloat w = SCREEN_WIDTH-4*buttonWidth-5*bottomX;
    for (int i =0; i<4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(w+bottomX, bottomY, buttonWidth, buttonWidth);
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        if (self.imageNamedArray[i]) {
            [button setImage:[UIImage imageNamed:self.imageNamedArray[i]] forState:UIControlStateNormal];
        }
        button.layer.cornerRadius = buttonWidth/2;
        button.clipsToBounds = YES;
        button.tag = BottomButtonLeftTag+i;
        [button addTarget:self action:@selector(doOtherThingWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        w = button.frame.origin.x+button.frame.size.width
        ;
    }
    
    
    
}
-(void)doOtherThingWithButton:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectaView:withSelectButtonTag:)]) {
        [self.delegate didSelectaView:self withSelectButtonTag:sender.tag];
    }
    
}
-(NSArray *)imageNamedArray{
    if (!_imageNamedArray) {
        _imageNamedArray = [NSArray arrayWithObjects:@"评论",@"礼物",@"buttonImage",@"关机", nil];
    }
    
    return _imageNamedArray;
}
@end
