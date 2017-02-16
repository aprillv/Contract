//
//  MyView.m
//  DrawWall
//
//  Created by gll on 13-1-2.
//  Copyright (c) 2013年 gll. All rights reserved.
//

#import "MyView.h"
#import "SignatureView.h"

@implementation MyView{
    BOOL editabless;
}
//保存线条颜色
static NSMutableArray *colorArray;
//保存被移除的线条颜色
static NSMutableArray *deleColorArray;
//每次触摸结束前经过的点，形成线的点数组
static NSMutableArray *pointArray;
//每次触摸结束后的线数组
static NSMutableArray *lineArray;
//删除的线的数组，方便重做时取出来
static NSMutableArray *deleArray;
//线条宽度的数组
static float lineWidthArray[10]={5.0,10.0,12.0,14.0,16.0,20.0,22.0,24.0,26.0,28.0};
//删除线条时删除的线条宽度储存的数组
static NSMutableArray *deleWidthArray;
//正常存储的线条宽度的数组
static NSMutableArray *WidthArray;
//确定颜色的值，将颜色计数的值存到数组里默认为0，即为绿色
static NSInteger colorCount;
//确定宽度的值，将宽度计数的值存到数组里默认为0，即为10
static NSInteger widthCount;
//保存颜色的数组
static NSMutableArray *colors;
- (id)init
{
    self = [super init];
    if (self) {
     
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化颜色数组，将用到的颜色存储到数组里
        colors=[[NSMutableArray alloc]initWithObjects:[UIColor blackColor],[UIColor greenColor],[UIColor blueColor],[UIColor redColor],[UIColor blackColor],[UIColor whiteColor], nil];
        WidthArray = [[NSMutableArray alloc]init];
        deleWidthArray = [[NSMutableArray alloc]init];
        pointArray=[[NSMutableArray alloc]init];
        lineArray=[[NSMutableArray alloc]init];
        deleArray=[[NSMutableArray alloc]init];
        colorArray=[[NSMutableArray alloc]init];
        deleColorArray=[[NSMutableArray alloc]init];
        //颜色和宽度默认都取当前数组第0位为默认值
        colorCount=0;
        editabless = YES;
        widthCount=0;
        // Initialization code
    }
    return self;
}
//给界面按钮操作时获取tag值作为width的计数。来确定宽度，颜色同理
-(void)setlineWidth:(NSInteger)width{
    widthCount = width;
}
-(void)setLineColor:(NSInteger)color{
    colorCount=color;
}

-(void)setLineArray1:(NSArray *)lineArray1{
    if ( lineArray1 != nil) {
        lineArray = lineArray1;
        [self setNeedsDisplay];
    }
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//uiview默认的drawRect方法，覆盖重写，可在界面上重绘，并将AViewController.xib的文件设置为自定义的MyView
- (void)drawRect:(CGRect)rect
{
//    NSLog(@"sfsdfsdfs %f %f", rect);
    //获取当前上下文，
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 10.0f);
    //线条拐角样式，设置为平滑
    CGContextSetLineJoin(context,kCGLineJoinRound);
    //线条开始样式，设置为平滑
    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextSetLineCap(context, kCGLineJoinRound);
    //查看lineArray数组里是否有线条，有就将之前画的重绘，没有只画当前线条
    if ([lineArray count]>0) {
        
       
        
        //            CGPoint cp = CGPointZero;
        CGFloat cw = 0;
        CGFloat ch = 0;
        if (colorArray == nil || colorArray.count == 0) {
            editabless = NO;
            CGFloat minx = 0;
            CGFloat miny = 0;
            CGFloat maxx = 0;
            CGFloat maxy = 0;
            for (int i=0; i<[lineArray count]; i++) {
                NSArray * array=[NSArray
                                 arrayWithArray:[lineArray objectAtIndex:i]];
                
                if ([array count]>0)
                {
                    
                    for (int j=0; j<[array count]; j++)
                    {
                        CGPoint myEndPoint=CGPointFromString([array objectAtIndex:j]);
                        minx = MIN(minx, myEndPoint.x);
                        miny = MIN(miny, myEndPoint.y);
                        maxx = MAX(maxx, myEndPoint.x);
                        maxy = MAX(maxy, myEndPoint.y);
                    }
                    
                    
                    
                }
                
            }
            cw = (rect.size.width - (maxx - minx)-20)/2;
            ch = (rect.size.height - (maxy - miny)-20)/2;
        }
        
        
        for (int i=0; i<[lineArray count]; i++) {
            NSArray * array=[NSArray
                             arrayWithArray:[lineArray objectAtIndex:i]];
           
        if ([array count]>0)
        {
            CGContextBeginPath(context);
            
            
           
            
            CGPoint myStartPoint=CGPointFromString([array objectAtIndex:0]);
            CGContextMoveToPoint(context, myStartPoint.x + cw, myStartPoint.y + ch);
            
            for (int j=0; j<[array count]-1; j++)
            {
                CGPoint myEndPoint=CGPointFromString([array objectAtIndex:j+1]);
//                NSLog(@"%f -- %f", myEndPoint.x, myEndPoint.y);
                //--------------------------------------------------------
                CGContextAddLineToPoint(context, myEndPoint.x+cw,myEndPoint.y+ch);
            }
//            //获取colorArray数组里的要绘制线条的颜色
//            NSNumber *num=[colorArray objectAtIndex:i];
//            int count=[num intValue];
//            UIColor *lineColor=[colors objectAtIndex:count];
//            //获取WidthArray数组里的要绘制线条的宽度
//            NSNumber *wid=[WidthArray objectAtIndex:i];
//            int widthc=[wid intValue];
//            float width=lineWidthArray[widthc];
            //设置线条的颜色，要取uicolor的CGColor
//            CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
            CGContextSetStrokeColorWithColor(context,[[UIColor blackColor] CGColor]);
            //-------------------------------------------------------
            //设置线条宽度
//            CGContextSetLineWidth(context, width);
             CGContextSetLineWidth(context, 5.0);
            //保存自己画的
            CGContextStrokePath(context);
        }
     }
    }
    //画当前的线
    if ([pointArray count]>0)
    {
        CGContextBeginPath(context);
        CGPoint myStartPoint=CGPointFromString([pointArray objectAtIndex:0]);
        CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
        
        if (pointArray.count > 1) {
            for (int j=0; j<[pointArray count]-1; j++)
            {
                CGPoint myEndPoint=CGPointFromString([pointArray objectAtIndex:j+1]);
                //--------------------------------------------------------
                CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
            }
        }else{
            
            [self addPA:myStartPoint];
            CGContextAddLineToPoint(context, myStartPoint.x,myStartPoint.y);
            
        }
        
        UIColor *lineColor=[colors objectAtIndex:colorCount];
        float width=lineWidthArray[widthCount];
        CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
        //-------------------------------------------------------
        CGContextSetLineWidth(context, width);
//        CGContextFillPath(context);
        CGContextStrokePath(context);
        CGContextFlush(UIGraphicsGetCurrentContext());
    }

     
}

-(UIView *)Signature{
    if (lineArray.count > 0){
//        NSNumber *wid=[WidthArray objectAtIndex:lineArray.count-1];
//        int widthc=[wid intValue];
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
        
        NSMutableArray *na = [[NSMutableArray alloc] init];
       
        CGRect ct = CGRectMake(0, 0, maxx - minx + width*4, maxy - miny + width*4);
        for (NSArray* lineArray1 in lineArray) {
             NSMutableArray *na1 = [[NSMutableArray alloc] init];
            for (NSString* cpline in lineArray1) {
                CGPoint sPoint=CGPointFromString(cpline);
                sPoint.x -= minx - width;
                sPoint.y -= miny - width;
                [na1 addObject: NSStringFromCGPoint(sPoint)];
            }
            [na addObject:na1];
        }
        SignatureView *sign = [[SignatureView alloc] initWithFrame:ct];
        sign.lineArray = na;
        sign.originHeight = ct.size.height;
        sign.originWidth = ct.size.width;
        sign.LineWidth =width;
        CGRect ct2 = sign.frame;
        ct2.origin.x = ct2.origin.y = 0;
        sign.frame = ct2;
        return sign;
    }else{
        return nil;
    }
   
}
//在touch结束前将获取到的点，放到pointArray里
-(void)addPA:(CGPoint)nPoint{
    NSString *sPoint=NSStringFromCGPoint(nPoint);
    [pointArray addObject:sPoint];
}
//在touchend时，将已经绘制的线条的颜色，宽度，线条线路保存到数组里
-(void)addLA{
    NSNumber *wid=[[NSNumber alloc]initWithInteger:widthCount];
    NSNumber *num=[[NSNumber alloc]initWithInteger:colorCount];
    [colorArray addObject:num];
    [WidthArray addObject:wid];
    NSArray *array=[NSArray arrayWithArray:pointArray];
    [lineArray addObject:array];
    pointArray=[[NSMutableArray alloc]init];
}

#pragma mark -
//手指开始触屏开始
static CGPoint MyBeganpoint;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!editabless) {
        return;
    }
    UITouch* touch=[touches anyObject];
    MyBeganpoint=[touch locationInView:self];
    NSString *sPoint=NSStringFromCGPoint(MyBeganpoint);
    [pointArray addObject:sPoint];
    [self setNeedsDisplay];
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!editabless) {
        return;
    }
    
    UITouch* touch=[touches anyObject];
	MyBeganpoint=[touch locationInView:self];
    NSString *sPoint=NSStringFromCGPoint(MyBeganpoint);
    [pointArray addObject:sPoint];
    [self setNeedsDisplay];
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!editabless) {
        return;
    }
     [self addLA];
//    NSArray *array=[NSArray arrayWithArray:pointArray];
//    [lineArray addObject:array];
//    NSNumber *num=[[NSNumber alloc]initWithInt:colorCount];
//    [colorArray addObject:num];
//    pointArray=[[NSMutableArray alloc]init];
//    NSLog(@"touches end");
    
}
//电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"touches Canelled");
}
//撤销，将当前最后一条信息移动到删除数组里，方便恢复时调用
-(void)revocation{
    if ([lineArray count]) {
        [deleArray addObject:[lineArray lastObject]];
        [lineArray removeLastObject];
    }
    if ([colorArray count]) {
        [deleColorArray addObject:[colorArray lastObject]];
        [colorArray removeLastObject];
    }
    if ([WidthArray count]) {
        [deleWidthArray addObject:[WidthArray lastObject]];
        [WidthArray removeLastObject];
    }
    //界面重绘方法
    [self setNeedsDisplay];
}
//将删除线条数组里的信息，移动到当前数组，在主界面重绘
-(void)refrom{
    if ([deleArray count]) {
        [lineArray addObject:[deleArray lastObject]];
        [deleArray removeLastObject];
    }
    if ([deleColorArray count]) {
        [colorArray addObject:[deleColorArray lastObject]];
        [deleColorArray removeLastObject];
    }
    if ([deleWidthArray count]) {
        [WidthArray addObject:[deleWidthArray lastObject]];
        [deleWidthArray removeLastObject];
    }
    [self setNeedsDisplay];
     
}
-(void)clear{
    //移除所有信息并重绘
//    UIView *a = [self Signature];
//    CGRect ct = a.frame;
//    ct.origin.x = ct.origin.y = 50;
//    a.frame = ct;
//    a.backgroundColor = [UIColor grayColor];
    
   [deleArray removeAllObjects];
    [deleColorArray removeAllObjects];
    colorCount=0;
    [colorArray removeAllObjects];
    [lineArray removeAllObjects];
    [pointArray removeAllObjects];
    [deleWidthArray removeAllObjects];
    widthCount=0;
    [WidthArray removeAllObjects];
    
    [self setNeedsDisplay];
//    [self addSubview:a];
    //清屏以后可以重绘，有些问题
    //    deleColorArray=[[NSMutableArray alloc]init];
    //    deleArray=[[NSMutableArray alloc]init];
    //    deleArray =[NSMutableArray arrayWithArray:lineArray];
    //    deleColorArray =[NSMutableArray arrayWithArray:colorArray];
}
@end
