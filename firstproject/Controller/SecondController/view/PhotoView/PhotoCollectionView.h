//
//  PhotoCollectionView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/9/9.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                   imageArray:(NSArray *)array
                  selectIndex:(NSInteger)index;
@end
