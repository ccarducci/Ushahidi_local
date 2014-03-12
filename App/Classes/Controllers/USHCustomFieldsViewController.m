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

typedef enum {
    TextFieldType = 1,
    TextAreaFieldType = 2,
    DateFieldType = 3,
    PasswordFieldType = 4,
    RadioFieldType = 5,
    CheckBoxFieldType = 6,
    DropDownFieldType = 7
} CustomFieldType;

@end

@implementation USHCustomFieldsViewController

@synthesize booksArray;
@synthesize CustomFields;

@synthesize report_id = _report_id;

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Custom Field View Controller for %@" , self.report_id );
    CustomFields = [USHCustomFieldUtility getCustomFields:self.report_id];
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
    [self.tableView reloadData];
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
    self.booksArray = [NSArray arrayWithObjects:@"Brave new world",@"Call of the Wild",@"Catch-22",@"Atlas Shrugged",@"The Great Gatsby",@"The Art of War",@"The Catcher in the Rye",@"The Picture of Dorian Gray",@"The Grapes of Wrath", @"The Metamorphosis",nil];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.CustomFields.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    

    NSString *label = [[self.CustomFields objectAtIndex:indexPath.row] name];
    NSString *labelvalue = [[self.CustomFields objectAtIndex:indexPath.row] value];
    NSMutableString *rowDesc = [[NSMutableString alloc]init];
    [rowDesc appendString:label];
    [rowDesc appendString:@": "];
    [rowDesc appendString:labelvalue];
    cell.textLabel.text = rowDesc;
    return cell;
}
@end
