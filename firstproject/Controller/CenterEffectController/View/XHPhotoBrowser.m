//
//  XHPhotoBrowser.m
//  firstproject
//
//  Created by 牛新怀 on 2017/9/3.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "XHPhotoBrowser.h"
@interface XHPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * photoSelectorCollectionView;
@property (nonatomic, strong) NSMutableArray   * selectPictureArray;
@end
static CGFloat flowLayoutItemWidths;
static CGFloat flowLayoutItemHeights;
static CGFloat itemSpacingScale = 10.0;
static NSString* const resultId = @"identfierLayout";
@implementation XHPhotoBrowser


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addSubview:self.photoSelectorCollectionView];
    
    
}

- (UICollectionView *)photoSelectorCollectionView{
    if (!_photoSelectorCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = itemSpacingScale;
        layout.minimumInteritemSpacing = itemSpacingScale;
        flowLayoutItemWidths = (SCREEN_WIDTH- 4*itemSpacingScale)/3;
        layout.itemSize = CGSizeMake(flowLayoutItemWidths, flowLayoutItemWidths);
        _photoSelectorCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _photoSelectorCollectionView.delegate = self;
        _photoSelectorCollectionView.dataSource = self;
        [_photoSelectorCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:resultId];
        _photoSelectorCollectionView.backgroundColor = [UIColor purpleColor];
        
    }
    return _photoSelectorCollectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectPictureArray.count>1 ? self.selectPictureArray.count : 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:resultId forIndexPath:indexPath];
    
    return cell;
    
}
- (NSMutableArray *)selectPictureArray{
    if (!_selectPictureArray) {
        _selectPictureArray = [[NSMutableArray alloc]init];
    }
    return _selectPictureArray;
}

@end
