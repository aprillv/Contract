//
//  cl_searchtxt.h
//  HappApp
//
//  Created by roberto ramirez on 1/26/15.
//  Copyright (c) 2015 lovetthomes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cl_pdf : NSObject
- (NSData *)getPDFByKey:(NSString *)xkey;
- (BOOL)addToPDF:(NSData *)pdfdata withId:(NSString *)xkey;
//-(BOOL)addToSearchTxt1:(NSString *)dicInfo withId:(NSString *)xid withPN:(NSString *)pn  withPS:(NSString *)ps  withPW:(NSString *)pw  withPE:(NSString *)pe;
@end
