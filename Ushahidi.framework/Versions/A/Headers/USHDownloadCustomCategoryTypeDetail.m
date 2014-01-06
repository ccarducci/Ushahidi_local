//
//  USHDownloadCustomCategoryTypeDetail.m
//  SDK
//
//  Created by Cristiano Carducci on 05/01/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import "USHDownloadCustomCategoryTypeDetail.h"
#import "NSDictionary+USH.h"
#import "NSObject+USH.h"
#import "Ushahidi.h"
#import "USHDatabase.h"
#import "CustomFieldTypeDetail.h"
#import "USHMap.h"

@interface USHDownloadCustomCategoryTypeDetail ()

@property (nonatomic, strong, readwrite) CustomFieldTypeDetail *customFieldTypeDetail;

@end


@implementation USHDownloadCustomCategoryTypeDetail

@synthesize customFieldTypeDetail = _customFieldTypeDetail;

- (id) initWithDelegate:(NSObject<USHDownloadDelegate>*)delegate
               callback:(NSObject<UshahidiDelegate>*)callback
                    map:(USHMap *)map
                form_id:(NSString*)form_id
{
    NSMutableString *url = [[NSMutableString alloc]init];
    [url appendString:@"api?task=customforms&resp=xml&by=meta&formid="];
    [url appendString:form_id];
    NSLog(@"get detail for form_id : %@",url);
    return [super initWithDelegate:delegate
                          callback:callback
                               map:map
                               api:url];
    /*
    return [super initWithDelegate:delegate
                          callback:callback
                               map:map
                               api:@"api?task=customforms&resp=json&by=all"];
     */
}

- (void) downloadedJSON:(NSDictionary*)json {
    NSDictionary *payload = [json objectForKey:@"payload"];
    DLog(@"PAYLOAD FOR GET DETAIL: %@",payload);
}



- (void)dealloc {
    [_customFieldTypeDetail release];
    [super dealloc];
}
@end
