//
//  USHCustomFormAddViewController.m
//  App
//
//  Created by Cristiano Carducci on 12/05/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import "USHCustomFormAddViewController.h"
#import <Ushahidi/MDTreeAddNodestore.h>
#import <Ushahidi/CustomFieldTypeDetail.h>
#import <Ushahidi/USHCategoriesUtility.h>


typedef enum {
    TextFieldType = 1,
    TextAreaFieldType = 2,
    DateFieldType = 3,
    PasswordFieldType = 4,
    RadioFieldType = 5,
    CheckBoxFieldType = 6,
    DropDownFieldType = 7
} CustomFieldType;

@interface USHCustomFormAddViewController ()

@end

@implementation USHCustomFormAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_item release];
    [_fields removeAllObjects];
    [_fields release];
    [_Back release];
    [_Back release];
    [_Back release];
    [_Reset release];
    [_fieldValueSelectorController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _item =[self getSelected];
    [self loadCustomFieldTypeDetail];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _item =[self getSelected];
    [self loadCustomFieldTypeDetail];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

#pragma mark  Table event

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fields.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomFieldType typeField;
    CustomFieldTypeDetail *field= (CustomFieldTypeDetail *)[_fields objectAtIndex:indexPath.row];
    NSLog(@"Press field: %@" , field.name);
    
    self.fieldValueSelectorController.field = field;
    
    [self presentModalViewController:self.fieldValueSelectorController animated:YES];
    
    if ( field.type.intValue == 1)
    {
        NSLog(@"CustomFieldType: TextFieldType");
        //[self presentModalViewController:self.fieldMultiCustom animated:YES];
        
    }
    else if (field.type.intValue == 2)
    {
        NSLog(@"CustomFieldType: TextAreaFieldType");
        //[self presentModalViewController:self.fieldMultiCustom animated:YES];
    }
    else if (field.type.intValue == 3)
    {
        NSLog(@"CustomFieldType: DateFieldType");
        //[self presentModalViewController:self.fieldMultiCustom animated:YES];
    }else if (field.type.intValue == 4)
    {
        NSLog(@"CustomFieldType: PasswordFieldType");
        //[self presentModalViewController:self.fieldMultiCustom animated:YES];
    }else if (field.type.intValue == 5)
    {
        NSLog(@"CustomFieldType: RadioFieldType");
        //self.fieldMultiCustom.values =  [field.defaultvalue componentsSeparatedByString:@","];
        //[self presentModalViewController:self.fieldMultiCustom animated:YES];
    }else if (field.type.intValue == 6)
    {
        NSLog(@"CustomFieldType: CheckBoxFieldType");
        //self.fieldMultiCustom.values =  [field.defaultvalue componentsSeparatedByString:@","];
        //[self presentModalViewController:self.fieldMultiCustom animated:YES];
    }else if (field.type.intValue == 7)
    {
        NSLog(@"CustomFieldType: DropDownFieldType");
        //self.fieldMultiCustom.values =  [field.defaultvalue componentsSeparatedByString:@","];
        //[self presentModalViewController:self.fieldMultiCustom animated:YES];
    }else
    {
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomFieldTypeDetail *field= (CustomFieldTypeDetail *)[_fields objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:field.name];
    [cell.textLabel setText:field.name];
    
    [cell.detailTextLabel setText:field.value];
    
    if ( field.value == nil ){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark  action

- (IBAction)ResetEv:(id)sender {
}

- (IBAction)BackEv:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark Utility

- (MDTreeNode*) getSelected
{
    NSArray *items = [[MDTreeAddNodeStore sharedStore] allNodesAll];
    for (MDTreeNode *item in items) {
        if ( item.isSelected == true) return item;
    }
    return nil;
}

-(void) loadCustomFieldTypeDetail
{
    if( _fields == nil){
        _fields = [[NSMutableArray alloc]init];
    }else{
        [_fields removeAllObjects];
    }
    NSLog(@"Load field for form_id: %@",_item.form_id);
    NSString *sForm_id = [_item.form_id stringValue];
    for (CustomFieldTypeDetail *itemCustom in [USHCategoriesUtility getCustomFormDetailType])
    {
        if ( [itemCustom.identifier isEqualToString:sForm_id]){
            [_fields addObject:itemCustom];
        }
    }
    [self.tableView reloadData];
}


@end
