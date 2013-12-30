//
//  USHDownloadIncidentCustomFields.h
//  SDK
//
//  Created by Cristiano Carducci on 30/12/13.
//  Copyright (c) 2013 Ushahidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class USHMap;
@protocol UshahidiDelegate;
@protocol USHDownloadDelegate;

@interface USHDownloadIncidentCustomFields : NSO    peration<NSURLConnectionDelegate>

@property (nonatomic, strong, readonly) NSObject<USHDownloadDelegate> *delegate;
@property (nonatomic, strong, readonly) NSObject<UshahidiDelegate> *callback;
@property (nonatomic, strong, readonly) USHMap *map;
@property (nonatomic, strong, readonly) NSMutableData *response;

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSURL *domain;

@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;

- (id) initWithDelegate:(NSObject<USHDownloadDelegate>*)delegate
               callback:(NSObject<UshahidiDelegate>*)callback
                    url:(NSString*)url;

- (id) initWithDelegate:(NSObject<USHDownloadDelegate>*)delegate
               callback:(NSObject<UshahidiDelegate>*)callback
                    map:(USHMap*)map
                    api:(NSString*)api;

- (void) start;
- (void) finish;

@end


