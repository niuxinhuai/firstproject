//
//  EmojiCollectionViewCell.m
//  firstproject
//
//  Created by 牛新怀 on 2017/6/3.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "EmojiCollectionViewCell.h"

@implementation EmojiCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
     
        
    }
    return self;
}
-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    UIImageView* _imageV = [[UIImageView alloc]initWithFrame:self.contentView.frame];
    _imageV.image =[UIImage imageNamed:_imageName];
    [self.contentView addSubview:_imageV];
}
@end
