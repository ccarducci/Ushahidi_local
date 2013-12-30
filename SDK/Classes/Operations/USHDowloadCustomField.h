//
//  USHDowloadCustomField.h
//  SDK
//
//  Created by Cristiano Carducci on 30/12/13.
//  Copyright (c) 2013 Ushahidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class USHMap;

@interface USHDowloadCustomField : NSObject<NSURLConnectionDelegate>

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSString *api;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *password;
@property (nonatomic, strong, readonly) USHMap *map;
@property (nonatomic, strong, readonly) NSURL *domain;

- (void) download;


- (id) initWithDelegate:(USHMap*)map
                    api:(NSString*)api
               username:(NSString*)username
               password:(NSString*)password;

- (void) downloadedJSON:(NSDictionary*)json;

@end
