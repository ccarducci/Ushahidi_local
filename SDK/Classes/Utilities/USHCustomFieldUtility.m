//
//  USHCustomFieldUtility.m
//  SDK
//
//  Created by Cristiano Carducci on 03/01/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import "USHCustomFieldUtility.h"
#import "ReportCustomField.h"
#import "USHDatabase.h"


SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(USHCustomFieldUtility);

@class ReportCustomField;

@implementation USHCustomFieldUtility

SYNTHESIZE_SINGLETON_FOR_CLASS(USHCustomFieldUtility);

- (id) init {
    if (self = [super init]){
        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


+ (NSMutableArray *) getCustomFields:(NSString*)identifier{
     NSLog(@"Search custom field for report %@", identifier);
     NSMutableArray *cutomFields = [[NSMutableArray alloc] init];
     for (ReportCustomField *customField in [[USHDatabase sharedInstance] fetchArrayForName:@"ReportCustomField" query:@"identifier = %@" param:identifier sort:nil])
     {
         /*
         NSLog(@"----------------------------------------------");
         NSLog(@"Add custom field %@", customField.name);
         NSLog(@"                 %@", customField.value);
         NSLog(@"                 %@", customField.type);
         NSLog(@"                 %@", customField.defaultvalue);
         NSLog(@"----------------------------------------------");
         */
         [cutomFields addObject:customField];
         
     }
     
    return cutomFields;
}


@end
