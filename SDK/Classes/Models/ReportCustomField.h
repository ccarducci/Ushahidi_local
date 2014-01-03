//
//  ReportCustomField.h
//  SDK
//
//  Created by Cristiano Carducci on 03/01/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReportCustomField : NSManagedObject

@property (nonatomic, retain) NSString * defaultvalue;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isdate;
@property (nonatomic, retain) NSNumber * ispublicsubmit;
@property (nonatomic, retain) NSNumber * ispublicvisible;
@property (nonatomic, retain) NSNumber * maxlen;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * required;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * identifierField;

@end
