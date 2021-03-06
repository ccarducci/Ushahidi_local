//
//  USHDownloadIncidentCustomFields.m
//  SDK
//
//  Created by Cristiano Carducci on 30/12/13.
//  Copyright (c) 2013 Ushahidi. All rights reserved.
//

#import "USHDownloadIncidentCustomFields.h"
#import "USHDowloadCustomField.h"
#import "USHDatabase.h"
#import "Ushahidi.h"
#import "USHMap.h"
#import "NSURL+USH.h"
#import "NSError+USH.h"
#import "NSString+USH.h"
#import "NSObject+USH.h"
#import "NSData+USH.h"
#import "SBJson.h"


@interface USHDownloadIncidentCustomFields ()

@property (nonatomic, strong, readwrite) NSObject<USHDownloadDelegate> *delegate;
@property (nonatomic, strong, readwrite) NSObject<UshahidiDelegate> *callback;
@property (nonatomic, strong, readwrite) USHMap *map;

@property (nonatomic, strong, readwrite) NSMutableData *response;
@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, strong, readwrite) NSURL *domain;

@property (nonatomic, strong) NSString *api;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation USHDownloadIncidentCustomFields

@synthesize delegate = _delegate;
@synthesize callback = _callback;
@synthesize api = _api;
@synthesize map = _map;
@synthesize response = _response;
@synthesize url = _url;
@synthesize domain = _domain;
@synthesize username = _username;
@synthesize password = _password;

@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;


- (id) initWithDelegate:(NSObject<USHDownloadDelegate>*)delegate
               callback:(NSObject<UshahidiDelegate>*)callback
                    map:(USHMap*)map
                    api:(NSString*)api {
    if ((self = [super init])) {
        self.delegate = delegate;
        self.callback = callback;
        self.map = map;
        self.api = api;
        self.url = [NSURL URLWithString:[map.url stringByAppendingPathComponent:api]];
        self.domain = [self.url domainURL];
        self.username = map.username;
        self.password = map.password;
    }
    return self;
}

- (id) initWithDelegate:(NSObject<USHDownloadDelegate>*)delegate
               callback:(NSObject<UshahidiDelegate>*)callback
                    url:(NSString*)url {
    if ([super init]) {
        self.delegate = delegate;
        self.callback = callback;
        self.url = [NSURL URLWithString:url];
        self.domain = [self.url domainURL];
        DLog(@"Domain:%@ URL:%@ ", self.domain, self.url);
    }
    return self;
}

- (void)dealloc {
    DLog(@"%@ %@", self.class, self.url);
    [_delegate release];
    [_callback release];
    [_api release];
    [_map release];
    [_url release];
    [_domain release];
    [_response release];
    [_username release];
    [_password release];
    [super dealloc];
}

- (BOOL) isConcurrent {
    return YES;
}

- (void)start {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
        return;
    }
    DLog(@"%@ %@", self.class, self.url);
    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self.delegate performSelectorOnMainThread:@selector(download:started:)
                                 waitUntilDone:YES
                                   withObjects:self, self.map, nil];
    
    DLog(@"get customfields for incident begin");

    NSInteger countCategorie = self.map.reportsSortedByDate.count;
    DLog(@"get customfields reportsSortedByDate count %i",countCategorie);
    NSManagedObjectContext *context = [[USHDatabase sharedInstance] managedObjectContext];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:@"Report" inManagedObjectContext:context]];
    NSArray *result =  [context executeFetchRequest:request  error:nil];
    for (USHReport *item in result) {
        DLog(@"item.pending %@",[item.pending stringValue]);
        if ( [[item.pending stringValue] isEqualToString:@"0"]){
            
            DLog(@"not get customfields for this incident pending: %@", item.title);
        }else{
            DLog(@"get customfields for this incident: %@", item.title);
            NSString *query =[@"api?task=customforms&resp=json&by=fields&id="  stringByAppendingString:item.identifier];
            
            DLog(@"query %@",query);
            
            USHDowloadCustomField *downCustomField = [[USHDowloadCustomField alloc]initWithDelegate:self.map
                                                                                  api:query
                                                                             username:self.username
                                                                             password:self.password
                                                                           identifier:item.identifier];
            [downCustomField download];
            [downCustomField release];
        }
    }
    DLog(@"get customfields executeFetchRequest count %i",result.count);
    DLog(@"get customfields for incident end");
    [self finish];
}

- (void) finish {
    DLog(@"%@ %@", self.class, self.url);
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
