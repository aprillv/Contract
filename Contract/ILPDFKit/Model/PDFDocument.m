// PDFDocument.m
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
#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)
#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)
#import "PDFDocument.h"
#import "PDFForm.h"
#import "PDFDictionary.h"
#import "PDFArray.h"
#import "PDFStream.h"
#import "PDFPage.h"
#import "PDFUtility.h"
#import "PDFFormButtonField.h"
#import "PDFFormTextField.h"
#import "SignatureView.h"
#import "PDFFormContainer.h"
#import "PDFSerializer.h"
#import "PDF.h"

static void renderPage(NSUInteger page, CGContextRef ctx, CGPDFDocumentRef doc, PDFFormContainer *forms) {
    CGRect mediaRect = CGPDFPageGetBoxRect(CGPDFDocumentGetPage(doc,page), kCGPDFMediaBox);
    CGRect cropRect = CGPDFPageGetBoxRect(CGPDFDocumentGetPage(doc,page), kCGPDFCropBox);
    CGRect artRect = CGPDFPageGetBoxRect(CGPDFDocumentGetPage(doc,page), kCGPDFArtBox);
    CGRect bleedRect = CGPDFPageGetBoxRect(CGPDFDocumentGetPage(doc,page), kCGPDFBleedBox);
    UIGraphicsBeginPDFPageWithInfo(mediaRect, @{(NSString*)kCGPDFContextCropBox:[NSValue valueWithCGRect:cropRect],(NSString*)kCGPDFContextArtBox:[NSValue valueWithCGRect:artRect],(NSString*)kCGPDFContextBleedBox:[NSValue valueWithCGRect:bleedRect]});
    CGContextSaveGState(ctx);
    CGContextScaleCTM(ctx,1,-1);
    CGContextTranslateCTM(ctx, 0, -mediaRect.size.height);
    CGContextDrawPDFPage(ctx, CGPDFDocumentGetPage(doc,page));
    CGContextRestoreGState(ctx);
    for (PDFForm *form in forms) {
        if (form.page == page) {
            CGContextSaveGState(ctx);
            CGRect frame = form.frame;
            CGRect correctedFrame = CGRectMake(frame.origin.x-mediaRect.origin.x, mediaRect.size.height-frame.origin.y-frame.size.height-mediaRect.origin.y, frame.size.width, frame.size.height);
            CGContextTranslateCTM(ctx, correctedFrame.origin.x, correctedFrame.origin.y);
            [form vectorRenderInPDFContext:ctx forRect:correctedFrame];
            CGContextRestoreGState(ctx);
        }
    }
}

static void renderPage1(NSUInteger page, CGContextRef ctx, CGPDFDocumentRef doc, PDFFormContainer *forms, NSArray *viewarray) {
     CGFloat xf = 612.0*297.0/210.0;
    CGRect mediaRect = CGPDFPageGetBoxRect(CGPDFDocumentGetPage(doc,page), kCGPDFMediaBox);
    CGRect cropRect = CGPDFPageGetBoxRect(CGPDFDocumentGetPage(doc,page), kCGPDFCropBox);
    CGRect artRect = CGPDFPageGetBoxRect(CGPDFDocumentGetPage(doc,page), kCGPDFArtBox);
    CGRect bleedRect = CGPDFPageGetBoxRect(CGPDFDocumentGetPage(doc,page), kCGPDFBleedBox);
    UIGraphicsBeginPDFPageWithInfo(mediaRect, @{(NSString*)kCGPDFContextCropBox:[NSValue valueWithCGRect:cropRect],(NSString*)kCGPDFContextArtBox:[NSValue valueWithCGRect:artRect],(NSString*)kCGPDFContextBleedBox:[NSValue valueWithCGRect:bleedRect]});
    CGContextSaveGState(ctx);
    CGContextScaleCTM(ctx,1,-1);
    CGContextTranslateCTM(ctx, 0, -mediaRect.size.height);
    CGContextDrawPDFPage(ctx, CGPDFDocumentGetPage(doc,page));
    CGContextRestoreGState(ctx);
    for (PDFForm *form in forms) {
        if (form.page == page) {
           
            CGContextSaveGState(ctx);
            CGRect frame = form.frame;
//            if (!form.value) {
//                form.value = @"";
//            }
//            if (viewarray && viewarray.count == 1){
//                frame.origin.y -= 982.788208*2;}
//            NSLog(@"addedView.pagenomargin %@", form.pagenomargin);
            CGRect correctedFrame = CGRectMake(frame.origin.x-mediaRect.origin.x, mediaRect.size.height-frame.origin.y-frame.size.height-mediaRect.origin.y, frame.size.width, frame.size.height);
            while (correctedFrame.origin.y > xf) {
                correctedFrame.origin.y -= xf;
            }
            CGContextTranslateCTM(ctx, correctedFrame.origin.x, correctedFrame.origin.y);
            [form vectorRenderInPDFContext:ctx forRect:correctedFrame];
            CGContextRestoreGState(ctx);
        }
    }
    CGFloat xmargin;
    CGFloat ymargin;
    CGFloat factor;
    
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
        xmargin = 9;
        ymargin = 6.1;
        if ([UIScreen mainScreen].bounds.size.width > 1024 || [UIScreen mainScreen].bounds.size.height > 1024) {
            factor = 1006/612.0;
        }else{
            factor = 750/612.0;
        }
        
    }else{
        xmargin = 13;
        ymargin = 7.25;
        if ([UIScreen mainScreen].bounds.size.width > 1024 || [UIScreen mainScreen].bounds.size.height > 1024) {
            factor = 1340/612.0;
        }else{
            factor = 998/612.0;
        }
        
    }
//    CGFloat xf = 612.0*297.0/210.0;
    
    for (PDFWidgetAnnotationView *addedView in viewarray) {
//        if ([addedView.value hasPrefix:@"Lot 12 Blk "]) {
//            NSLog(@"++++++++++++ %@ %@", addedView.xname, addedView.value);
//        }
        
//        NSLog(@"addedView.pagenomargin %@", addedView.pagenomargin);
         CGRect frame = addedView.frame;
//        NSLog(@"addedView.pageno %@", addedView.pageno);
        if (addedView.pageno ) {
            if ( [addedView.pageno integerValue] == 1) {
                if (page !=2) {
                   
                    continue;
                }else{
                    CGFloat f = [[[NSUserDefaults standardUserDefaults] valueForKey:@"pageHeight"] doubleValue] ;
                    frame.origin.y -= f;
                }
//                correctedFrame.origin.y += 100;
            }else{
                if (page != 1) {
                    continue;
                }
            }
            
        }else{
//            correctedFrame.origin.y += 140;
        }
        
       
        CGFloat xfa = 0;
        if (addedView.pagenomargin) {
            xfa = addedView.pagenomargin;
        }
        
        
        CGRect correctedFrame = CGRectMake((frame.origin.x - xmargin)/factor, (frame.origin.y-ymargin-xfa)/factor, frame.size.width/factor, frame.size.height/factor);
        
        while (correctedFrame.origin.y > xf) {
            correctedFrame.origin.y -= xf;
        }
        
        
        if ([addedView isKindOfClass:[PDFFormTextField class]]) {
            CGContextSaveGState(ctx);
            
            
            PDFFormTextField *texta = (PDFFormTextField *)addedView;
            NSString *text = texta.value;
        
//            CGRect rect = correctedFrame;
//            NSLog(@"%f", [texta currentFontSize]);
            UIFont *font;
            if ([texta currentFontSize] == 0.0) {
//                font = [UIFont systemFontOfSize: [PDFWidgetAnnotationView fontSizeForRect:rect value:texta.value multiline:NO choice:NO] ];
//                [UIFont systemFontOfSize:<#(CGFloat)#>]
                font = [UIFont fontWithName:@"Verdana" size:12];
            }else{
                font = [UIFont fontWithName:@"Verdana" size:(([texta currentFontSize] / factor))];
            }
            
            
            UIGraphicsPushContext(ctx);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.alignment = texta.alignment;
            [text drawInRect:correctedFrame  withAttributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName: paragraphStyle}];
            UIGraphicsPopContext();
            CGContextRestoreGState(ctx);
        }else if([addedView isKindOfClass:[SignatureView class]]) {
            SignatureView *sw = (SignatureView *)addedView;
            [sw drawInRect2:correctedFrame withContext:ctx];
        }else{
            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, correctedFrame.origin.x, correctedFrame.origin.y);
            CGContextAddLineToPoint(ctx, correctedFrame.origin.x + correctedFrame.size.width, correctedFrame.origin.y);
            CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
//            CGContextSetLineWidth(ctx, correctedFrame.size.height);
            CGContextSetLineWidth(ctx, 0.5);
            CGContextStrokePath(ctx);
        }
    }
}

@implementation PDFDocument {
    NSString *_documentPath;
    PDFDictionary *_catalog;
    PDFDictionary *_info;
    PDFFormContainer *_forms;
    NSArray *_pages;
}

#pragma mark - NSObject

- (void)dealloc {
    CGPDFDocumentRelease(_document);
}

#pragma mark - PDFDocument
- (instancetype)init{
    return [self initWithData:nil];
}
- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self != nil) {
        _document = [PDFUtility createPDFDocumentRefFromData:data];
        _documentData = [[NSMutableData alloc] initWithData:data];
    }
    return self;
}

- (instancetype)initWithResource:(NSString *)name {
//    NSLog(@"%@", name);
    self = [super init];
    if (self != nil) {
        if ([[[name componentsSeparatedByString:@"."] lastObject] isEqualToString:@"pdf"])
            name = [name substringToIndex:name.length-4];
        _document = [PDFUtility createPDFDocumentRefFromResource:name];
        _documentPath = [[NSBundle mainBundle] pathForResource:name ofType:@"pdf"] ;
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self != nil) {
        _document = [PDFUtility createPDFDocumentRefFromPath:path];
        _documentPath = path;
    }
    return self;
}

- (void)refresh {
    _catalog = nil;
    _pages = nil;
    _info = nil;
    CGPDFDocumentRelease(_document);_document = NULL;
    _document = [PDFUtility createPDFDocumentRefFromData:self.documentData];
}

#pragma mark - Getters

- (PDFFormContainer *)forms {
    if (_forms == nil) {
        _forms = [[PDFFormContainer alloc] initWithParentDocument:self];
    }
    return _forms;
}

- (NSMutableData *)documentData {
    if (_documentData == nil) {
        _documentData = [[NSMutableData alloc] initWithContentsOfFile:_documentPath options:NSDataReadingMappedAlways error:NULL];
    }
    return _documentData;
}

- (PDFDictionary *)catalog {
    if (_catalog == nil) {
        _catalog = [[PDFDictionary alloc] initWithDictionary:CGPDFDocumentGetCatalog(_document)];
    }
    return _catalog;
}

- (PDFDictionary *)info {
    if (_info == nil) {
        _info = [[PDFDictionary alloc] initWithDictionary:CGPDFDocumentGetInfo(_document)];
    }
    return _info;
}

- (NSArray *)pages {
    if (_pages == nil) {
        NSMutableArray* temp = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < CGPDFDocumentGetNumberOfPages(_document); i++) {
            [temp addObject:[[PDFPage alloc] initWithPage:CGPDFDocumentGetPage(_document,i+1)]];
        }
        _pages = [[NSArray alloc] initWithArray:temp];
    }
    return _pages;
}

- (NSUInteger)numberOfPages {
    return CGPDFDocumentGetNumberOfPages(_document);
}

#pragma mark - PDF File Saving and Converting


- (NSString *)formXML {
    return [self.forms formXML];
}

- (NSData *)savedStaticPDFData {
    
    NSUInteger numberOfPages = [self numberOfPages];
    NSMutableData *pageData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pageData, CGRectZero , nil);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (NSUInteger page = 1; page <= numberOfPages; page++) {
        renderPage(page, ctx, _document, self.forms);
    }
    UIGraphicsEndPDFContext();
    return pageData;
}

- (NSData *)savedStaticPDFData :(NSArray *)addedview{
    NSUInteger numberOfPages = [self numberOfPages];
    NSMutableData *pageData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pageData, CGRectZero , nil);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (NSUInteger page = 1; page <= numberOfPages; page++) {
        renderPage1(page, ctx, _document, self.forms, addedview);
    }
    UIGraphicsEndPDFContext();
    return pageData;
}



- (NSData *)mergedDataWithDocument:(PDFDocument *)docToAppend {
    NSMutableData *pageData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pageData, CGRectZero , nil);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (NSUInteger page = 1; page <= [self numberOfPages]; page++) {
        renderPage(page, ctx, _document, self.forms);
    }
    for (NSUInteger page = 1; page <= [docToAppend numberOfPages]; page++) {
        renderPage(page, ctx, docToAppend.document, docToAppend.forms );
    }
    UIGraphicsEndPDFContext();
    return pageData;
    
}

+ (NSData *)mergedDataWithDocuments:(NSArray *)docs{
    NSMutableData *pageData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pageData, CGRectZero , nil);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (NSUInteger dcnt = 0; dcnt < docs.count; dcnt++ ) {
        PDFDocument *doc = docs[dcnt];
       
        NSArray *addedviews = doc.addedviewss;
        
        for (NSUInteger page = 1; page <= [doc numberOfPages]; page++) {
//            if (dcnt == 6){
//                renderPage(page, ctx, doc.document, doc.forms);
//            }else{
//                NSLog(@"%@", addedviews);
                renderPage1(page, ctx, doc.document, doc.forms, addedviews);
//            }
            
        }
    }
    UIGraphicsEndPDFContext();
    return pageData;
    
}




- (UIImage *)imageFromPage:(NSUInteger)page width:(NSUInteger)width {
    CGPDFDocumentRef doc = [PDFUtility createPDFDocumentRefFromData:[self savedStaticPDFData]];
    CGPDFPageRef pageref = CGPDFDocumentGetPage(doc, page);
    CGRect pageRect = CGPDFPageGetBoxRect(pageref, kCGPDFMediaBox);
    CGFloat pdfScale = width/pageRect.size.width;
    pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
    pageRect.origin = CGPointZero;
    UIGraphicsBeginImageContext(pageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context,pageRect);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, pageRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(pageref, kCGPDFMediaBox, pageRect, 0, true));
    CGContextDrawPDFPage(context, pageref);
    CGContextRestoreGState(context);
    UIImage *thm = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGPDFDocumentRelease(doc);
    return thm;
}

@end
