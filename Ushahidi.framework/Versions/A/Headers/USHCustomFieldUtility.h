//
//  USHCustomFieldUtility.h
//  SDK
//
//  Created by Cristiano Carducci on 03/01/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "ReportCustomField.h"

@interface USHCustomFieldUtility : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(USHCustomFieldUtility);


+ (ReportCustomField *) getCustomFields:(NSString*)identifier;

@end
