//
//  cl_searchtxt.m
//  HappApp
//
//  Created by roberto ramirez on 1/26/15.
//  Copyright (c) 2015 lovetthomes. All rights reserved.
//

#import "cl_pdf.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@implementation cl_pdf{
    NSManagedObjectContext *managedObjectContext;
}
-(id)init{
    id delegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [delegate managedObjectContext];
    return [super init];
};


- (BOOL)addToPDF:(NSData *)pdfdata withId:(NSString *)xkey{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PDF_FIELD" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSString * str=[NSString stringWithFormat:@"idcia_idcity ='%@'", xkey];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    NSManagedObject *steve;
    for (NSManagedObject *mo in mutableFetchResult) {
        steve=mo;
        break;
    }
    if (steve) {
        [managedObjectContext deleteObject: steve];
    }
    
    
    
    NSManagedObject *steve1= [NSEntityDescription insertNewObjectForEntityForName:@"PDF_FIELD" inManagedObjectContext:managedObjectContext];
    [steve1 setValue:xkey forKey:@"idcia_idcity"];
    [steve1 setValue:pdfdata forKey:@"field"];
    
    
    BOOL isSaveSuccess=[managedObjectContext save:&error];
    if (!isSaveSuccess) {
        return NO;
    }
    return YES;
}


- (NSData *)getPDFByKey:(NSString *)xkey{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PDF_FIELD" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSString * str=[NSString stringWithFormat:@"idcia_idcity ='%@'", xkey];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *mutableFetchResult = [managedObjectContext executeFetchRequest:request error:&error];
    if ([mutableFetchResult count]==0) {
        return nil;
    }else{
        
//        for (NSInteger i=t-1; i>=0; i--) {
            NSManagedObject *mo =[mutableFetchResult firstObject];
             return [mo valueForKey:@"field"];
//            [na addObject:mo];
//        }
    }
    return Nil;
}


@end
