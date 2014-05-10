//
//  USHCustomFieldViewController.m
//  App
//
//  Created by Cristiano Carducci on 10/05/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import "USHCustomFieldViewController.h"


@interface USHCustomFieldViewController ()

@end

typedef enum {
    TextFieldType = 1,
    TextAreaFieldType = 2,
    DateFieldType = 3,
    PasswordFieldType = 4,
    RadioFieldType = 5,
    CheckBoxFieldType = 6,
    DropDownFieldType = 7
} CustomFieldType;

@implementation USHCustomFieldViewController


- (void)dealloc {
    [_reset release];
    [_done release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //_recipes = [[NSArray alloc] initWithObjects:@"Dollar", @"Euro", @"Pound", nil];}
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Press field: %@" , _field.name);
    NSLog(@"Press field: %@" , _field.type);
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

#pragma mark  action

- (IBAction)ResetEv:(id)sender {
}

- (IBAction)DoneEv:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark  Table event

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self countValues];
    return count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *desc = [self getItemAtIndex:indexPath.row];

    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:desc];
    [cell.textLabel setText:desc];
    
    return cell;
}

#pragma mark Utility


-(void) loadCustomFieldTypeDetail
{
    [self.tableView reloadData];
}

-(NSUInteger *) countValues
{
    NSString *list = _field.defaultvalue;
    NSArray *listItems = [list componentsSeparatedByString:@","];
    return [listItems count];
}

-(NSString *) getItemAtIndex:(NSInteger) index
{
    NSString *list = _field.defaultvalue;
    NSArray *listItems = [list componentsSeparatedByString:@","];
    return [listItems objectAtIndex:index];
}

@end
