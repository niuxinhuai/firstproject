//
//  VideoTableViewCell.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "VideoTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIImage+XFCircle.h"
#import "TopVIewScrollView.h"
@interface VideoTableViewCell ()
@property (strong, nonatomic)UIView *bottomLineView;
@property (strong, nonatomic)UIView *topView;
/*
 头部视图控件
 */
@property (strong, nonatomic)UIImageView * heardImageView;
@property (strong, nonatomic)UILabel * nickLabel;
@property (strong, nonatomic)UILabel * anyBodyLockLabel;
@property (strong, nonatomic)TopVIewScrollView * scrollViews;


@property (strong, nonatomic)UIImageView * bigImageView;
@property (strong, nonatomic)UILabel *bgLabel;
@property (strong, nonatomic)UIButton * liveButton;
@end
@implementation VideoTableViewCell

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
-(void)setVideoLives:(YKLives *)videoLives{
    _videoLives = videoLives;
    [self addSubview:self.topView];
    NSURL * url = [NSURL URLWithString:_videoLives.creator.portrait];
    [self.heardImageView sd_setImageWithURL:url];
    self.nickLabel.text = _videoLives.creator.nick;
    self.scrollViews.extraLabelArray = _videoLives.extra.label;
    NSString * lookStr = [NSString stringWithFormat:@"%.f",_videoLives.onlineUsers];
    
    self.anyBodyLockLabel.text = [NSString stringWithFormat:@"%@人在看",lookStr];
    CGSize size = [self sizeWithTitle:self.anyBodyLockLabel.text];
    self.anyBodyLockLabel.frame = CGRectMake(SCREEN_WIDTH-15-size.width, CGRectGetMinY(self.heardImageView.frame), size.width, size.height);
    
    
    
    [self.bigImageView sd_setImageWithURL:url];
    if (_videoLives.name) {
        self.bgLabel.text = _videoLives.name;
        CGSize size = [self sizeWithTitle:self.bgLabel.text];
        self.bgLabel.frame = CGRectMake(CGRectGetMinX(self.heardImageView.frame), CGRectGetHeight(self.bigImageView.frame)-23, size.width, size.height);
        
    }
    [self.bigImageView addSubview:self.liveButton];
    [self addSubview:self.bottomLineView];
    CGFloat height = CGRectGetMaxY(self.bottomLineView.frame);
    if ([self.delegate respondsToSelector:@selector(videoTableViewCellWithCell:withCellHeight:)]) {
        [self.delegate videoTableViewCellWithCell:self withCellHeight:height];
    }

    
    
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.frame =CGRectMake(0, 0, SCREEN_WIDTH, 70);
        _topView.backgroundColor = [UIColor whiteColor];
        
    }
    
    
    return _topView;
}
-(UIImageView *)heardImageView{
    if (!_heardImageView) {
        _heardImageView = [[UIImageView alloc]init];
        _heardImageView.frame = CGRectMake(15, 10, 50, 50);
        _heardImageView.layer.cornerRadius =25.0;
        _heardImageView.clipsToBounds = YES;
        
        [self.topView addSubview:_heardImageView];

    }
    
    return _heardImageView;
}
-(TopVIewScrollView *)scrollViews{
    if (!_scrollViews) {
        _scrollViews = [[TopVIewScrollView alloc]init];
        _scrollViews.frame = CGRectMake(CGRectGetMinX(self.nickLabel.frame), CGRectGetMaxY(self.nickLabel.frame), SCREEN_WIDTH-CGRectGetMinX(self.nickLabel.frame)*2, CGRectGetHeight(self.topView.frame)-CGRectGetMaxY(self.nickLabel.frame));
        [self.topView addSubview:_scrollViews];
    }
    return _scrollViews;
    
}
-(UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]init];
        _nickLabel.frame = CGRectMake(CGRectGetMaxX(self.heardImageView.frame)+10, CGRectGetMinY(self.heardImageView.frame), SCREEN_WIDTH/2, 15);
        _nickLabel.font = [UIFont systemFontOfSize:15];
        _nickLabel.textColor = [UIColor blackColor];
        [self.topView addSubview:_nickLabel];
    }
    
    return _nickLabel;
}
-(UILabel *)anyBodyLockLabel{
    if (!_anyBodyLockLabel) {
        _anyBodyLockLabel = [[UILabel alloc]init];
        _anyBodyLockLabel.textColor = [UIColor colorWithRed:253/255.0 green:209/255.0 blue:50/255.0 alpha:1];
        _anyBodyLockLabel.font = [UIFont systemFontOfSize:15];
        [self.topView addSubview:_anyBodyLockLabel];
    }
    
    return _anyBodyLockLabel;
}

-(UIImageView *)bigImageView
{
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc]init];
        _bigImageView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT/2);
        [self addSubview:_bigImageView];
        
    }
    return _bigImageView;
}

-(UILabel *)bgLabel{
    if (!_bgLabel) {
        _bgLabel = [[UILabel alloc]init];
        _bgLabel.textColor = [UIColor whiteColor];
        _bgLabel.font = [UIFont systemFontOfSize:15];
        [self.bigImageView addSubview:_bgLabel];
    }
    
    return _bgLabel;
}
-(UIButton *)liveButton{
    if (!_liveButton) {
        _liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _liveButton.frame = CGRectMake(SCREEN_WIDTH-70, 12, 60, 18);
        [_liveButton setTitle:@"直播" forState:UIControlStateNormal];
        _liveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_liveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _liveButton.backgroundColor = [[UIColor uiColorFromString:@"#f0f3f8"]colorWithAlphaComponent:0.4];
        _liveButton.layer.cornerRadius = 9.0;
        _liveButton.clipsToBounds = YES;
        [_liveButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_liveButton.layer setBorderWidth:1.0];
    }
    
    return _liveButton;
}
// 底部灰色视图
-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.frame = CGRectMake(0, CGRectGetMaxY(self.bigImageView.frame), SCREEN_WIDTH, 10);
        _bottomLineView.backgroundColor = [UIColor uiColorFromString:@"#f0f3f8"];
        
        
    }
    
    return _bottomLineView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGSize)sizeWithTitle:(NSString *)text{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    return size;
}




@end
