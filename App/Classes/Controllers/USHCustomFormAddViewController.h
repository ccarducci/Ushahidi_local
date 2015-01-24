//
//  USHCustomFormAddViewController.h
//  App
//
//  Created by Cristiano Carducci on 12/05/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import <Ushahidi/Ushahidi.h>
#import <Ushahidi/USHTableViewController.h>
#import <Ushahidi/MDTreeNode.h>
#import "USHFieldViewController.h"
#import "USHCustomFieldSingleViewController.h"
#import "USHFieldItem.h"
#import "MDTreeAddViewController.h"


@class USHReport;

@interface USHCustomFormAddViewController : USHTableViewController


@property (retain, nonatomic) IBOutlet UIBarButtonItem *Back;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *Reset;

@property (retain, nonatomic) IBOutlet USHFieldViewController *fieldValueSelectorController;
@property (retain, nonatomic) IBOutlet USHCustomFieldSingleViewController *fieldSingleValueSelectorController;



- (IBAction)ResetEv:(id)sender;
- (IBAction)BackEv:(id)sender;

@property (retain, nonatomic) MDTreeNode *item;
@property (retain, nonatomic) NSMutableArray *reportCustomFields;
@property (retain, nonatomic) NSMutableArray *fields;
@property (strong, nonatomic) USHReport *report;
@property (strong, nonatomic) MDTreeNode *itemCategory;

@end
