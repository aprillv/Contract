////
////  PDFFormImageView.m
////  ILPDFKitSample
////
////  Created by April on 11/14/15.
////  Copyright © 2015 Iwe Labs. All rights reserved.
////
//
//#import "PDFFormImageView.h"
//
//#define PDFButtonMinScaledDimensionScaleFactor 0.85
//#define PDFButtonMinScaledDimension(r) MIN((r).size.width,(r).size.height)*PDFButtonMinScaledDimensionScaleFactor
//#define PDFButtonMarginScaleFactor 0.75
//
//@implementation PDFFormImageView{
//    UIImageView *im;
//}
//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self != nil) {
//        im = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        im.image = [UIImage imageNamed:@"img.png"];
//        im.contentMode = UIViewContentModeScaleAspectFill;
//        [self addSubview:im];
//    }
//    return self;
//}
//
//- (UIImage *)value1 {
//    UIImage *img = [im image];
//    return img;
//}
//
//- (void)updateWithZoom:(CGFloat)zoom {
//    [super updateWithZoom: zoom];
////    NSLog(@"%f -- %f %f", zoom, im.frame.size.height, im.frame.size.width);
////    CGFloat minDim = PDFButtonMinScaledDimension(self.bounds);
////    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
////    im.frame = CGRectMake(center.x-minDim+self.frame.origin.x, center.y-minDim+self.frame.origin.y, minDim*2, minDim*2);
////    if (im) im.layer.cornerRadius = im.frame.size.width/2;
////    [self refresh];
//    [self setNeedsDisplay];
//}
//
//
//@end
