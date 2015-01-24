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
#import "USHCategory.h"
#import "MDTreeNode.h"
#import "MDTreeNodeStore.h"
#import "MDTreeAddNodeStore.h"
#import <Ushahidi.h>
#import "USHDatabase.h"
#import "CustomFieldType.h"
#import "USHCategoriesUtility.h"
#import "USHCategoriesUtility.h"

@implementation CategoryTreeManager: NSObject{
    
    
}

- (void)createTree:(NSMutableArray*)elements{
    NSLog(@"------------- createTree BEGIN");
    NSLog(@"title: %i",elements.count);
    
    for (int i = 0 ; i< elements.count;i++){
        CategoryTree *element = [elements objectAtIndex:i];
        
        if ( [element.parent_id  isEqualToString:@"0"]){
            @try{
                MDTreeNode *newNode = [[MDTreeNodeStore sharedStore] createNode];

                newNode.title = element.title;
                newNode.id = element.indetifier;
                newNode.parent_root = newNode.id;
                NSLog(@"-----------");
                NSLog(@"MASTER - newNode.title: %@",newNode.title);
                NSLog(@"MASTER - newNode.id: %@",newNode.id);
                NSLog(@"MASTER - newNode.parent_root: %@",newNode.parent_root);
                [self createTreeRecursive:(NSMutableArray*)elements elementTosearch:(NSString*)element.id
                              nodoParente:(MDTreeNode *)newNode];
                NSLog(@"-----------");
            }
            @catch(NSException *ex)
            {
                NSLog(@"index: Errore");
            }
        }
    }
    NSLog(@"------------- createTree END");
}

- (void)createTreeAdd:(NSMutableArray*)elements{
    NSLog(@"------------- createTree BEGIN");
    NSLog(@"title: %i",elements.count);

    for (int i = 0 ; i< elements.count;i++){
        CategoryTree *element = [elements objectAtIndex:i];
        
        if ( [element.parent_id  isEqualToString:@"0"]){
            @try{
                MDTreeNode *newNode = [[MDTreeAddNodeStore sharedStore] createNode];
                newNode.title = element.title;
                newNode.id = element.indetifier;
                newNode.parent_root = newNode.id;
                NSLog(@"-----------");
                NSLog(@"MASTER - newNode.title: %@",newNode.title);
                NSLog(@"MASTER - newNode.id: %@",newNode.id);
                NSLog(@"MASTER - newNode.parent_root: %@",newNode.parent_root);
                NSNumber *form_id = [self getFormId:element.title parent_id_root:newNode.parent_root];
                newNode.form_id = form_id;

                NSLog(@"MASTER - newNodeform_id: %@",newNode.form_id);
                [self createTreeRecursiveAdd:(NSMutableArray*)elements elementTosearch:(NSString*)element.id
                                 nodoParente:(MDTreeNode *)newNode];
                NSLog(@"-----------");
                
            }
            @catch(NSException *ex)
            {
                NSLog(@"index: Errore");
            }
        }
    }
    NSLog(@"------------- createTree END");
}

+ (NSString *)isReportAdd:(NSString*)categoryID searchtext:(NSString *)text titleReport:(NSString *)title{
    NSMutableDictionary *flatOnlyCategoryYES = [[Ushahidi sharedInstance] flatOnlyCategoryYES];
    NSString *value = [flatOnlyCategoryYES valueForKey:categoryID];
    return value;
}

- (void) createTreeRecursive: (NSMutableArray*)elements elementTosearch:(NSString*)search nodoParente:(MDTreeNode *)parentNode
{
    for (int i = 0 ; i< elements.count;i++){
        CategoryTree *element = [elements objectAtIndex:i];
    
        if( [element.parent_id isEqualToString:search] ){

            MDTreeNode *newchild = [[MDTreeNodeStore sharedStore] createChildIn:parentNode ];
           
            @try{
                newchild.title = element.title;
                newchild.id = element.indetifier;
                newchild.parent_root = parentNode.parent_root;
                NSLog(@"------");
                NSLog(@"CHILD - newchild.title: %@",newchild.title);
                NSLog(@"CHILD - newchild.id: %@",newchild.id);
                NSLog(@"CHILD - newchild.parent_root: %@",newchild.parent_root);
                NSLog(@"------");
            }
            @catch(NSException *ex)
            {
                NSLog(@"index: Errore");
            }
            
        }
    }
    
}

- (void) createTreeRecursiveAdd: (NSMutableArray*)elements elementTosearch:(NSString*)search nodoParente:(MDTreeNode *)parentNode
{

    for (int i = 0 ; i< elements.count;i++){
        CategoryTree *element = [elements objectAtIndex:i];
        
        if( [element.parent_id isEqualToString:search] ){
            
            MDTreeNode *newchild = [[MDTreeAddNodeStore sharedStore] createChildIn:parentNode ];
            
            @try{
                newchild.title = element.title;
                newchild.id = element.indetifier;
                newchild.parent_root = parentNode.parent_root;
                NSNumber *form_id = [self getFormId:element.title parent_id_root:parentNode.id];
                newchild.form_id = form_id;
                NSLog(@"------");
                NSLog(@"CHILD - newchild.title: %@",newchild.title);
                NSLog(@"CHILD - newchild.id: %@",newchild.id);
                NSLog(@"CHILD - newchild.parent_root: %@",newchild.parent_root);
                NSLog(@"CHILD - newchild.form_id: %@",form_id);
                NSLog(@"------");
            }
            @catch(NSException *ex)
            {
                NSLog(@"index: Errore");
            }
            
        }
    }
}

- (NSNumber*) getFormId:(NSString *)title_node parent_id_root:(NSNumber*)parent_id_root
{
    NSNumber *form_id = [NSNumber numberWithInt:0];
    NSLog(@"serach begin --------------------------------------------------------------------");
    NSLog(@"title to serach: %@ - parent_id_root: %@" , title_node,parent_id_root);
    form_id = [USHCategoriesUtility getCustomFormType:title_node];
    NSLog(@"found form_id: %@" , form_id);
    if ( [form_id intValue] == 1 ){
        NSLog(@"search form_id by parent_id_root: %@" , parent_id_root);
        NSString *title_parent_id =[USHCategoriesUtility getCategoryTitleById:parent_id_root];
        NSLog(@"getCategoryTitleById: %@" , title_parent_id);
        form_id = [USHCategoriesUtility getCustomFormType:title_parent_id];
        NSLog(@"found form_id with parent_id_root: %@" , form_id);
        return  form_id;
    }
    NSLog(@"serach end --------------------------------------------------------------------");
    return form_id;
}

@end
