//
//  USHCategory.m
//  tree
//
//  Created by Cristiano Carducci on 20/01/13.
//  Copyright (c) 2013 Cristiano Carducci. All rights reserved.
//

#import "CategoryTree.h"

@implementation CategoryTree


@synthesize  selected;
@synthesize  open;
@synthesize  position;
@synthesize  title;
@synthesize  parent_id;
@synthesize  id;
@synthesize  indetifier;

- (id) init {
    return self;
}

- (void) dealloc {
    [super dealloc];
}
@end
