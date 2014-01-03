//
//  USHCustomFieldsViewController.m
//  App
//
//  Created by Cristiano Carducci on 03/01/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import "USHCustomFieldsViewController.h"
#import <Ushahidi/ReportCustomField.h>
#import <Ushahidi/USHCustomFieldUtility.h>

@interface USHCustomFieldsViewController ()

@end

@implementation USHCustomFieldsViewController

@synthesize report_id = _report_id;

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Custom Field View Controller for %@" , self.report_id );
    NSArray *CustomFields = [USHCustomFieldUtility getCustomFields:self.report_id];
    for (ReportCustomField *customField in CustomFields)
    {
        NSLog(@"----------------------------------------------");
        NSLog(@"USHCustomFieldsViewController custom field %@", customField.identifier);
        NSLog(@"USHCustomFieldsViewController %@", customField.name);
        NSLog(@"USHCustomFieldsViewController %@", customField.value);
        NSLog(@"USHCustomFieldsViewController %@", customField.type);
        NSLog(@"USHCustomFieldsViewController USHCustomFieldsViewController%@", customField.defaultvalue);
        NSLog(@"----------------------------------------------");
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
 
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
