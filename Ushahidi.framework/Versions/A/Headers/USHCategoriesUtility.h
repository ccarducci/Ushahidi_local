//
//  USHCategory.h
//  SDK
//
//  Created by Cristiano Carducci on 02/02/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@class USHCategory;



@interface USHCategoriesUtility : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(USHCategoriesUtility);

+ (NSMutableArray *) getCategories:(NSMutableArray *)flatCategory
              flatCategorySelected:(NSMutableDictionary *)flatCategorySelected
               flatOnlyCategoryYES:(NSMutableDictionary *)flatOnlyCategoryYES;
+ (NSNumber *) getCustomFormType:(NSString *)title;
+ (NSString *) getCategoryTitleById:(NSNumber *)identifier;
+ (NSNumber *) getCustomFormDetailType;
@end
