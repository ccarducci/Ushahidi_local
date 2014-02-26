//
//  USHCustomFieldTypeDetail.m
//  SDK
//
//  Created by Cristiano Carducci on 03/02/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import "USHCustomFieldTypeDetail.h"


@implementation USHCustomFieldTypeDetail


@synthesize identifier = _identifier;
@synthesize name = _name;
@synthesize value = _value;
@synthesize type = _type;



- (id) init {
	if ((self = [super init])) {
		self.identifier = @"";
		self.name=@"";
		self.value = @"";
        self.type = -1;
	}
	return self;
}

@end
