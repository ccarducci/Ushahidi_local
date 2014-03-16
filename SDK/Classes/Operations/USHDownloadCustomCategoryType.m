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
#import "CustomFieldType.h"
#import "USHDownloadCustomCategoryTypeDetail.h"

@interface USHDownloadCustomCategoryType ()

@property (nonatomic, strong, readwrite) CustomFieldType *customFieldType;

@end


@implementation USHDownloadCustomCategoryType
@synthesize customFieldType = _customFieldType;

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
    NSArray *customforms = [payload objectForKey:@"customforms"];
    DLog(@"----------------------------------------------------------------------------------------");
    for (NSDictionary *item in customforms) {
        NSString *description = [item stringForKey:@"description"];
        NSString *title = [item stringForKey:@"title"];
        NSString *identifier = [item stringForKey:@"id"];
        DLog(@"id:  %@ - title: %@ - description: %@",identifier,title,description);

        self.customFieldType = (CustomFieldType*)[[USHDatabase sharedInstance] fetchOrInsertItemForName:@"CustomFieldType"
                                                                                       query:@"id = %@"
                                                                                      params:[item stringForKey:@"id"], nil];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:identifier];
        [f release];
        self.customFieldType.id = myNumber;
        self.customFieldType.title = title;
        self.customFieldType.descr =description;

        [[USHDatabase sharedInstance] saveChanges];

        
        NSMutableString *downCustomFieldDetailUrl = [[NSMutableString alloc]init];
        
        [downCustomFieldDetailUrl appendString:@"api?task=customforms&resp=json&by=meta&formid="];
        [downCustomFieldDetailUrl appendString:identifier];
        USHDownloadCustomCategoryTypeDetail *downCustomFieldDetail = [[USHDownloadCustomCategoryTypeDetail alloc]
                                                                               initWithDelegate:self.map
                                                                                            api:downCustomFieldDetailUrl
                                                                                       username:self.map.username
                                                                                       password:self.map.password
                                                                                     identifier:identifier];
        [downCustomFieldDetail download];
        [downCustomFieldDetail release];
        
    }
    DLog(@"----------------------------------------------------------------------------------------");
}

- (void)dealloc {
    [_customFieldType release];
    [super dealloc];
}

@end
