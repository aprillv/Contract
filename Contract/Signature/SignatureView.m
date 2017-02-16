//
//  SignatureView.m
//  ILPDFKitSample
//
//  Created by April on 11/17/15.
//  Copyright © 2015 Iwe Labs. All rights reserved.
//

#import "SignatureView.h"
#import "PopSignUtil.h"

@implementation SignatureView{
//    CGRect cts;
    CGFloat ratios;
   
    
    
}

@synthesize lineArray, LineWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ratios = 1;
        self.backgroundColor = [UIColor clearColor];
        self.showornot = false;
//        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(toSignautre)];
//        
//        [self addGestureRecognizer:gesture];
    }
    return self;
}

-(void)updateWithZoom:(CGFloat)zoom{
    [super updateWithZoom:zoom];
    if (self.menubtn && self.menubtn.superview) {
        [self.menubtn removeFromSuperview];
        self.menubtn = nil;
        [self addSignautre:self.superview];
    }
    [self setNeedsDisplay];
}
-(void)setLineWidth:(float)LineWidth1{
//    NSLog(@"LineWidth1 %f", LineWidth1);
    if (LineWidth1 > 0) {
        [self.menubtn removeFromSuperview];
        self.menubtn = nil;
    }
    LineWidth = LineWidth1;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self drawInRect:rect withContext:context];
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *theTouch = [touches anyObject];
    if ([theTouch tapCount] == 2) {
        [self toSignautre];
        [self addSignautre:nil];
    }
}

-(void)addSignautre: (UIView *)view{
    if (!self.menubtn && self.LineWidth == 0 ) {
        
        
        
        //    return;
        CGRect ct = self.frame;
        //    ct.origin.y += ct.size.height/2.0;
        ct.origin.x += ct.size.width/2.0;
        
        UIButton *btn = [[UIButton alloc]init];
        self.menubtn =btn;
        
        
        
        NSString * xtitle;
        if ([self.xname hasSuffix:@"bottom1"]) {
            xtitle = @"initialB1";
            btn.frame = CGRectMake(0, 0, 64, 56);
//            ct.origin.x -= ct.size.width/2.0;
            ct.origin.y -= 12;
        }else if([self.xname hasSuffix:@"bottom2"]){
            xtitle = @"initialB2";
            btn.frame = CGRectMake(0, 0, 64, 56);
//            ct.origin.x -= ct.size.width/2.0;
            ct.origin.y -= 12;
        }else if([self.xname hasSuffix:@"bottom3"]
                 || [self.xname isEqualToString:@"p1EBExhibitbp1sellerInitialSign"]
                 || [self.xname hasSuffix:@"Sign3"]){
            xtitle = @"initial";
            btn.frame = CGRectMake(0, 0, 64, 44);
        }else if([self.xname hasSuffix:@"buyer1Sign"]) {
            xtitle = @"signB1";
            btn.frame = CGRectMake(0, 0, 94, 56);
            ct.origin.y -= 12;
        }else if([self.xname hasSuffix:@"buyer2Sign"]) {
            xtitle = @"signB2";
            btn.frame = CGRectMake(0, 0, 94, 56);
            ct.origin.y -= 12;
        }else{
             xtitle = @"signBlack" ;
            btn.frame = CGRectMake(0, 0, 94, 44);
        }
        
        if ([self.xname isEqualToString:@"p1EBExhibitbp1sellerInitialSign"]){
            ct.origin.x -= 40;
        }
        
//        if ([self.xname isEqualToString:@"p8buyer2Sign"]){
//            ct.origin.y += 40;
//        }
        btn.center = ct.origin;
        
        
        [btn setImage:[UIImage imageNamed:xtitle] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popSignature:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popSignature:)];
        tap.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:tap];
//        if ([self.xname isEqualToString:@"p8buyer2Sign"]){
//            NSLog(@"))))))))%@ %@ %@", self, btn, view);
//            btn.layer.borderColor = [UIColor blackColor].CGColor;
//            btn.layer.borderWidth = 5.0f;
//        }
//        [view insertSubview:btn atIndex:0];
        [view insertSubview:btn aboveSubview:self];
    }
    
}

-(void)sssss{
    if (self.lineArray || self.lineArray.count > 0) {
        [self.menubtn removeFromSuperview];
    }
    
}

-(CGRect)getOriginFrame{
    
    float width=5;
    
    CGFloat maxx = 0;
    CGFloat maxy = 0;
    CGFloat minx = self.frame.size.width;
    CGFloat miny = self.frame.size.height;
    for (NSArray* lineArray1 in lineArray) {
        for (NSString* cpline in lineArray1) {
            CGPoint sPoint=CGPointFromString(cpline);
            minx = MIN(sPoint.x, minx);
            miny = MIN(sPoint.y, miny);
            maxx = MAX(sPoint.x, maxx);
            maxy = MAX(sPoint.y, maxy);
        }
    }
    
//    NSMutableArray *na = [[NSMutableArray alloc] init];
    
    CGRect ct = CGRectMake(0, 0, maxx - minx + width*4+4, maxy - miny + width*4+4);
    return ct;
}

-(NSMutableArray*)getNewOriginLine: (NSMutableArray *)lineArray3{
    
    float width=5;
    
    CGFloat maxx = 0;
    CGFloat maxy = 0;
    CGFloat minx = self.frame.size.width;
    CGFloat miny = self.frame.size.height;
    for (NSArray* lineArray1 in lineArray3) {
        for (NSString* cpline in lineArray1) {
            CGPoint sPoint=CGPointFromString(cpline);
            minx = MIN(sPoint.x, minx);
            miny = MIN(sPoint.y, miny);
            maxx = MAX(sPoint.x, maxx);
            maxy = MAX(sPoint.y, maxy);
        }
    }
    
    NSMutableArray *na = [[NSMutableArray alloc] init];
    
//    CGRect ct = CGRectMake(0, 0, maxx - minx + width*4, maxy - miny + width*4);
    for (NSArray* lineArray1 in lineArray3) {
        NSMutableArray *na1 = [[NSMutableArray alloc] init];
        for (NSString* cpline in lineArray1) {
            CGPoint sPoint=CGPointFromString(cpline);
            sPoint.x -= minx - width;
            sPoint.y -= miny - width;
            [na1 addObject: NSStringFromCGPoint(sPoint)];
        }
        [na addObject:na1];
    }
    return na;
}

-(void)toSignautre{
//    NSLog(@"%@ -- %@", self.superview, self);
//    if (self.menubtn){
//        if (self.menubtn.superview == nil) {
//            //        [self becomeFirstResponder];
//            [self.superview addSubview:self.menubtn];
//            [self performSelector:@selector(sssss) withObject:nil afterDelay:6];
//        }else{
//            [self popSignature:nil];
//        }
//    }
    return;
    
    NSString *xtitle;
    if ([self.xname hasSuffix:@"DateSign"]) {
        xtitle = @"Sign Date";
    }else{
        if ([self.xname isEqualToString:@"p1EBExhibitbp1sellerInitialSign"]) {
            xtitle = @"Initial";
        }else if([self.xname isEqualToString:@"BYSign"] || [self.xname isEqualToString:@"NameSign"] || [self.xname isEqualToString:@"TitleSign"] || [self.xname isEqualToString:@"AddendumASeller3Sign"]) {
            xtitle = @"Sign";
        }else {
            xtitle = [self.xname hasSuffix:@"Sign"]? @"Signature" : @"Initial";
        }
        
    }
    
//    xtitle = @"Sign Date";
    
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:xtitle  action:@selector(popSignature:)];
    UIMenuController *menuCont = [UIMenuController sharedMenuController];
    
    CGRect ct = self.frame;
    ct.origin.y += ct.size.height/2.0;
    
    [menuCont setTargetRect:ct inView:self.superview];
    menuCont.arrowDirection = UIMenuControllerArrowDown;
    
    menuCont.menuItems = [NSArray arrayWithObject:menuItem];
    [menuCont setMenuVisible:YES animated:YES];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {}

- (BOOL)canBecomeFirstResponder { return YES; }

- (void)popSignature:(id)sender {

    if (!self.menubtn){
        return;
    }
        NSString *xtitle = @"";
        if ([self.xname containsString:@"bottom"] || [self.xname isEqualToString:@"p1EBExhibitbp1sellerInitialSign"]) {
            xtitle = @"Please print your initial here";
        }else{
            xtitle = @"Please signature here";
        }
        
        
        [PopSignUtil getSignWithVC:nil withOk:^(UIView *image, BOOL isToAll) {
            
            SignatureView *sv = (SignatureView *)image;
            
            if (sv.lineArray.count!=0) {
               [self.menubtn removeFromSuperview];
            }
            
            
            CGRect ct = self.frame;
            self.frame = sv.frame;
            self.frame = ct;
            self.lineArray = sv.lineArray;
//            NSLog(@"=== %f %f", sv.originHeight, sv.originWidth);
            self.originHeight = sv.originHeight;
            self.originWidth = sv.originWidth;
            self.LineWidth = sv.LineWidth;
            
//            NSLog(@"self.xname %@", self.xname);
            if ([self.xname hasSuffix:@"buyer1Sign"] || [self.xname hasSuffix:@"buyer2Sign"] || [self.xname hasSuffix:@"seller1Sign"] || [self.xname hasSuffix:@"buyer1DateSign"] || [self.xname hasSuffix:@"buyer2DateSign"]|| [self.xname hasSuffix:@"seller1DateSign"] ) {
                int len = 10;
                if ([self.xname containsString:@"DateSign"]) {
                    len = 14;
                    
                }
                for (SignatureView *other in self.pdfViewsssss.pdfWidgetAnnotationViews) {
//                    NSLog(@"self.xname %@", self.xname);
                    if (other == self) {
                        continue;
                    }
                    if ([other isKindOfClass:[SignatureView class]]
                        && [other.xname hasSuffix: [self.xname substringFromIndex:(self.xname.length - len)] ] && other.menubtn){
                        if (other.LineWidth > 0) {
                            continue;
                        }
                        CGRect ct = other.frame;
                        other.frame = sv.frame;
                        //                        other.frame = ct;
                        other.lineArray = sv.lineArray;
                        other.originHeight =sv.originHeight;
                        other.originWidth = sv.originWidth;
                        if (isToAll) {
                            
                             other.LineWidth = sv.LineWidth;
                            if (sv.lineArray.count!=0) {
                                [other.menubtn removeFromSuperview];
                                other.menubtn = nil;
                            }
                        }else{
//                            other.originWidth = 0;
                             other.LineWidth = 0;
                        }
                        
                        
//                        other.LineWidth = sv.LineWidth;
                        other.frame = ct;
                        
                        
                    }
                }
                for (SignatureView *other in self.pdfViewsssss.addedCCCCAnnotationViews) {
                    if (other == self ) {
                        continue;
                    }
                    if ([other isKindOfClass:[SignatureView class]]
                        && [other.xname hasSuffix: [self.xname substringFromIndex:(self.xname.length - len)] ] && other.menubtn){
                        if (other.LineWidth > 0) {
                            continue;
                        }
                        CGRect ct = other.frame;
                        other.frame = sv.frame;
                        //                        other.frame = ct;
                        other.lineArray = sv.lineArray;
                        other.originHeight =sv.originHeight;
                        other.originWidth = sv.originWidth;
                        if (isToAll) {
                            other.LineWidth = sv.LineWidth;
                            if (sv.lineArray.count!=0) {
                                [other.menubtn removeFromSuperview];
                                other.menubtn = nil;
                            }
                        }else{
                            other.LineWidth = 0;
                        }
                        other.frame = ct;
                    }
                }
                
            }else{
                BOOL isBuyer1Initial = [self.xname hasSuffix:@"bottom1"] || [self.xname hasSuffix:@"Sign3"] || [self.xname isEqualToString:@"p1EBExhibitbp1sellerInitialSign"];
                
                for (SignatureView *other in self.pdfViewsssss.pdfWidgetAnnotationViews) {
                    if (other == self) {
                        continue;
                    }
                    if ([other isKindOfClass:[SignatureView class]]){
                        if (other.LineWidth > 0) {
                            continue;
                        }
                        if ([other.xname hasSuffix: [self.xname substringFromIndex:(self.xname.length - 7)] ] || (isBuyer1Initial && ([other.xname hasSuffix:@"Sign3"] || [other.xname hasSuffix:@"bottom1"] || [other.xname isEqualToString:@"p1EBExhibitbp1sellerInitialSign"]))){
                            
                            CGRect ct = other.frame;
                            other.frame = sv.frame;
                            //                        other.frame = ct;
                            other.lineArray = sv.lineArray;
                            other.originHeight =sv.originHeight;
                            other.originWidth = sv.originWidth;
                            if (isToAll && ![other.xname isEqualToString:@"p1EBExhibitbp1sellerInitialSign"]) {
                                other.LineWidth = sv.LineWidth;
                                if (sv.lineArray.count!=0) {
                                    [other.menubtn removeFromSuperview];
                                    other.menubtn = nil;
                                }
                                
                            }else{
                                other.LineWidth = 0;
                            }
                            other.frame = ct;

                        }
                        
                    }
                }
            }
            
            [PopSignUtil closePop];
        } withCancel:^{
            [PopSignUtil closePop];
        } showAll:(![self.xname isEqualToString:@"p1EBExhibitbp1sellerInitialSign"]) withTitle:xtitle withLineArray:self.lineArray];
//    }
    
    
}



-(void)drawInRect:(CGRect)rect withContext:(CGContextRef )context{
    if (self.originHeight > 0) {
        //        ratios = MIN(frame.size.width/self.frame.size.width, frame.size.height/self.frame.size.height);
//        if ([self.xname isEqualToString:@"p1EBExhibitbp1sellerInitialSign"]){
//            NSLog(@"p1EBExhibitbp1sellerInitialSign");
//        }
        ratios = MIN(rect.size.height/self.originHeight, rect.size.width/self.originWidth);
//        NSLog(@"%f == %f", rect.size.height/self.originHeight, rect.size.width/self.originWidth);
    }else{
        ratios = 1;
    }
    
    CGFloat xh =  rect.size.width / ratios - self.originWidth;
    CGFloat yh =  rect.size.height / ratios - self.originHeight ;
    xh = xh/2;
    yh = yh/2;
    
    
    CGFloat prex = 2;
//    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, LineWidth*ratios);
    //线条拐角样式，设置为平滑
    CGContextSetLineJoin(context,kCGLineJoinRound);
    //线条开始样式，设置为平滑
    CGContextSetLineCap(context, kCGLineCapRound);
    //    CGContextSetLineCap(context, kCGLineJoinRound);
    //查看lineArray数组里是否有线条，有就将之前画的重绘，没有只画当前线条
    if ([lineArray count]>0) {
        //        self.backgroundColor = [UIColor redColor];
        for (int i=0; i<[lineArray count]; i++) {
            NSArray * array=[NSArray
                             arrayWithArray:[lineArray objectAtIndex:i]];
            
            if ([array count]>0)
            {
                CGContextBeginPath(context);
                CGPoint myStartPoint=CGPointFromString([array objectAtIndex:0]);
                CGContextMoveToPoint(context, (myStartPoint.x +xh)*ratios+prex, (myStartPoint.y+yh)*ratios);
                
                
                if (array.count == 1) {
                    CGContextAddLineToPoint(context,(myStartPoint.x +xh)*ratios+prex, (myStartPoint.y+yh)*ratios);
                }else{
                    
                    for (int j=0; j<[array count]-1; j++)
                    {
                        CGPoint myEndPoint=CGPointFromString([array objectAtIndex:j+1]);
                        //--------------------------------------------------------
                        CGContextAddLineToPoint(context, (myEndPoint.x + xh) *ratios+prex , (myEndPoint.y+ yh)*ratios );
                    }
                }
                //获取colorArray数组里的要绘制线条的颜色
                
                UIColor *lineColor=[UIColor blackColor];
                //获取WidthArray数组里的要绘制线条的宽度
                
                //设置线条的颜色，要取uicolor的CGColor
                CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
                //-------------------------------------------------------
                //设置线条宽度
                CGContextSetLineWidth(context, LineWidth*ratios);
                //保存自己画的
                CGContextStrokePath(context);
            }
        }
    }
    
    
}

-(void)drawInRect2:(CGRect)rect withContext:(CGContextRef )context{
    if (self.originHeight > 0) {
        //        ratios = MIN(frame.size.width/self.frame.size.width, frame.size.height/self.frame.size.height);
        ratios = rect.size.height/self.originHeight;
    }else{
        ratios = 1;
    }
    
    
    CGFloat prex = 2;
    //    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, LineWidth*ratios);
    //线条拐角样式，设置为平滑
    CGContextSetLineJoin(context,kCGLineJoinRound);
    //线条开始样式，设置为平滑
    CGContextSetLineCap(context, kCGLineCapRound);
    //    CGContextSetLineCap(context, kCGLineJoinRound);
    //查看lineArray数组里是否有线条，有就将之前画的重绘，没有只画当前线条
    if ([lineArray count]>0) {
        //        self.backgroundColor = [UIColor redColor];
        for (int i=0; i<[lineArray count]; i++) {
            NSArray * array=[NSArray
                             arrayWithArray:[lineArray objectAtIndex:i]];
            
            if ([array count]>0)
            {
                CGContextBeginPath(context);
                CGPoint myStartPoint=CGPointFromString([array objectAtIndex:0]);
                CGContextMoveToPoint(context, myStartPoint.x*ratios+prex + rect.origin.x, myStartPoint.y*ratios +rect.origin.y);
                
                for (int j=0; j<[array count]-1; j++)
                {
                    CGPoint myEndPoint=CGPointFromString([array objectAtIndex:j+1]);
                    //--------------------------------------------------------
                    CGContextAddLineToPoint(context, myEndPoint.x*ratios+prex+ rect.origin.x,myEndPoint.y*ratios+ rect.origin.y);
                }
                //获取colorArray数组里的要绘制线条的颜色
                
                UIColor *lineColor=[UIColor blackColor];
                //获取WidthArray数组里的要绘制线条的宽度
                
                //设置线条的颜色，要取uicolor的CGColor
                CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
                //-------------------------------------------------------
                //设置线条宽度
                CGContextSetLineWidth(context, LineWidth*ratios);
                //保存自己画的
                CGContextStrokePath(context);
            }
        }
    }
    
    
}

- (UIImage *) imageWithView
{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}



@end
