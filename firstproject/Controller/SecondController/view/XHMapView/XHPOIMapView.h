//
//  XHPOIMapView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/8/11.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>

@class XHPOIMapView;
@protocol POIMapViewDelegate <NSObject>
@required
- (void)didSelectPOISearchBar:(XHPOIMapView *)view;
- (void)didSelectCancleButton:(XHPOIMapView *)view;
- (void)didSelectSearchBarDidChangeText:(NSString *)searchText;
- (void)didSelectRowWithIndexPath:(NSInteger)row;
@end
@interface XHPOIMapView : UIView
@property (weak, nonatomic)id<POIMapViewDelegate>delegate;
@property (strong, nonatomic)NSArray <AMapPOI *>*allPoiArray;
@end
