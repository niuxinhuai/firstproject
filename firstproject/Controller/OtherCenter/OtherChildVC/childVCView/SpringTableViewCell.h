//
//  SpringTableViewCell.h
//  firstproject
//
//  Created by 牛新怀 on 2017/6/10.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SpringTableViewCellDelegate <NSObject>

-(void)getCellHeightWithHeight:(CGFloat)h;
-(void)changeCellHeigh:(CGFloat)h withselectTag:(NSInteger)tagss withSelect:(BOOL)isSelect;

@end
@interface SpringTableViewCell : UITableViewCell
@property (weak,nonatomic)id<SpringTableViewCellDelegate>delegate;
@property (nonatomic, strong)UITableView * table;
@property (nonatomic, strong)NSString * labelTitle;
@property (nonatomic, strong)UILabel * label;
@property (nonatomic, strong)UILabel * detailLabels;
@property (nonatomic, strong)UIButton * circleButton;
@property (nonatomic, assign)NSInteger tags;

@end
