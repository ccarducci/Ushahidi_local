//
//  MDTreeNode.m
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import "MDTreeNode.h"

@implementation MDTreeNode

- (id)init
{
    self = [super init];
    if (self)
    {
        _title = @"New Item";
        _isExpanded = NO;
        _children = [NSMutableArray array];
        _parent = nil;
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setChildren:[aDecoder decodeObjectForKey:@"children"]];
        for (MDTreeNode *child in _children)
            [child setParent:self];
        [self setIsExpanded:[aDecoder decodeBoolForKey:@"isExpanded"]];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_children forKey:@"children"];
    [aCoder encodeBool:_isExpanded forKey:@"isExpanded"];
}

- (NSString *)description
{
    return _title;
}

- (NSArray *)flatten
{
    NSMutableArray *result = [NSMutableArray array];
    for (MDTreeNode *node in _children)
    {
        [result addObject:node];
        if ([node isExpanded])
            [result addObjectsFromArray:[node flatten]];
    }

    return result;
}

@end
