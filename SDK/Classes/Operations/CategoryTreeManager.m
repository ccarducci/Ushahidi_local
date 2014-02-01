//
//  CategoryTreeManager.m
//  tree
//
//  Created by Cristiano Carducci on 17/01/13.
//  Copyright (c) 2013 Cristiano Carducci. All rights reserved.
//

#import "CategoryTreeManager.h"
#import "SBJsonWriter.h"
#import "CategoryTree.h"
#import "MDTreeNode.h"
#import "MDTreeNodeStore.h"
#import "MDTreeAddNodeStore.h"
#import <Ushahidi.h>
@implementation CategoryTreeManager: NSObject{
    
    
}

- (void) createTreeRecursive: (NSMutableArray*)elements elementTosearch:(NSString*)search nodoParente:(MDTreeNode *)parentNode
{
    //NSMutableDictionary *dictionary = [[Ushahidi sharedInstance] flatCategorySelected];
    for (int i = 0 ; i< elements.count;i++){
        CategoryTree *element = [elements objectAtIndex:i];
    
        if( [element.parent_id isEqualToString:search] ){

            MDTreeNode *newchild = [[MDTreeNodeStore sharedStore] createChildIn:parentNode ];
           
            @try{
                newchild.title = element.title;
                newchild.id = element.indetifier;
                NSLog(@"CHILD - newchild.title: %@",newchild.title);
                NSLog(@"CHILD - newchild.id: %@",newchild.id);
            }
            @catch(NSException *ex)
            {
                NSLog(@"index: Errore");
            }
            
        }
    }
    
}

- (void)createTree:(NSMutableArray*)elements{

    NSLog(@"title: %i",elements.count);
    //NSMutableDictionary *dictionary = [[Ushahidi sharedInstance] flatCategorySelected];

    for (int i = 0 ; i< elements.count;i++){
        CategoryTree *element = [elements objectAtIndex:i];
        
        if ( [element.parent_id  isEqualToString:@"0"]){
            @try{
                MDTreeNode *newNode = [[MDTreeNodeStore sharedStore] createNode];
                NSLog(@"MASTER - newNode.title: %@",element.title);
                NSLog(@"MASTER - newNode.id: %@",element.id);
                newNode.title = element.title;
                newNode.id = element.indetifier;
                                
                [self createTreeRecursive:(NSMutableArray*)elements elementTosearch:(NSString*)element.id
                              nodoParente:(MDTreeNode *)newNode];
                
            }
            @catch(NSException *ex)
            {
                NSLog(@"index: Errore");
            }
        }
    }
}


+ (NSString *)isReportAdd:(NSString*)categoryID searchtext:(NSString *)text titleReport:(NSString *)title{
   NSMutableDictionary *flatOnlyCategoryYES = [[Ushahidi sharedInstance] flatOnlyCategoryYES];
   NSString *value = [flatOnlyCategoryYES valueForKey:categoryID];
   //NSLog(@"key category %@ value: --> %@",categoryID,value);
   return value;
}


- (void) createTreeRecursiveAdd: (NSMutableArray*)elements elementTosearch:(NSString*)search nodoParente:(MDTreeAddNodeStore *)parentNode
{
    //NSMutableDictionary *dictionary = [[Ushahidi sharedInstance] flatCategorySelected];
    for (int i = 0 ; i< elements.count;i++){
        CategoryTree *element = [elements objectAtIndex:i];
        
        if( [element.parent_id isEqualToString:search] ){
            
            MDTreeNode *newchild = [[MDTreeAddNodeStore sharedStore] createChildIn:parentNode ];
            
            @try{
                newchild.title = element.title;
                newchild.id = element.indetifier;
                NSLog(@"CHILD - newchild.title: %@",newchild.title);
                NSLog(@"CHILD - newchild.id: %@",newchild.id);
            }
            @catch(NSException *ex)
            {
                NSLog(@"index: Errore");
            }
            
        }
    }
    
}

- (void)createTreeAdd:(NSMutableArray*)elements{
    
    NSLog(@"title: %i",elements.count);
    
    for (int i = 0 ; i< elements.count;i++){
        CategoryTree *element = [elements objectAtIndex:i];
        
        if ( [element.parent_id  isEqualToString:@"0"]){
            @try{
                MDTreeNode *newNode = [[MDTreeAddNodeStore sharedStore] createNode];
                NSLog(@"MASTER - newNode.title: %@",element.title);
                NSLog(@"MASTER - newNode.id: %@",element.id);
                newNode.title = element.title;
                newNode.id = element.indetifier;
                
                [self createTreeRecursiveAdd:(NSMutableArray*)elements elementTosearch:(NSString*)element.id
                              nodoParente:(MDTreeNode *)newNode];
                
            }
            @catch(NSException *ex)
            {
                NSLog(@"index: Errore");
            }
        }
    }
}

@end
