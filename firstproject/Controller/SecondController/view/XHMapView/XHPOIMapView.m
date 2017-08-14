//
//  XHPOIMapView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/11.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "XHPOIMapView.h"
#import "POICustomTableViewCell.h"
@interface XHPOIMapView()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CGFloat cellHeight;
}
@property (strong, nonatomic) UISearchBar * poiSearchBar;
@property (strong, nonatomic) UITableView * poiTableView;
@end
@implementation XHPOIMapView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    [self roundView];

    [self initWithView];
   
}



- (void)roundView{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(18*OffWidth, 18*OffHeight)];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
   layer.fillColor = [[UIColor clearColor] colorWithAlphaComponent:0.7].CGColor;
    [self.layer addSublayer:layer];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint  point = [touches.anyObject locationInView:self];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)initWithView{
    [self addSubview:self.poiSearchBar];
   // self.poiTableView.backgroundColor = [UIColor clearColor];
    
    
    [self initWithCustomFrame];
}
- (void)initWithCustomFrame{
    [self.poiSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(@10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(@40);
        
        
    }];
    
    
}

-(UISearchBar *)poiSearchBar{
    if (!_poiSearchBar) {
        _poiSearchBar = [[UISearchBar alloc]init];
        _poiSearchBar.backgroundImage = [[UIImage alloc]init];
        _poiSearchBar.barTintColor = [UIColor uiColorFromString:@"#f0f3f8"];
        _poiSearchBar.placeholder = @"请输入检索信息";
        _poiSearchBar.delegate = self;
        _poiSearchBar.barStyle = UIBarStyleDefault;
        _poiSearchBar.tintColor = [UIColor redColor];
        [_poiSearchBar setImage:[UIImage imageNamed:@"search_Icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        // 设置圆角和边框颜色
        UITextField * searchF = [_poiSearchBar valueForKey:@"searchField"];// KVO获取私有变量
        if (searchF) {
            [searchF setBackgroundColor:[UIColor  uiColorFromString:@"#f0f3f8"]];
            [searchF setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];//KVC
            searchF.returnKeyType = UIReturnKeySearch;
            searchF.layer.cornerRadius = 5;
            searchF.layer.borderWidth = 1;
            searchF.layer.borderColor = [UIColor redColor].CGColor;
            searchF.layer.masksToBounds = YES;
            [searchF setTintColor:[UIColor uiColorFromString:@"#1997eb"]];
            
        }
    }
    return _poiSearchBar;
    
}

- (UITableView *)poiTableView
{
    if (!_poiTableView) {
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        effectView.frame = CGRectMake(0, 50, SCREEN_WIDTH, self.height-60);
        [self addSubview:effectView];
        
        
        _poiTableView = [[UITableView alloc]initWithFrame:effectView.bounds style:UITableViewStylePlain];
        //_poiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _poiTableView.dataSource = self;
        _poiTableView.delegate = self;
        _poiTableView.backgroundColor = [UIColor clearColor];
        _poiTableView.estimatedRowHeight = 50;
        _poiTableView.rowHeight = UITableViewAutomaticDimension;
        [effectView.contentView addSubview:_poiTableView];
    }
    return _poiTableView;
}

-(void)searBarText:(UISearchBar*)searchBar{
    searchBar.showsCancelButton = YES;
    for (UIView * view in [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[NSClassFromString(@"UINavigationButton")class]]) {
            UIButton * cancle = (UIButton *)view;
            cancle.hidden = NO;
            [cancle setTitle:@"取消" forState:UIControlStateNormal];
            [cancle setTitleColor:[UIColor uiColorFromString:@"#f0f3f8"] forState:UIControlStateNormal];
            cancle.enabled = YES;//系统默认为NO.为了达到没有输入文字直接点击取消可以返回之前的界面。而不是第一次点击取消会获取焦点走searchBarTextDidBeginEditing方法 。需要在找到取消按钮的时候设置为YES
            cancle.titleLabel.font = [UIFont systemFontOfSize:15];
            [cancle addTarget:self action:@selector(cancleButton:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    
    
}
- (void)cancleButton:(UIButton *)sender{
    //点击取消按钮
    
    sender.hidden = YES;
    self.poiSearchBar.showsCancelButton = NO;
    self.poiSearchBar.text = @"";
    [self.poiSearchBar updateConstraints];
    if ([self.delegate respondsToSelector:@selector(didSelectCancleButton:)]) {
        [self.delegate didSelectCancleButton:self];
    }
}

// 改变SearchBar取消按钮的字体
- (void)fm_setCancelButtonTitle:(NSString *)title {
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:title];
    
}
//改变SearchBarText字体颜色
- (void)fm_setTextColor:(UIColor *)textColor {
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:textColor];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"123");
    [self searBarText:self.poiSearchBar];
   // [self fm_setTextColor:[UIColor uiColorFromString:@"#1997eb"]];
    if ([self.delegate respondsToSelector:@selector(didSelectPOISearchBar:)]) {
        [self.delegate didSelectPOISearchBar:self];
    }
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([self.delegate respondsToSelector:@selector(didSelectSearchBarDidChangeText:)]) {
        [self.delegate didSelectSearchBarDidChangeText:searchText];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allPoiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID =@"customIdentifier";
    POICustomTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[POICustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //删除cell的所有子视图
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.pois = _allPoiArray[indexPath.row];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectRowWithIndexPath:)]) {
        [self.delegate didSelectRowWithIndexPath:indexPath.row];
    }
}

- (void)setAllPoiArray:(NSArray*)allPoiArray{
    _allPoiArray = allPoiArray;
    if (_allPoiArray.count ==0) {
        return;
    }
    [self.poiTableView reloadData];
}

@end
