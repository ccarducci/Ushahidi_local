//
//  USHFieldViewController.m
//  App
//
//  Created by Cristiano Carducci on 13/05/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import "USHFieldViewController.h"
#import <Ushahidi/CustomFieldTypeDetail.h>


typedef enum {
    TextFieldType = 1,
    TextAreaFieldType = 2,
    DateFieldType = 3,
    PasswordFieldType = 4,
    RadioFieldType = 5,
    CheckBoxFieldType = 6,
    DropDownFieldType = 7
} CustomFieldType;

@interface USHFieldViewController ()

@end

@implementation USHFieldViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_Back release];
    [_Reset release];
    [super dealloc];
}

#pragma mark  utility

- (NSInteger)getCount
{
    NSInteger count =[[_field.defaultvalue componentsSeparatedByString:@","] count];
    return count;
}

- (NSString*)getFieldValue:(NSUInteger)itemIndex
{
    NSArray *listItems = [_field.defaultvalue componentsSeparatedByString:@","];
    return [listItems objectAtIndex:itemIndex];
}

#pragma mark  table event

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self getCount];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *value =[self getFieldValue:indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:value];
    [cell.textLabel setText:value];
    
    //[cell.detailTextLabel setText:value];
    

    return cell;
}

#pragma mark  action

- (IBAction)BackEv:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)ResetEv:(id)sender {
}
@end
