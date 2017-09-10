//
//  PhotoCollectionView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/9/9.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "PhotoBrowserCollectionViewCell.h"
@interface PhotoCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * photoCollection;
@property (nonatomic, strong) NSMutableArray * imageDataSourceArray;// 存储图片数据源
@end
static NSString * const collectionId = @"photoCollectionCellIdentifier";
@implementation PhotoCollectionView

- (instancetype)initWithFrame:(CGRect)frame
                   imageArray:(NSArray *)array
                  selectIndex:(NSInteger)index{
    self  = [super initWithFrame:frame];
    if (self) {
        if (!array || array.count<=0) return nil;
            
        
        self.imageDataSourceArray = [NSMutableArray arrayWithArray:array];
        [self addSubview:self.photoCollection];
        if (index) {
            [self.photoCollection setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0)];
        }else{
            [self.photoCollection setContentOffset:CGPointMake(0, 0) ];
        }
        
    }
    return self;
}


- (UICollectionView *)photoCollection{
    if (!_photoCollection) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        _photoCollection = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _photoCollection.delegate = self;
        _photoCollection.dataSource = self;
        _photoCollection.pagingEnabled = YES;
        _photoCollection.bounces = YES;
        _photoCollection.showsVerticalScrollIndicator = NO;
        _photoCollection.showsHorizontalScrollIndicator = NO;
        _photoCollection.decelerationRate = 0;
        _photoCollection.contentSize = CGSizeMake(SCREEN_WIDTH*self.imageDataSourceArray.count, 0);
        [_photoCollection registerClass:[PhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:collectionId];
    }
    return _photoCollection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageDataSourceArray.count ? self.imageDataSourceArray.count :0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoBrowserCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionId forIndexPath:indexPath];
    
    return cell;
}
- (NSMutableArray *)imageDataSourceArray{
    if (!_imageDataSourceArray) {
        _imageDataSourceArray = [[NSMutableArray alloc]init];
    }
    return _imageDataSourceArray;
}
@end
