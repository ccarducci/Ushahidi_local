//
//  USHFieldItem.h
//  App
//
//  Created by Cristiano Carducci on 21/05/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USHFieldItem : NSObject

@property (nonatomic, retain) NSString * defaultvalue;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * identifierField;
@property (nonatomic, retain) NSNumber * isdate;
@property (nonatomic, retain) NSNumber * maxlen;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * required;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * value;

@end
