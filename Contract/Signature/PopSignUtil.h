//
//  PopSignUtil.h
//  YRF
//
//  Created by jun.wang on 14-5-28.
//  Copyright (c) 2014年 王军. All rights reserved.
//


#import "DrawSignView.h"



@interface PopSignUtil : UIView
@property(nonatomic,copy)CallBackBlock noB;

+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
          withCancel:(CallBackBlock)callBackBlock showAll:(BOOL) show withTitle: (NSString *)title withLineArray:(NSArray*)na;

+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
          withCancel:(CallBackBlock)callBackBlock title:(NSString *) title;
+(void)closePop;
@end
