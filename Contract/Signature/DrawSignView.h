//
//  DrawSignView.h
//  YRF
//
//  Created by jun.wang on 14-5-28.
//  Copyright (c) 2014年 王军. All rights reserved.
//


#import "MyView.h"
#import <UIKit/UIKit.h>

typedef void(^SignCallBackBlock) (UIView*image, BOOL isToAll);
typedef void(^CallBackBlock) ();

@interface DrawSignView : UIView

@property(nonatomic, assign) BOOL showSwitch;
-(void)setShowSwitch2:(BOOL)showSwitch;
-(void)setLineArray:(NSArray *)lineArray;
-(void) setTitle: (NSString *)xtitle;
@property(nonatomic,copy)SignCallBackBlock signCallBackBlock;
@property(nonatomic,copy)CallBackBlock cancelBlock;
@end
