//
//  DrawSignView.m
//  YRF
//
//  Created by jun.wang on 14-5-28.
//  Copyright (c) 2014年 王军. All rights reserved.
//
/**
 本界面
 
 */

#import "DrawSignView.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define SYSTEMFONT(x) [UIFont systemFontOfSize:(x)]

@interface DrawSignView ()
@property (strong,nonatomic)  MyView *drawView;
@property (assign,nonatomic)  BOOL buttonHidden;
@property (assign,nonatomic)  BOOL widthHidden;

@end


//保存线条颜色
static NSMutableArray *colors;


@implementation DrawSignView{
    UIButton *redoBtn;//撤销
    UIButton *undoBtn;//恢复
    UIButton *clearBtn;//清空
    UIButton *colorBtn;//颜色
    UIButton *screenBtn;//截屏
    UIButton *widthBtn;//高度
    UIButton *okBtn;//确定并截图返回
    UIButton *cancelBtn;//取消

    UISlider *penBoldSlider;
    
    UISwitch *toAllSwitch;
    
    UILabel *sliderLbl;
    
    UILabel *contentLbl;

//    MyView *drawView;//画图的界面，宽高3:1

}

@synthesize signCallBackBlock,cancelBlock;






- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

- (void)createView
{
    CGFloat btn_x = 10;
    CGFloat btn_y = 100;
    CGFloat btn_w = 80;
    CGFloat btn_h = 40;
    CGFloat btn_mid = 5;



    //self
    self.frame = CGRectMake(0, 0, 500, 1000);
//       self.backgroundColor = [UIColor gr];
    CALayer *layer = self.layer;
    [layer setCornerRadius:5.0];
//    layer.borderColor = [[UIColor whiteColor] CGColor];
//    layer.borderWidth = 1;
//     self.backgroundColor = [UIColor colorWithRed:59./255. green:73./255. blue:82./255. alpha:1];
//    layer.backgroundColor = [UIColor colorWithRed:59./255. green:73./255. blue:82./255. alpha:1].CGColor;
    self.backgroundColor = [UIColor colorWithRed: 35/255.0 green: 174/255.0 blue: 235/255.0 alpha: 1];

    //contentLbl
    contentLbl = [[UILabel alloc]init];
    contentLbl.text = @"Please print your initial here";
    contentLbl.textAlignment = NSTextAlignmentLeft;
    contentLbl.textColor = [UIColor whiteColor];
    contentLbl.frame = CGRectMake(10, 15, 500, 40);
    contentLbl.font = [UIFont fontWithName:@"Futura" size:25];
    contentLbl.backgroundColor = [UIColor clearColor];
    [self addSubview:contentLbl];
//    [contentLbl release];


    //btns
//    redoBtn = [[UIButton alloc]init];
//    [self renderBtn:redoBtn];
//    [redoBtn setTitle:@"Undo" forState:UIControlStateNormal];
//    redoBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
//    [self addSubview:redoBtn];
//    [redoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    //undoBtn
//    undoBtn = [[UIButton alloc]init];
//    [self renderBtn:undoBtn];
//    [undoBtn setTitle:@"Recover" forState:UIControlStateNormal];
//    undoBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
//    [self addSubview:undoBtn];
//    [undoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    //clearBtn
    clearBtn = [[UIButton alloc]init];
    [self renderBtn:clearBtn];
    
    [clearBtn setTitle:@"Clear" forState:UIControlStateNormal];
    clearBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self addSubview:clearBtn];
     [clearBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    //okBtn
    okBtn = [[UIButton alloc]init];
    [self renderBtn:okBtn];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    okBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self addSubview:okBtn];
    [okBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    //cancelBtn
    cancelBtn = [[UIButton alloc]init];

    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
     [self renderBtn:cancelBtn];
//    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];


//    NSMutableArray *btnLArr = [[NSMutableArray alloc]init];
    NSMutableArray *btnRArr = [[NSMutableArray alloc]init];
    //统一设坐标
//    [btnLArr addObject:redoBtn];
//    [btnLArr addObject:undoBtn];
    [btnRArr addObject:clearBtn];
    [btnRArr addObject:okBtn];
    [btnRArr addObject:cancelBtn];


    int i = 0;
//    for (UIButton *btn in btnLArr) {
//        btn.frame = CGRectMake(10, btn_y+ i * (btn_h+btn_mid), btn_w, btn_h);
//        i++;
//    }
//    i = 0;
    
     id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    
    CGRect appFrame = appDelegate.window.rootViewController.view.frame;
    CGFloat cx = MIN(appFrame.size.width, appFrame.size.height) - btn_w * 3 - 60 - btn_mid * 2 +30;
    for (UIButton *btn in btnRArr) {
        [btn.titleLabel setFont:[UIFont fontWithName:@"Futura" size:17]];
        CGRect ct = CGRectMake(cx + i * (btn_w+btn_mid), 400, btn_w, btn_h);
        ct.origin.y -= 60;
        btn.frame = ct;
        i++;
    }

//    [btnLArr release];
//    [btnRArr release];


    //sliderLbl
//    UILabel *sliderLbl = [[UILabel alloc]init];
//    sliderLbl.text = @"Line Width:";
//    sliderLbl.textAlignment = NSTextAlignmentLeft;
//    sliderLbl.textColor = [UIColor whiteColor];
//    sliderLbl.frame = CGRectMake(40, 400, 120, 20);
//    sliderLbl.font = [UIFont systemFontOfSize:18.0];
//    sliderLbl.backgroundColor = [UIColor clearColor];
//    [self addSubview:sliderLbl];
//    [sliderLbl release];
    
    
    UISwitch *applyToAll = [[UISwitch alloc]initWithFrame:CGRectMake(10, okBtn.frame.origin.y+5, 60, 20)];
    [self addSubview:applyToAll];
    toAllSwitch = applyToAll;
    applyToAll.tintColor = [UIColor whiteColor];
    applyToAll.onTintColor = [UIColor whiteColor];
//    applyToAll.onTintColor = [UIColor colorWithRed: 66/255.0 green: 133/255.0 blue: 244/255.0 alpha: 1];
//    [applyToAll.layer setBorderWidth:1.0f];
//    [applyToAll.layer setBorderColor:RGBCOLOR(255, 255, 255).CGColor];
    applyToAll.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    sliderLbl = [[UILabel alloc]init];
    sliderLbl.text = @"Apply to all pages";
    [sliderLbl setFont:[UIFont fontWithName:@"Futura" size:17]];
    sliderLbl.textAlignment = NSTextAlignmentLeft;
    sliderLbl.textColor = [UIColor whiteColor];
    sliderLbl.frame = CGRectMake(70, okBtn.frame.origin.y+10, 220, 20);
    sliderLbl.font = [UIFont systemFontOfSize:18.0];
    sliderLbl.backgroundColor = [UIColor clearColor];
    [self addSubview:sliderLbl];
    
    
    

    //penBoldSlider
//    penBoldSlider = [[UISlider alloc]init];
//    penBoldSlider.frame = CGRectMake(160, 400, 200, 20);
//    penBoldSlider.minimumValue = 0;
//    penBoldSlider.maximumValue = 9;
//    penBoldSlider.value = 0;
//    [penBoldSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
//    [self addSubview:penBoldSlider];

    //
    colors=[[NSMutableArray alloc]initWithObjects:[UIColor greenColor],[UIColor blueColor],[UIColor redColor],[UIColor blackColor],[UIColor whiteColor], nil];
    self.buttonHidden=YES;
    self.widthHidden=YES;
//    NSLog(@"%f", MIN(appFrame.size.width, appFrame.size.height) - 20);
    self.drawView=[[MyView alloc]initWithFrame:CGRectMake(0, 60, MIN(appFrame.size.width, appFrame.size.height) - 20, 800/3.0)];
    [self.drawView setBackgroundColor:RGBCOLOR(255, 255, 255)];
    [self addSubview: self.drawView];
    [self sendSubviewToBack:self.drawView];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)setLineArray:(NSArray *)lineArray{
    if (lineArray && lineArray > 0) {
        clearBtn.hidden = YES;
    }
    [self.drawView setLineArray1:lineArray];
}


-(void)setShowSwitch:(BOOL)showSwitch{
    toAllSwitch.hidden = !showSwitch;
    sliderLbl.hidden = !showSwitch;
    
    contentLbl.text = showSwitch? @"Please print your initial here" : @"Please signature here";
}

-(void)setShowSwitch2:(BOOL)showSwitch{
    toAllSwitch.hidden = showSwitch;
    sliderLbl.hidden = showSwitch;
    contentLbl.text =  @"Please print your initial here";
}


-(void) setTitle: (NSString *)xtitle{
    contentLbl.text = xtitle;
}

-(void)changeColors:(id)sender{
    if (self.buttonHidden==YES) {
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=NO;
            self.buttonHidden=NO;
        }
    }else{
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=YES;
            self.buttonHidden=YES;
        }
    }
}

-(void)changeWidth:(id)sender{
    if (self.widthHidden==YES) {
        for (int i=11; i<15; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=NO;
            self.widthHidden=NO;
        }
    }else{
        for (int i=11; i<15; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=YES;
            self.widthHidden=YES;
        }

    }
    
    
    

}
- (void)widthSet:(id)sender {
    UIButton *button=(UIButton *)sender;
//    NSLog(@"%d", button.tag-10);
    [self.drawView setlineWidth:button.tag-10];
//    [self.drawView setNeedsDisplay];
}

- (UIView *)saveScreen{
    return self.drawView.Signature;
//    UIView *screenView = self.drawView;
//
//    for (int i=1; i<16;i++) {
//        UIView *view=[self viewWithTag:i];
//        if ((i>=1&&i<=5)||(i>=10&&i<=15)) {
//            if (view.hidden==YES) {
//                continue;
//            }
//        }
//        view.hidden=YES;
//        if(i>=1&&i<=5){
//            self.buttonHidden=YES;
//        }
//        if(i>=10&&i<=15){
//            self.widthHidden=YES;
//        }
//    }
//    UIGraphicsBeginImageContext(screenView.bounds.size);
//    [screenView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
////    UIImageWriteToSavedPhotosAlbum(image, screenView, nil, nil);
////    for (int i=1;i<16;i++) {
////        if ((i>=1&&i<=5)||(i>=11&&i<=14)) {
////            continue;
////        }
////        UIView *view=[self viewWithTag:i];
////        view.hidden=NO;
////    }
//    NSLog(@"截屏成功");
//    image = [DrawSignView imageToTransparent:image];
//    return image;
    
}

- (void)colorSet:(id)sender {
    UIButton *button=(UIButton *)sender;
    [self.drawView setLineColor:button.tag-1];
    colorBtn.backgroundColor=[colors objectAtIndex:button.tag-1];
}

/** 封装的按钮事件 */
-(void)btnAction:(id)sender{
    if (sender == cancelBtn) {
        cancelBlock();
    }else if (sender == okBtn){
        signCallBackBlock([self.drawView Signature], toAllSwitch.on);
//        signCallBackBlock([self saveScreen]);
    }else if (sender == redoBtn){
       [ self.drawView revocation];
    }else if(sender == undoBtn){
        [ self.drawView refrom];
    }else if(sender == clearBtn){
        [self.drawView clear];
        penBoldSlider.value = 0;
    }
}


///** 笔触粗细 */
//-(void)updateValue:(id)sender{
//    if (sender == penBoldSlider) {
//        CGFloat f = penBoldSlider.value;
////        NSLog(@"%f",f);
//        NSInteger w = (int)ceilf(f);
//        [self.drawView setlineWidth:w];
//        [self.drawView setNeedsDisplay];
//    }
//}

/** 颜色变化 */
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

//颜色替换
+ (UIImage*) imageToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);

    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);

    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {



        //把绿色变成黑色，把背景色变成透明
        if ((*pCurPtr & 0x65815A00) == 0x65815a00)    // 将背景变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else if ((*pCurPtr & 0x00FF0000) == 0x00ff0000)    // 将绿色变成黑色
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
        else if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // 将白色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }

    }

    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);

    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];

    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}


-(void)renderBtn:(UIButton *)btn{
    [btn setBackgroundImage:[self imageFromColor:RGBCOLOR(35,174,235)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self imageFromColor:RGBCOLOR(169,183,192)]
                   forState:UIControlStateHighlighted];
     double dRadius = 5.0f;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //CornerRadius/Border
    [btn.layer setCornerRadius:dRadius];
    [btn.layer setBorderWidth:1.0f];
    [btn.layer setBorderColor:RGBCOLOR(255, 255, 255).CGColor];
    [btn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];

}

- (UIImage *) imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
