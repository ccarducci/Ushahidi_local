//
//  USHDownloadCustomCategoryType.m
//  SDK
//
//  Created by Cristiano Carducci on 28/12/13.
//  Copyright (c) 2013 Ushahidi. All rights reserved.
//

#import "USHDownloadCustomCategoryType.h"


#import "NSDictionary+USH.h"
#import "NSObject+USH.h"
#import "Ushahidi.h"
#import "USHDatabase.h"


@implementation USHDownloadCustomCategoryType


- (id) initWithDelegate:(NSObject<USHDownloadDelegate>*)delegate
               callback:(NSObject<UshahidiDelegate>*)callback
                    map:(USHMap *)map {
    return [super initWithDelegate:delegate
                          callback:callback
                               map:map
                               api:@"api?task=customforms&resp=json&by=all"];
}

- (void) downloadedJSON:(NSDictionary*)json {
    
    NSDictionary *payload = [json objectForKey:@"payload"];

    DLog(@"----------------------------------------------------------------------------------------");
    DLog(@"%@", payload);
    DLog(@"----------------------------------------------------------------------------------------");
}

- (void)dealloc {
    [super dealloc];
}

@end
