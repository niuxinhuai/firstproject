//
//  EmojiLayout.m
//  firstproject
//
//  Created by 牛新怀 on 2017/6/3.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "EmojiLayout.h"
// 重写layout需要重写三个方法
@implementation EmojiLayout
//item的frame
-(void)prepareLayout{
    
    _attributesArr = [[NSMutableArray alloc]init];
    CGFloat itemW = (SCREEN_WIDTH-20*8)/7;
    // 获得item索引
   // NSInteger sections = self.collectionView.numberOfSections;
    //for (NSInteger section =0; section <sections; sections++) {
        // 获取指定section的row个数
        NSInteger rows = [self.collectionView numberOfItemsInSection:0];
        // 遍历计算item的frame
        CGFloat gap = 20;
        CGFloat screenW = SCREEN_WIDTH;
        for (NSInteger row =0; row<rows; row++) {
            CGFloat itemX = (itemW + gap)*(row%7)+gap+screenW*(row/28)+_contentWidth;
            CGFloat itemY = (itemW + gap)*((row/7)%4)+gap-64;
            // 需要将计算好的itemframe 封装成layoutAttributes对象， layout才会有作用
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            // 获取indexPath 对应的cell 的布局属性
            UICollectionViewLayoutAttributes * attr = [self layoutAttributesForItemAtIndexPath:indexPath];
            attr.frame = CGRectMake(itemX, itemY, itemW, itemW);
            [_attributesArr addObject:attr];
            
            
            
        }
        _contentWidth += (rows+27)/28*screenW;
   // }
    
    
    
}
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return YES;
//}
//// 可滑动区域
//-(CGSize)collectionViewContentSize{
//    return CGSizeMake(SCREEN_WIDTH*6, self.collectionView.frame.size.height);
//}
- ( NSArray< UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    // 返回所有应该展示在rect区域deitem的
    //UICollection
    //重用的时候，item重队列中取出
    //通过这个方法得到item的位置
    NSMutableArray * resArr = [[NSMutableArray alloc]init];
    [_attributesArr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [resArr addObject:obj];
        }
        
    }];
    return resArr;
    
}// return an array layout attributes instances for all the views in the given rect



@end
