//
//  OwnerViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "OwnerViewController.h"
#import "EmojiLayout.h"
#import "EmojiCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "EmojiModel.h"
#import "UIView+ZYDraggable.h"
@interface OwnerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIPageControl * control;
}
@property (nonatomic, strong)UICollectionView * emojiCollection;
@property (nonatomic, strong)NSMutableArray * emojiMArr;

@end
static NSString * const  cellID = @"CellIdentifiers";

@implementation OwnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _emojiMArr = [NSMutableArray arrayWithArray:[EmojiModel getImageArray]];
    [self.view addSubview:self.emojiCollection];
    
    
    control = [[UIPageControl alloc]init];

    control.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-65);
    control.bounds = CGRectMake(0, 0, 5, 5);
    control.numberOfPages = 6;
    control.currentPageIndicatorTintColor = [UIColor cyanColor];
    control.pageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:control];
    UIImageView * animationImageView = [[UIImageView alloc]init];
    animationImageView.center = CGPointMake(SCREEN_WIDTH/2, 100);
    animationImageView.bounds = CGRectMake(0, 0, 40, 40);
    animationImageView.layer.cornerRadius = 20;
    animationImageView.clipsToBounds = YES;
    animationImageView.userInteractionEnabled = YES;
    animationImageView.contentMode = UIViewContentModeScaleAspectFill;
    animationImageView.image = [UIImage imageNamed:@"lionAnimo"];
    [self.view addSubview:animationImageView];
    [animationImageView makeDraggable];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UICollectionView *)emojiCollection{
    if (!_emojiCollection) {
        EmojiLayout * layout = [[EmojiLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
 CGFloat itemW = (SCREEN_WIDTH-20*8)/7;
        _emojiCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-(100+itemW*4)+20, SCREEN_WIDTH, 100+itemW*4) collectionViewLayout:layout];
        _emojiCollection.pagingEnabled = YES;
        _emojiCollection.contentSize = CGSizeMake(6*SCREEN_WIDTH, 0);
        _emojiCollection.showsHorizontalScrollIndicator = NO;
        _emojiCollection.backgroundColor = [UIColor whiteColor];
        _emojiCollection.delegate = self;
        _emojiCollection.dataSource = self;

        [_emojiCollection registerClass:[EmojiCollectionViewCell class] forCellWithReuseIdentifier:cellID];
      
        
   
    }
    
    return _emojiCollection;
}
//每个item的大小(可以根据indexPath定制)
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(30, 30);
//}
//
////每组距离边界的大小，逆时针，上，左，下，右
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(20, 20, 20, 20);
//}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 230;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EmojiCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    // cell.imageV [EmojiModel getImageArray][indexPath.item];
    NSString * imageName = [NSString stringWithFormat:@"face%003ld",(long)indexPath.item];
    if (indexPath.item >142) {
        return cell;
    }
    cell.imageName = imageName;

  
       return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.item);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentX = scrollView.contentOffset.x;
    if (contentX>SCREEN_WIDTH*5) {
        self.emojiCollection.scrollEnabled = NO;
        
    }else{
        self.emojiCollection.scrollEnabled = YES;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger contentX =(NSInteger) (scrollView.contentOffset.x/SCREEN_WIDTH);
    control.currentPage = contentX;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
