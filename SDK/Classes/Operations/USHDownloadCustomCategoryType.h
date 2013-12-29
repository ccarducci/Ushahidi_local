//
//  USHDownloadCustomCategoryType.h
//  SDK
//
//  Created by Cristiano Carducci on 28/12/13.
//  Copyright (c) 2013 Ushahidi. All rights reserved.
//

#import <Ushahidi/Ushahidi.h>
#import "USHDownloadJSON.h"

@class CustomFieldType;

@interface USHDownloadCustomCategoryType : USHDownloadJSON

@property (nonatomic, strong, readonly) CustomFieldType *customFieldType;

- (id) initWithDelegate:(NSObject<USHDownloadDelegate>*)delegate
               callback:(NSObject<UshahidiDelegate>*)callback
                    map:(USHMap *)map;

@end
