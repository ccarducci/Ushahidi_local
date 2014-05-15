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

@interface USHCustomFormAddViewController : USHTableViewController

@property (strong, nonatomic) MDTreeNode *item;
@property (strong, nonatomic) NSMutableArray *fields;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *Back;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *Reset;

@property (retain, nonatomic) IBOutlet USHFieldViewController *fieldValueSelectorController;
@property (retain, nonatomic) IBOutlet USHCustomFieldSingleViewController *fieldSingleValueSelectorController;



- (IBAction)ResetEv:(id)sender;
- (IBAction)BackEv:(id)sender;

@end
