//
//  MDTreeStore.h
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDTreeNode;

@interface MDTreeAddNodeStore : NSObject
{
    MDTreeNode *rootNode;
}

+ (MDTreeAddNodeStore *) sharedStore;

- (void)removeNode:(MDTreeNode *)n;
- (void)removeNodeWithChildren:(MDTreeNode *)n;
- (NSArray *)allNodes;
- (MDTreeNode *)createNode;
- (void)moveNodeAtRow:(int)from toRow:(int)to;
- (void)moveNodeAtRowWithChildren:(int)from toRow:(int)to;
- (MDTreeNode *)createChildIn:(MDTreeNode *)node;
- (MDTreeNode *)createChildIn:(MDTreeNode *)node
                   atPosition:(NSUInteger)position;
- (NSString *)nodesArchivePath;
- (BOOL)saveChanges;
- (void)removeAll;

@end
