// PDFFormTextField.m
//
// Copyright (c) 2015 Iwe Labs
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <QuartzCore/QuartzCore.h>
#import "PDF.h"
#import "PDFFormTextField.h"

@interface PDFFormTextField(Delegates) <UITextViewDelegate,UITextFieldDelegate>
@end

@implementation PDFFormTextField {
    BOOL _multiline;
    UIView *_textFieldOrTextView;
    CGFloat _baseFontSize;
    CGFloat _currentFontSize;
    NSString *_values;
}

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
    removeObserver:self];
}
-(CGFloat)currentFontSize{
    return _currentFontSize;
}
-(NSTextAlignment)alignment{
//    Class textCls = _multiline ? [UITextView class]:[UITextField class];
    if (_multiline) {
        UITextView* textfield = (UITextView *)_textFieldOrTextView;
        return textfield.textAlignment;
    }else{
        UITextField* textfield = (UITextField *)_textFieldOrTextView;
        return textfield.textAlignment;
    }
    
}
#pragma mark - PDFFormTextField
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self initWithFrame: CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame multiline:NO alignment:NSTextAlignmentLeft secureEntry:NO readOnly:YES withName: nil];
}
- (instancetype)initWithFrame:(CGRect)frame multiline:(BOOL)multiline alignment:(NSTextAlignment)alignment secureEntry:(BOOL)secureEntry readOnly:(BOOL)ro withName:(NSString *)xname{
    self = [super initWithFrame:frame];
   
    if (self != nil) {
        
        self.opaque = NO;
//        self.backgroundColor = ro ? [UIColor clearColor]:[UIColor lightGrayColor];
        if (!multiline) {
            self.layer.cornerRadius = self.frame.size.height/6;
        }
        _multiline = multiline;
        Class textCls = multiline ? [UITextView class]:[UITextField class];
        _textFieldOrTextView = [[textCls alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if (secureEntry) {
            ((UITextField *)_textFieldOrTextView).secureTextEntry = YES;
        }
//        if (ro) {
            _textFieldOrTextView.userInteractionEnabled = NO;
//        }
        if (multiline) {
            ((UITextView *)_textFieldOrTextView).textAlignment = (NSTextAlignment)alignment;
            ((UITextView *)_textFieldOrTextView).autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            ((UITextView *)_textFieldOrTextView).delegate = self;
            ((UITextView *)_textFieldOrTextView).scrollEnabled = YES;
            [((UITextView *)_textFieldOrTextView) setTextContainerInset:UIEdgeInsetsMake(4, 4, 4, 4)];
        } else {
            ((UITextField *)_textFieldOrTextView).textAlignment = (NSTextAlignment)alignment;
            ((UITextField *)_textFieldOrTextView).delegate = self;
            ((UITextField *)_textFieldOrTextView).adjustsFontSizeToFitWidth = YES;
            ((UITextField *)_textFieldOrTextView).minimumFontSize = PDFFormMinFontSize;
            ((UITextField *)_textFieldOrTextView).autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:_textFieldOrTextView];
        }
        _textFieldOrTextView.opaque = NO;
        _textFieldOrTextView.backgroundColor = [UIColor clearColor];
        _baseFontSize = [PDFWidgetAnnotationView fontSizeForRect:frame value:nil multiline:multiline choice:NO font:@"Helvetica"];
        
        _currentFontSize = _baseFontSize;
        self.xname = xname;
        
        
//        if ([xname isEqualToString:@"block2"]){
//        _currentFontSize = _baseFontSize = _currentFontSize/1.5;
//        }
//        if ([self.xname isEqualToString:@"april"]){
//            NSLog(@"%@ %@ %f %f", self.xname, self.value, _currentFontSize, _baseFontSize);
//        }
        
        UIFont *font = [UIFont fontWithName:@"Helvetica" size: _baseFontSize];
        
        
        [_textFieldOrTextView performSelector:@selector(setFont:) withObject:font];
        [self addSubview:_textFieldOrTextView];
    }
    _values = @"";
    return self;
}


-(void)sizeToFit{
    [super sizeToFit];
    if (_multiline) {
        [_textFieldOrTextView sizeToFit];
        _textFieldOrTextView.frame = CGRectMake(0, 0, self.frame.size.width, _textFieldOrTextView.frame.size.height+1);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _textFieldOrTextView.frame.size.height+2);
//        [self refresh];
    }
}
- (instancetype)initWithFrame:(CGRect)frame multiline:(BOOL)multiline alignment:(NSTextAlignment)alignment secureEntry:(BOOL)secureEntry readOnly:(BOOL)ro withFont:(CGFloat)fontsize{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        self.opaque = NO;
        //        self.backgroundColor = ro ? [UIColor clearColor]:[UIColor lightGrayColor];
        if (!multiline) {
            self.layer.cornerRadius = self.frame.size.height/6;
        }
        _multiline = multiline;
        Class textCls = multiline ? [UITextView class]:[UITextField class];
        _textFieldOrTextView = [[textCls alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if (secureEntry) {
            ((UITextField *)_textFieldOrTextView).secureTextEntry = YES;
        }
        if (ro) {
            _textFieldOrTextView.userInteractionEnabled = NO;
        }
        if (multiline) {
            ((UITextView *)_textFieldOrTextView).textAlignment = (NSTextAlignment)alignment;
            ((UITextView *)_textFieldOrTextView).autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            ((UITextView *)_textFieldOrTextView).delegate = self;
            ((UITextView *)_textFieldOrTextView).scrollEnabled = NO;
            [((UITextView *)_textFieldOrTextView) setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        } else {
            ((UITextField *)_textFieldOrTextView).textAlignment = (NSTextAlignment)alignment;
            ((UITextField *)_textFieldOrTextView).delegate = self;
            ((UITextField *)_textFieldOrTextView).adjustsFontSizeToFitWidth = YES;
            ((UITextField *)_textFieldOrTextView).minimumFontSize = PDFFormMinFontSize;
            ((UITextField *)_textFieldOrTextView).autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:_textFieldOrTextView];
        }
        
        
        
//        _textFieldOrTextView.opaque = NO;
//        _textFieldOrTextView.backgroundColor = [UIColor clearColor];
//        _baseFontSize = [PDFWidgetAnnotationView fontSizeForRect:frame value:nil multiline:multiline choice:NO  font:@"Verdana"];
//        
        _currentFontSize = _baseFontSize = fontsize;
//
//        UIFont *font = [UIFont fontWithName:@"Verdana" size: _baseFontSize];
        
        
//        [_textFieldOrTextView performSelector:@selector(setFont:) withObject:font];
        [self addSubview:_textFieldOrTextView];
    }
    return self;
}


#pragma mark - PDFWidgetAnnotationView

- (void)setValue:(NSString *)value {
    _values = value;
    UIFont *font ;
    
    if ([self.xname isEqualToString:@"txtDesignDate"]) {
//        _baseFontSize = [PDFWidgetAnnotationView fontSizeForRect:self.frame value:nil multiline:_multiline choice:NO font:@"Verdana-Bold"];
        
        CGFloat size = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? 14 : 10;
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            size = [UIScreen mainScreen].bounds.size.width / 1024 * 14;
        }else{
            size = [UIScreen mainScreen].bounds.size.width / 768 * 10;
        }
        
        _currentFontSize = _baseFontSize = size;
        
//        NSLog(@"%@", [UIScreen mainScreen]);
        
        font = [UIFont fontWithName:@"Verdana-Bold" size: _baseFontSize];
        [_textFieldOrTextView performSelector:@selector(setFont:) withObject:font];
    }else if([self.xname isEqualToString:@" Edit"]){
        _textFieldOrTextView.userInteractionEnabled = YES;
    }
    
    if ([value isKindOfClass:[NSNull class]]) {
        [self setValue:nil];
        return;
    }
    [self.delegate widgetAnnotationValueChanged:self];
    if ([_textFieldOrTextView isKindOfClass:[UITextField class]] || [_textFieldOrTextView isKindOfClass:[UITextView class]]){
        [_textFieldOrTextView performSelector:@selector(setText:) withObject:value];
    }
    
    
    
    [self refresh];
}

- (NSString *)value {
    return _values;
//    NSString *ret = [_textFieldOrTextView performSelector:@selector(text)];
//    return [ret length] ? ret:nil;
}

- (void)updateWithZoom:(CGFloat)zoom {
    [super updateWithZoom:zoom];
//    NSLog(@"%@ %f %f %f %f %f  %f %f %f %f", self.xname, zoom, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height, _textFieldOrTextView.frame.origin.x, _textFieldOrTextView.frame.origin.y, _textFieldOrTextView.frame.size.width, _textFieldOrTextView.frame.size.height);
    UIFont *font;
    if ([self.xname isEqualToString:@"txtDesignDate"]) {
        font = [UIFont fontWithName:@"Verdana-Bold" size:_currentFontSize = (_baseFontSize*zoom)];
    }else if([self.xname hasPrefix: @"SpecialProvision"]){
        font = [UIFont fontWithName:@"Helvetica" size:_currentFontSize = (_baseFontSize*zoom)];
    }else{
        font = [UIFont fontWithName:@"Verdana" size:_currentFontSize = (_baseFontSize*zoom)];
    }
    
//    NSLog(@"%@ %f", self.xname, _currentFontSize);
    [_textFieldOrTextView performSelector:@selector(setFont:) withObject:font];
    [_textFieldOrTextView setNeedsDisplay];
    [self setNeedsDisplay];
}


- (void)refresh {
    [self setNeedsDisplay];
    [_textFieldOrTextView setNeedsDisplay];
}

#pragma mark - Notification Responders

- (void)textChanged:(id)sender {
    [self.delegate widgetAnnotationValueChanged:self];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.delegate widgetAnnotationEntered:self];
    self.parentView.activeWidgetAnnotationView = self;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.parentView.activeWidgetAnnotationView = nil;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.delegate widgetAnnotationValueChanged:self];
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    NSLog(@"%@", text);
    CGSize contentSize = CGSizeMake(textView.bounds.size.width-PDFFormMinFontSize, CGFLOAT_MAX);
    float numLines = ceilf((textView.bounds.size.height / textView.font.lineHeight));
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([newString length] < [textView.text length])return YES;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect textRect = [newString boundingRectWithSize:contentSize
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName:textView.font,NSParagraphStyleAttributeName:paragraphStyle}
                                        context:nil];
    float usedLines = ceilf(textRect.size.height/textView.font.lineHeight);
    if (usedLines >= numLines && usedLines > 1) return NO;
    return YES;
}

#pragma mark - UITextFieldDelegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString length] <= [textField.text length]) return YES;
    if ([newString sizeWithAttributes:@{NSFontAttributeName:textField.font}].width > (textField.bounds.size.width + PDFFormMinFontSize)) {
       return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.delegate widgetAnnotationEntered:self];
     self.parentView.activeWidgetAnnotationView = self;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.parentView.activeWidgetAnnotationView = nil;
}

- (void)resign {
    [_textFieldOrTextView resignFirstResponder];
}

@end
