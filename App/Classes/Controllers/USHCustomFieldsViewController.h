//
//  USHCustomFieldsViewController.h
//  App
//
//  Created by Cristiano Carducci on 03/01/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USHCustomFieldsViewController : UITableViewController

@property (strong, nonatomic) NSString *report_id;
@property (nonatomic, retain) NSArray *booksArray;
@property (nonatomic, retain) NSArray *CustomFields;
@end
