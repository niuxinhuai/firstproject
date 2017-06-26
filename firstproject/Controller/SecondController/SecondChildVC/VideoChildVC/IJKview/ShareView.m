//
//  ShareView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/27.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "ShareView.h"
#import "ButtonView.h"
@interface ShareView()
@property (nonatomic, strong) UIButton * topButton;
@property (nonatomic, strong) UIScrollView * topScrollView;
@property (nonatomic, strong) UIScrollView * bottomScrollView;
@property (nonatomic, assign) CGFloat scrollHeight;
@property (nonatomic, strong) NSArray * topImageArray;
@property (nonatomic, strong) NSArray * topTitleArray;
@property (nonatomic, strong) NSArray * bottomImageArray;
@property (nonatomic, strong) NSArray * bottomTitleArray;
@end
@implementation ShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect{
   
    [self addSubview:self.topButton];
    _scrollHeight = (CGRectGetHeight(self.frame)-60)/2;
    [self addSubview:self.topScrollView];
    [self addSubview:self.bottomScrollView];
    
}
-(UIButton *)topButton{
    if (!_topButton) {
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        _topButton.backgroundColor = [UIColor clearColor];
        [_topButton setTitle:@"分享" forState:UIControlStateNormal];
        UIColor *color = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1];
        [_topButton setTitleColor:color forState:UIControlStateNormal];
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_topButton.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7, 7)];
        CAShapeLayer* _layers = [CAShapeLayer layer];
        _layers.path = path.CGPath;
        _layers.strokeColor = [UIColor clearColor].CGColor;
        _layers.fillColor = [UIColor uiColorFromString:@"#f0f3f8"].CGColor;
        
        [_topButton.layer addSublayer:_layers];
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_topButton.frame)-1, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.6];
        [_topButton addSubview:lineView];
    }
    return _topButton;
}


-(UIScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc]init];
        _topScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topButton.frame), SCREEN_WIDTH, _scrollHeight);
        _topScrollView.backgroundColor = [UIColor uiColorFromString:@"#f0f3f8"];
        _topScrollView.scrollEnabled = YES;
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;

        for (int i=0; i<self.topImageArray.count; i++) {
            ButtonView * topView = [[ButtonView alloc]init];
            if (i>0) {
                topView.frame = CGRectMake(SCREEN_WIDTH/4*i+1, 0, SCREEN_WIDTH/4, _scrollHeight);

            }else{
                topView.frame = CGRectMake(SCREEN_WIDTH/4*i, 0, SCREEN_WIDTH/4, _scrollHeight);

            }
            topView.imageNamed = self.topImageArray[i];
            topView.LabelTitle = self.topTitleArray[i];
            topView.backgroundColor = [UIColor clearColor];
            [_topScrollView addSubview:topView];
            _topScrollView.contentSize = CGSizeMake(topView.frame.origin.x+topView.frame.size.width, 0);
        }
        
    }
    
    return _topScrollView;
}
-(UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc]init];
        _bottomScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topScrollView.frame), SCREEN_WIDTH, _scrollHeight);
        _bottomScrollView.backgroundColor = [UIColor uiColorFromString:@"#f0f3f8"];
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        for (int i=0; i<self.bottomImageArray.count; i++) {
            ButtonView * topView = [[ButtonView alloc]init];
            if (i>0) {
                topView.frame = CGRectMake(SCREEN_WIDTH/4*i+1, 0, SCREEN_WIDTH/4, _scrollHeight);
                
            }else{
                topView.frame = CGRectMake(SCREEN_WIDTH/4*i, 0, SCREEN_WIDTH/4, _scrollHeight);
                
            }
            topView.imageNamed = self.bottomImageArray[i];
            topView.LabelTitle = self.bottomTitleArray[i];
            topView.backgroundColor = [UIColor clearColor];
            [_bottomScrollView addSubview:topView];
           // _topScrollView.contentSize = CGSizeMake(topView.frame.origin.x+topView.frame.size.width, 0);
        }

    }
    
    return _bottomScrollView;
    
}
// 数据源

-(NSArray *)topImageArray{
    if (!_topImageArray) {
        _topImageArray = [NSArray arrayWithObjects:@"room_inshare_timeline_def_pengyouquan",@"room_inshare_timeline_def_weixin",@"room_inshare_timeline_def_kongjian",@"room_inshare_timeline_def_weibo",@"login_ico_facebook",@"login_ico_mobile",@"UMS_twitter_icon", nil];
    }
    return _topImageArray;
}
-(NSArray *)topTitleArray{
    if (!_topTitleArray) {
        _topTitleArray = [NSArray arrayWithObjects:@"朋友圈",@"微信",@"QQ空间",@"微博",@"Facebook",@"个人手机",@"推特", nil];
    }
    return _topTitleArray;
}
-(NSArray *)bottomImageArray{
    if (!_bottomImageArray) {
        _bottomImageArray =[NSArray arrayWithObjects:@"room_inshare_timeline_def_qq",@"room_inshare_timeline_def_yingkouling",@"copy_icon",@"room_bottom_share_record_button", nil ];
    }
    return _bottomImageArray;
}
-(NSArray *)bottomTitleArray{
    if (!_bottomTitleArray) {
        _bottomTitleArray = [NSArray arrayWithObjects:@"QQ",@"萌口令",@"复制链接",@"录屏", nil];
    }
    return _bottomTitleArray;
}







@end
