//
//  USHDownloadCustomCategoryType.h
//  SDK
//
//  Created by Cristiano Carducci on 28/12/13.
//  Copyright (c) 2013 Ushahidi. All rights reserved.
//

#import <Ushahidi/Ushahidi.h>
#import "USHDownloadJSON.h"

@interface USHDownloadCustomCategoryType : USHDownloadJSON

- (id) initWithDelegate:(NSObject<USHDownloadDelegate>*)delegate
               callback:(NSObject<UshahidiDelegate>*)callback
                    map:(USHMap *)map;

@end
