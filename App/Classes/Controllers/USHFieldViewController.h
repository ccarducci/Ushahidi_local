//
//  USHFieldViewController.h
//  App
//
//  Created by Cristiano Carducci on 13/05/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import <Ushahidi/Ushahidi.h>
#import <Ushahidi/USHTableViewController.h>
#import <Ushahidi/CustomFieldTypeDetail.h>
#import "USHTableCellFactory.h"

@interface USHFieldViewController : USHTableViewController<USHCustomCheckBoxTableCellDelegate,USHCustomComboBoxTableCellDelegate,USHCustomOptionBoxTableCellDelegate>

@property (retain, nonatomic) CustomFieldTypeDetail *field;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *Back;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *Reset;

@property (retain, nonatomic) NSMutableArray *selected;

- (IBAction)BackEv:(id)sender;
- (IBAction)ResetEv:(id)sender;

@end
