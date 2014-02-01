//
//  MDTreeNode.h
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDTreeNode : NSObject <NSCoding>

@property (copy) NSString *title;
@property (strong) NSMutableArray *children;
@property (retain) MDTreeNode *parent; // weak
@property (assign) BOOL isExpanded;
@property (assign) NSNumber *id;
@property (assign) NSString *identifier;

- (NSArray *)flatten;

@end
