//
//  POICustomTableViewCell.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/14.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "POICustomTableViewCell.h"
#import <UIImageView+WebCache.h>
@interface POICustomTableViewCell()
@property (strong, nonatomic) UIImageView * leftImageView;
@property (strong, nonatomic) UILabel * nameLabel;
@property (strong, nonatomic) UILabel * addressLabel;
@property (strong, nonatomic) NSArray * leftImageArray;
@end
static CGFloat nameLabelFont = 15.0;
static CGFloat addressLabelFont = 13.0;
@implementation POICustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPois:(AMapPOI *)pois{
    _pois = pois;
    [self initWithView];
    
}
- (void)initWithView{
    [self addSubview:self.leftImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.addressLabel];
    [self initWithCustomFrame];
}

- (void)initWithCustomFrame{
    self.nameLabel.text = _pois.name;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",_pois.city,_pois.address];
    NSLog(@"%@",_pois.type);

    NSArray * array = [_pois.type componentsSeparatedByString:@";"];
    if ([array containsObject:@"餐饮服务"]) {
        NSLog(@"234");
        self.leftImageView.image = [UIImage imageNamed:self.leftImageArray[0]];
    }else if ([array containsObject:@"生活服务"]){
        self.leftImageView.image = [UIImage imageNamed:self.leftImageArray[2]];

    }else if ([array containsObject:@"交通服务"]){
        self.leftImageView.image = [UIImage imageNamed:self.leftImageArray[3]];

    }else if ([array containsObject:@"住宿服务"]){
        self.leftImageView.image = [UIImage imageNamed:self.leftImageArray[1]];

    }
    [self .leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(@(-130));
        
        make.width.height.mas_equalTo(@(40*OffHeight));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10*OffHeight);
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(10);
        make.width.mas_equalTo(@(SCREEN_WIDTH-100*OffWidth));
        make.height.mas_equalTo(@(20*OffHeight));
        
        
    }];
    

    
    NSArray * imageArray = _pois.images;
    if (imageArray.count !=0) {
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.width.mas_equalTo(self.nameLabel.mas_width);
            make.height.mas_equalTo(@(15*OffHeight));
            
        }];
        for (int idx=0; idx<imageArray.count; idx++) {
            AMapImage * poiImage = imageArray[idx];
            UIImageView * imageV = [[UIImageView alloc]init];
             [self addSubview:imageV];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.leftImageView.mas_right).offset(10+(40*OffHeight+10)*idx);
                make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(10);
                make.width.height.mas_equalTo(@(40*OffHeight));
                make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
            }];
            

            [imageV sd_setImageWithURL:[NSURL URLWithString:poiImage.url]];

           
        }
    }else{
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.width.mas_equalTo(self.nameLabel.mas_width);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
            
        }];
    }  
}


- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init];
        _leftImageView.backgroundColor = [UIColor cyanColor];
        _leftImageView.layer.cornerRadius = 20*OffHeight;
        _leftImageView.clipsToBounds = YES;
    }
    return _leftImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:nameLabelFont*OffHeight];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
    
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = [UIFont systemFontOfSize:addressLabelFont*OffHeight];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
    
}
- (NSArray *)leftImageArray{
    if (!_leftImageArray) {
        _leftImageArray = @[@"XHEatting",@"XHHotel",@"XHLife",@"XHBus"];
    }
    return _leftImageArray;
}

@end
