//
//  CustomFieldType.h
//  SDK
//
//  Created by Cristiano Carducci on 28/12/13.
//  Copyright (c) 2013 Ushahidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CustomFieldType : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSString * title;

@end
