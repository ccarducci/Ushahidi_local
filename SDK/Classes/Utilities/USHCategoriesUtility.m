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
@class USHCategory;
@class CategoryTree;

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


@end
