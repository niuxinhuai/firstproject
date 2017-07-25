//
//  AppDelegate.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/9.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
@protocol ChouseAliPayDelegate <NSObject>

- (void)alipaydidSuccess;
- (void)ailipaydidFaildWithAliPayFaildIdentifier:(int)identifier;

@end
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (weak  , nonatomic)id<ChouseAliPayDelegate>aliDelegate;
@property (strong, nonatomic) UIWindow *window;


@end

