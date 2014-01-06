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



@interface USHDownloadCustomCategoryTypeDetail : USHDownloadJSON


@property (nonatomic, strong, readonly) CustomFieldTypeDetail *CustomFieldTypeDetail;

- (id) initWithDelegate:(NSObject<USHDownloadDelegate>*)delegate
               callback:(NSObject<UshahidiDelegate>*)callback
                    map:(USHMap *)map;

@end
