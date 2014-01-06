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
#import "NSURL+USH.h"
#import "NSError+USH.h"
#import "NSString+USH.h"
#import "NSObject+USH.h"
#import "NSData+USH.h"
#import "SBJson.h"




@interface USHDownloadCustomCategoryTypeDetail ()

@property (nonatomic, strong, readwrite) CustomFieldTypeDetail *customFieldTypeDetail;
@property (nonatomic, strong, readwrite) USHMap *map;
@property (nonatomic, strong, readwrite) NSMutableData *response;
@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, strong) NSString *api;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong, readwrite) NSURL *domain;

@end


@implementation USHDownloadCustomCategoryTypeDetail

@synthesize customFieldTypeDetail = _customFieldTypeDetail;
@synthesize url = _url;
@synthesize api = _api;
@synthesize username = _username;
@synthesize password = _password;
@synthesize map = _map;
@synthesize domain = _domain;
@synthesize identifier = _identifier;

- (id) initWithDelegate:(USHMap*)map
                    api:(NSString*)api
               username:(NSString*)username
               password:(NSString*)password
             identifier:(NSString*)identifier
{
    if ((self = [super init])) {
        self.map = map;
        self.api = api;
        self.url = [NSURL URLWithString:[map.url stringByAppendingPathComponent:api]];
        self.domain = [self.url domainURL];
        self.username = map.username;
        self.password = map.password;
        self.identifier = identifier;
    }
    return self;
}

- (void)dealloc {
    [_customFieldTypeDetail release];
    [_url release];
    [_api release];
    [_username release];
    [_password release];
    [_map release];
    [_domain release];
    [_response release];
    [_identifier release];
    [super dealloc];
}

- (void)download {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    if ([NSString isNilOrEmpty:self.username] == NO &&
        [NSString isNilOrEmpty:self.password] == NO) {
        NSString *credentials = [NSString stringWithFormat:@"%@:%@", self.username, self.password];
        NSData *encoded = [credentials dataUsingEncoding:NSASCIIStringEncoding];
        NSString *base64 = [encoded base64EncodingWithLineLength:80];
        NSString *authorization = [NSString stringWithFormat:@"Basic %@", base64];
        [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    }
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self
                                                          startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];
    [connection release];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    DLog(@"%@ %@", self.class, self.url);
    if ([challenge previousFailureCount] == 0) {
        if ([NSString isNilOrEmpty:self.username] == NO &&
            [NSString isNilOrEmpty:self.password] == NO) {
            NSURLCredential *credentials = [NSURLCredential credentialWithUser:self.username
                                                                      password:self.password
                                                                   persistence:NSURLCredentialPersistenceForSession];
            [[challenge sender] useCredential:credentials forAuthenticationChallenge:challenge];
        }
        else {
            NSError *error = [NSError errorWithDomain:self.map.url
                                                 code:NSURLErrorUserAuthenticationRequired
                                              message:NSLocalizedString(@"User Authentication Required", nil)];
        }
    }
    else {
        DLog(@"Previous authentication failure");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    DLog(@"%@ %@", self.class, self.url);
    self.response = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.response appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    DLog(@"%@ %@ Error:%@", self.class, self.url, [error description]);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    DLog(@"%@ %@", self.class, self.url);
    NSString *string = [NSString utf8StringFromData:self.response];
    NSError *error = nil;
    if (string != nil && string.length > 0) {
        NSDictionary *json = [string JSONValue];
        if (json != nil) {
            //DLog(@"JSON:%@", json);
            [self downloadedJSON:json];
        }
        else {
            DLog(@"JSON NULL:%@", string);
            error = [NSError errorWithDomain:self.map.url code:NSURLErrorCannotParseResponse message:NSLocalizedString(@"API URL Invalid", nil)];
        }
    }
    else {
        DLog(@"Response NULL:%@", string);
        error = [NSError errorWithDomain:self.map.url code:NSURLErrorBadServerResponse message:NSLocalizedString(@"Bad Server Response", nil)];
    }
}


- (void) downloadedJSON:(NSDictionary*)json {
    NSDictionary *payload = [json objectForKey:@"payload"];
    NSDictionary *customforms = [payload objectForKey:@"customforms"];
    NSArray *fields = [customforms objectForKey:@"fields"];
    
    DLog(@"---------------------------------------------------------------------------------------------------------------------------");
    DLog(@"XXXXXX self.identifier %@ :%@", self.identifier,fields);
    for (NSDictionary *item in fields) {
        if (item != nil) {
            
            NSDictionary *meta = [item objectForKey:@"meta"];
            NSString *identifierField = [meta stringForKey:@"id"];;
            
            
            

        }
    }
    DLog(@"---------------------------------------------------------------------------------------------------------------------------");
}

@end
