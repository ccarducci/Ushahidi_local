//
//  USHCustomFieldViewController.h
//  App
//
//  Created by Cristiano Carducci on 10/05/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Ushahidi/CustomFieldTypeDetail.h>



@interface USHCustomFieldViewController : UITableViewController

@property (nonatomic, copy) NSMutableArray *recipes;
@property (strong, nonatomic) CustomFieldTypeDetail *field;


@property (retain, nonatomic) IBOutlet UIBarButtonItem *reset;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *done;



- (IBAction)ResetEv:(id)sender;
- (IBAction)DoneEv:(id)sender;


@end
