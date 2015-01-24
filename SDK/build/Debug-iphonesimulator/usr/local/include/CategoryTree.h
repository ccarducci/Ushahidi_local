//
//  USHCategory.h
//  tree
//
//  Created by Cristiano Carducci on 20/01/13.
//  Copyright (c) 2013 Cristiano Carducci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryTree: NSObject {
    NSString *selected;
    NSString *open;
    NSNumber *position;
    NSString *title;
    NSString *parent_id;
    NSString *id;
    NSNumber *indetifier;
}

@property (nonatomic, retain) NSString *selected;
@property (nonatomic, retain) NSString *open;
@property (nonatomic, retain) NSNumber *position;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *parent_id;
@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSNumber *indetifier;

@end
