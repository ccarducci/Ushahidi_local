//
//  USHDownloadCustomCategoryTypeDetail.h
//  SDK
//
//  Created by Cristiano Carducci on 05/01/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USHDownloadJSON.h"
#import "CustomFieldTypeDetail.h"

@class USHMap;

@interface USHDownloadCustomCategoryTypeDetail : NSObject<NSURLConnectionDelegate>


@property (nonatomic, strong, readonly) CustomFieldTypeDetail *CustomFieldTypeDetail;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSString *api;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *password;
@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) USHMap *map;
@property (nonatomic, strong, readonly) NSURL *domain;

- (void) download;


- (id) initWithDelegate:(USHMap*)map
                    api:(NSString*)api
               username:(NSString*)username
               password:(NSString*)password
             identifier:(NSString*)identifier;

- (void) downloadedJSON:(NSDictionary*)json;

@end
