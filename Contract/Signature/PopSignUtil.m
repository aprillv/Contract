//
//  PopSignUtil.m
//  YRF
//
//  Created by jun.wang on 14-5-28.
//  Copyright (c) 2014年 王军. All rights reserved.
//

#import "PopSignUtil.h"
//#import "ConformView.h"


static PopSignUtil *popSignUtil = nil;

@implementation PopSignUtil{
    UIButton *okBtn;
    UIButton *cancelBtn;
    //遮罩层
    UIView *zhezhaoView;
}


//取得单例实例(线程安全写法)
+(id)shareRestance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popSignUtil = [[PopSignUtil alloc]init];
    });
    return popSignUtil;
}


/** 构造函数 */
-(id)init{
    self = [super init];
    if (self) {
        //遮罩层
        zhezhaoView = [[UIView alloc]init];
        zhezhaoView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    return self;
}

//定制弹出框。模态对话框。
//+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
//          withCancel:(CallBackBlock)callBackBlock showAll:(BOOL) show withTitle: (NSString *)title{
//    PopSignUtil *p = [PopSignUtil shareRestance];
//    [p setPopWithVC:VC withOk:signCallBackBlock withCancel:callBackBlock showAll:show title:title];
//}

+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
          withCancel:(CallBackBlock)callBackBlock showAll:(BOOL) show withTitle: (NSString *)title withLineArray:(NSArray*)na{
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p setPopWithVC:VC withOk:signCallBackBlock withCancel:callBackBlock showAll:show title:title withLineArray: na];
}


+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
          withCancel:(CallBackBlock)callBackBlock title:(NSString *) title{
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p setPopWithVC:VC withOk:signCallBackBlock withCancel:callBackBlock showAll:NO title:title withLineArray: nil];
}



/** 设定 */
-(void)setPopWithVC:(UIViewController *)VCrrr withOk:(SignCallBackBlock)signCallBackBlock
         withCancel:(CallBackBlock)cancelBlock showAll:(BOOL) show{
    [self setPopWithVC:VCrrr withOk:signCallBackBlock withCancel:cancelBlock showAll:show title:@"" withLineArray: nil];
}
-(void)setPopWithVC:(UIViewController *)VCrrr withOk:(SignCallBackBlock)signCallBackBlock
         withCancel:(CallBackBlock)cancelBlock showAll:(BOOL) show title:(NSString *) title withLineArray:(NSArray*)na{

    if (!zhezhaoView) {
        zhezhaoView = [[UIView alloc]init];
        zhezhaoView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
//        zhezhaoView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }else{
        for (UIView *tmp in zhezhaoView.subviews) {
            [tmp removeFromSuperview];
        }
    }
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController.view addSubview:zhezhaoView];
    CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
//    NSLog(@"%@", appDelegate.window.rootViewController.view);
    zhezhaoView.frame = CGRectMake(screenSize.height, 0, screenSize.height, screenSize.width);

    DrawSignView *conformView = [[DrawSignView alloc]init];
     conformView.showSwitch = show;
    [conformView setLineArray:na];
    if (show) {
        if ([title hasPrefix:@"p1T"]) {
            [conformView setShowSwitch2:show];
        }
    }
    
   
    if (![title isEqualToString:@""]) {
        [conformView setTitle: title];
    }
//    [conformView setConformMsg:@"XXX" okTitle:@"确定" cancelTitle:@"取消"];
//    conformView.yesB = yesB;
//    conformView.noB = noB;
    conformView.cancelBlock = cancelBlock;
//    [cancelBlock release];
    conformView.signCallBackBlock  = signCallBackBlock;
//    [signCallBackBlock release];

    CGRect appFrame = appDelegate.window.rootViewController.view.frame;
//    CGFloat v_x = (screenSize.height-conformView.frame.size.height)/2.0;
//    CGFloat v_y = (appFrame.size.height-conformView.frame.size.width)/2.0;
    CGFloat h = MIN(appFrame.size.width, appFrame.size.height);
//    CGFloat w = MAX(appFrame.size.width, appFrame.size.height);
//    if (appFrame.size.width == h) {
//        conformView.frame = CGRectMake( 10, v_y, h-20, conformView.frame.size.width);
//    }else{
//        conformView.frame = CGRectMake( (w-h)/2, v_y, h-20,conformView.frame.size.width);
//    }
    conformView.frame = CGRectMake( 0, 0, h-20, conformView.frame.size.width-110);
    conformView.center = zhezhaoView.center;
    [zhezhaoView addSubview:conformView];
//    [conformView release];
    conformView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    zhezhaoView.autoresizesSubviews = YES;
    zhezhaoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    zhezhaoView.frame = appFrame;
    conformView.center = zhezhaoView.center;
    [UIView commitAnimations];
}



/** 关闭弹出框 */
+(void)closePop{
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p closePop];
}


/** 关闭弹出框 */
-(void)closePop{
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
    [CATransaction begin];
    [UIView animateWithDuration:0.25f animations:^{
        zhezhaoView.frame = CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height);
    } completion:^(BOOL finished) {
        //都关闭啊都关闭
        [zhezhaoView removeFromSuperview];
//        SAFETY_RELEASE(zhezhaoView);
    }];
    [CATransaction commit];
}




@end
