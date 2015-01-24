//
//  USHCategory.m
//  SDK
//
//  Created by Cristiano Carducci on 02/02/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import "USHCategoriesUtility.h"
#import "USHDatabase.h"
#import "CategoryTree.h"
#import "USHCategory.h"
#import "CustomFieldType.h"
#import "CustomFieldTypeDetail.h"

@class USHCategory;
@class CategoryTree;
@class CustomFieldType;
@class CustomFieldTypeDetail;

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(USHCategoriesUtility);


@implementation USHCategoriesUtility


SYNTHESIZE_SINGLETON_FOR_CLASS(USHCategoriesUtility);

- (id) init {
    if (self = [super init]){
        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

+ (NSMutableArray *) getCategories:(NSMutableArray *)flatCategory
              flatCategorySelected:(NSMutableDictionary *)flatCategorySelected
               flatOnlyCategoryYES:(NSMutableDictionary *)flatOnlyCategoryYES
{
    [flatCategory removeAllObjects];
    [flatCategorySelected removeAllObjects];
    [flatOnlyCategoryYES removeAllObjects];
    
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for (USHCategory *category in  [[USHDatabase sharedInstance] fetchArrayForName:@"Category" query:nil params:nil, nil])
    {
        
        CategoryTree *elementFlat = [[CategoryTree alloc] init];
        elementFlat.open = @"NO";
        elementFlat.selected = @"YES";
        elementFlat.title = category.title;    //self.category.title;
        elementFlat.parent_id =  category.parent_id;  //self.category.parent_id;
        elementFlat.id = category.identifier; // self.category.identifier;
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:category.identifier];
        elementFlat.indetifier = myNumber ;
        [flatCategory addObject:elementFlat];

        NSLog(@"------------------ RICARICO INIT ----------------------");
        NSLog(@"elementFlat.Title --> %@",elementFlat.title);
        NSLog(@"elementFlat.parent_id --> %@",elementFlat.parent_id);
        NSLog(@"elementFlat.id --> %@",elementFlat.indetifier);
        NSLog(@"elementFlat.selected --> %@",elementFlat.selected);
        [flatCategorySelected setValue:elementFlat.selected forKey:elementFlat.indetifier];
        NSString *value = [flatCategorySelected objectForKey:elementFlat.indetifier];
        NSLog(@"flatCategorySelected --> %@",value);
        [flatOnlyCategoryYES setValue:@"YES" forKey:elementFlat.id];
        NSLog(@"flatOnlyCategoryYES %@ --> %@",elementFlat.selected,elementFlat.id);
        NSLog(@"------------------ RICARICO END ----------------------");
        
        [categories addObject:category];
    }
    return categories;
}

+ (NSNumber *) getCustomFormType:(NSString *)title
{
    NSNumber *ret = [NSNumber numberWithInt:1];
    for (CustomFieldType *categoryForm in  [[USHDatabase sharedInstance] fetchArrayForName:@"CustomFieldType" query:nil params:nil, nil])
    {
        if ( [title.uppercaseString isEqualToString:categoryForm.title.uppercaseString] ){
            NSLog(@"getCustomFormType: %@ ", categoryForm.title);
            ret =[NSNumber numberWithInt:categoryForm.id.intValue];
            return ret;
        }
    }
    return ret;
}

+ (NSMutableArray *) getCustomFormDetailType
{
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    //for (CustomFieldTypeDetail *categoryForm in  [[USHDatabase sharedInstance] fetchArrayForName:@"CustomFieldTypeDetail" query:nil params:nil, nil])
    //for (CustomFieldTypeDetail *categoryForm in  [[USHDatabase sharedInstance] fetchArrayForName:@"CustomFieldTypeDetail" query:nil param:nil sort:@"name", nil])
    for (CustomFieldTypeDetail *categoryForm in  [[USHDatabase sharedInstance] fetchArrayForName:@"CustomFieldTypeDetail" query:nil param:nil sort:@"name", nil])
    {
        NSLog(@"getCustomFormDetailType: %@ ", categoryForm.name);
        [fields addObject:categoryForm];
    }
    return fields;
}


+ (NSString *) getCategoryTitleById:(NSNumber *)identifier
{
    NSLog(@"find for identifier: %@ ",identifier );
     for (USHCategory *category in  [[USHDatabase sharedInstance] fetchArrayForName:@"Category" query:nil params:nil, nil])
     {
         NSLog(@"category title: %@ - id_category: %@ - ext_identifier: %@",category.title , category.identifier , identifier);
         if ( [category.identifier intValue] == [identifier intValue])
         {
             NSLog(@"founded title: %@ - id: %@",category.title , category.identifier);
             return category.title;
         }
     }
    return 0;
}

@end
