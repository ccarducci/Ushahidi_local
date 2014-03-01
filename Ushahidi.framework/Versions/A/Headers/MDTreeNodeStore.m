//
//  MDTreeStore.m
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import "MDTreeNodeStore.h"
#import "MDTreeNode.h"

@implementation MDTreeNodeStore

+ (MDTreeNodeStore *)sharedStore
{
    static MDTreeNodeStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];

    return sharedStore;
}

- (void)removeAll{
    if (rootNode)
        rootNode = [MDTreeNode new];
}

/** Enforcing Singleton pattern here as allocWithZone is called by alloc */
+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *path = [self nodesArchivePath];
        rootNode = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

        if (!rootNode)
            rootNode = [MDTreeNode new];
    }
    
    return self;
}

- (void)removeNode:(MDTreeNode *)n
{
    MDTreeNode *parent = [n parent];

    // prevent deletion of the rootNode
    NSAssert(parent, @"MDTreeNodeStore's -removeItem: there was an attempt to \
             remove the root node");

    NSMutableArray *parentsChildren = [parent children];
    NSUInteger nodesIndexInParent =
        [parentsChildren indexOfObjectIdenticalTo:n];
    [parentsChildren removeObjectIdenticalTo:n];
    NSArray *childrenToReparent = [n children];
    __block NSMutableIndexSet *newIndexesOfChildrenToReparent =
        [NSMutableIndexSet indexSet];

    [childrenToReparent enumerateObjectsUsingBlock:^(id obj,
                                                     NSUInteger idx,
                                                     BOOL *stop)
    {
        [newIndexesOfChildrenToReparent addIndex:(nodesIndexInParent + idx)];

        [obj setParent:parent];
    }];

    [parentsChildren insertObjects:childrenToReparent
                         atIndexes:newIndexesOfChildrenToReparent];
}

- (void)removeNodeWithChildren:(MDTreeNode *)n
{
    MDTreeNode *parent = [n parent];

    // prevent deletion of the rootNode
    NSAssert(parent, @"MDTreeNodeStore's -removeItem: there was an attempt to \
             remove the root node");

    NSMutableArray *parentsChildren = [parent children];
    [parentsChildren removeObjectIdenticalTo:n];
    n = nil;
}

- (NSArray *)allNodes
{
    return [rootNode flatten];
}

- (NSArray *)allNodesVisible
{
    return [rootNode flattenVisible];
}

- (MDTreeNode *)createNode
{
    MDTreeNode *n = [MDTreeNode new];

    [n setParent:rootNode];
    [[rootNode children] insertObject:n atIndex:0];

    return n;
}

- (MDTreeNode *)createChildIn:(MDTreeNode *)node
{
    MDTreeNode *newChild = [self createChildIn:node atPosition:0];
    return newChild;
}

- (MDTreeNode *)createChildIn:(MDTreeNode *)node
                   atPosition:(NSUInteger)position
{
    MDTreeNode *newChild = [MDTreeNode new];

    [newChild setParent:node];

    NSLog(@"-createChildIn invoked to create at position %d in array of size \%d", position, [[node children] count]);
    NSMutableArray *children = [node children];
    if ([children count] < position)
        [children addObject:newChild];
    else
        [children insertObject:newChild atIndex:position];

    return newChild;
}

- (void)moveNodeAtRow:(int)from toRow:(int)to
{
    if (from == to)
        return;

    NSLog(@"-moveItemAtRow invoked to move from row %d to row %d", from, to);
    NSArray *items = [self allNodes];
    MDTreeNode *oldNode = [items objectAtIndex:from];
    MDTreeNode *targetNode =
        [items count] > to ? [items objectAtIndex:to] : nil;

    NSString *title = [oldNode title];
    MDTreeNode *newParent = targetNode ? [targetNode parent] : rootNode;
    if (newParent == oldNode)
        newParent = rootNode;
    
    NSUInteger newParentRow =
        newParent == rootNode ? 0 : [items indexOfObjectIdenticalTo:newParent];
    NSLog(@"-moveItemAtRow: newParentRow is %d and newParent has %d children",
          newParentRow, [[newParent children] count]);
        
    [self removeNode:oldNode];

    int childCount = [[newParent children] count];
    int positionToPut = (to - newParentRow);

    NSLog(@"-moveItemAtRow: local index is %d, the index of the last child is %d",
          positionToPut, childCount - 1);

    [[self createChildIn:newParent
              atPosition:(positionToPut > childCount ?
                            childCount :
                            positionToPut)]
                setTitle:title];
}

- (void)moveNodeAtRowWithChildren:(int)from toRow:(int)to
{
    if (from == to)
        return;

    NSLog(@"-moveItemAtRow invoked to move from row %d to row %d", from, to);
    NSArray *items = [self allNodes];
    MDTreeNode *node = [items objectAtIndex:from];

    MDTreeNode *oldParent = [node parent];
    NSMutableArray *oldParentsChildren = [oldParent children];
    [oldParentsChildren removeObjectIdenticalTo:node];

    MDTreeNode *targetNode =
    [items count] > to ? [items objectAtIndex:to] : nil;

    MDTreeNode *newParent = targetNode ? [targetNode parent] : rootNode;
    if (newParent == node)
        newParent = rootNode;

    NSMutableArray *newParentsChildren = [newParent children];
    NSUInteger newParentRow =
        newParent == rootNode ? 0 : [items indexOfObjectIdenticalTo:newParent];

    int childCount = [newParentsChildren count];
    NSLog(@"-moveItemAtRow: newParentRow is %d and newParent has %d children",
          newParentRow, childCount);

    int positionToPut = (to - newParentRow);

    NSLog(@"-moveItemAtRow: local index is %d, the index of the last child is %d",
          positionToPut, childCount - 1);

    [newParentsChildren insertObject:node atIndex:(positionToPut > childCount ?
                                                        childCount :
                                                        positionToPut)];
    [node setParent:newParent];
}

- (NSString *)nodesArchivePath
{
    NSArray *documentDirectories =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                            NSUserDomainMask, YES);

    NSString *documentDirectory = [documentDirectories objectAtIndex:0];

    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self nodesArchivePath];

    return [NSKeyedArchiver archiveRootObject:rootNode toFile:path];
}


@end
