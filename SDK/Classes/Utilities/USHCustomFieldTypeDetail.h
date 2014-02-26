//
//  USHCustomFieldTypeDetail.h
//  SDK
//
//  Created by Cristiano Carducci on 03/02/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USHCustomFieldTypeDetail : NSObject


@property(nonatomic, retain) NSString *identifier;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *value;
@property(nonatomic) NSInteger *type;


@end
