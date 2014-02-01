//
//  CategoryTreeManager.h
//  tree
//
//  Created by Cristiano Carducci on 17/01/13.
//  Copyright (c) 2013 Cristiano Carducci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDTreeNode.h"

@interface CategoryTreeManager : NSObject

- (void)createTree:(NSMutableArray*)elements;

- (void) createTreeRecursive: (NSMutableArray*)elements elementTosearch:(NSString*)search nodoParente:(MDTreeNode *)parentNode;

+ (NSString *)isReportAdd:(NSString*)cstegory_id searchtext:(NSString *)text titleReport:(NSString *)title;

- (void)createTreeAdd:(NSMutableArray*)elements;

- (void) createTreeRecursiveAdd: (NSMutableArray*)elements elementTosearch:(NSString*)search nodoParente:(MDTreeNode *)parentNode;

@end
