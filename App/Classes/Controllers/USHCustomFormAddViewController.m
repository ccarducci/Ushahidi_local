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

@synthesize reportCustomFields = _reportCustomFields;


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
    [_Reset release];
    [_fieldValueSelectorController release];
    [_fieldSingleValueSelectorController release];
    [_fieldSingleValueSelectorController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    if( _fields == nil){
        _fields = [[NSMutableArray alloc]init];
    }else{
        [_fields removeAllObjects];
    }
    */
}

- (void)viewDidUnload {
    [super viewDidUnload];
    //[_fields removeAllObjects];
    //[_fields release];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //_item =[self getSelected];
    //[self loadCustomFieldTypeDetail];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[_fields removeAllObjects];
}


#pragma mark  Table event

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fields.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    USHFieldItem *field= (USHFieldItem *)[_fields objectAtIndex:indexPath.row];
    NSLog(@"Press field: %@" , field.name);
    
    if ( field.type.intValue == 1)
    {
        NSLog(@"CustomFieldType: TextFieldType");
        self.fieldSingleValueSelectorController.field = field;
        self.fieldSingleValueSelectorController.testo.text = field.value;
        self.fieldSingleValueSelectorController.title = field.name;
        [self presentModalViewController:self.fieldSingleValueSelectorController animated:YES];
    }
    else if (field.type.intValue == 2)
    {
        NSLog(@"CustomFieldType: TextAreaFieldType");
        [self presentModalViewController:self.fieldSingleValueSelectorController animated:YES];
    }
    else if (field.type.intValue == 3)
    {
        NSLog(@"CustomFieldType: DateFieldType");
        [self presentModalViewController:self.fieldSingleValueSelectorController animated:YES];
    }else if (field.type.intValue == 4)
    {
        NSLog(@"CustomFieldType: PasswordFieldType");
        [self presentModalViewController:self.fieldSingleValueSelectorController animated:YES];
    }else if (field.type.intValue == 5)
    {
        NSLog(@"CustomFieldType: RadioFieldType");
        self.fieldValueSelectorController.field = field;
        self.fieldValueSelectorController.title = field.name;
        [self presentModalViewController:self.fieldValueSelectorController animated:YES];
    }else if (field.type.intValue == 6)
    {
        NSLog(@"CustomFieldType: CheckBoxFieldType");
        self.fieldValueSelectorController.field = field;
        self.fieldValueSelectorController.title = field.name;
        [self presentModalViewController:self.fieldValueSelectorController animated:YES];
    }else if (field.type.intValue == 7)
    {
        NSLog(@"CustomFieldType: DropDownFieldType");
        self.fieldValueSelectorController.field = field;
        self.fieldValueSelectorController.title = field.name;
        [self presentModalViewController:self.fieldValueSelectorController animated:YES];
    }else
    {
        NSLog(@"CustomFieldType: NO");
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USHFieldItem *field= (USHFieldItem *)[_fields objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:field.name];
    [cell.textLabel setText:field.name];
    [cell.detailTextLabel setText:field.value];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark  action

- (IBAction)ResetEv:(id)sender {
    [self resetAll];
}

- (IBAction)BackEv:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    if (_fields !=nil && _fields.count > 0 && _reportCustomFields != nil)
    {
        [_reportCustomFields removeAllObjects];
        [_reportCustomFields addObjectsFromArray:_fields];
    }
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

    NSLog(@"Load field for form_id: %@",_item.form_id);
    NSString *sForm_id = [_item.form_id stringValue];
    for (CustomFieldTypeDetail *itemCustom in ((NSMutableArray *)[USHCategoriesUtility getCustomFormDetailType]))
    {
        if ( [itemCustom.identifier isEqualToString:sForm_id]){
            USHFieldItem *item = [[USHFieldItem alloc] init];
            if (itemCustom.value !=nil)
                item.value =[[NSString alloc] initWithString:itemCustom.value];
            else
                item.value = nil;
            item.defaultvalue =[[NSString alloc] initWithString:itemCustom.defaultvalue];
            item.name =[[NSString alloc] initWithString:itemCustom.name];
            item.type =itemCustom.type;
            [_fields addObject:item];
        }
    }
    [self.tableView reloadData];
}

-(void)  resetAll
{
    for (USHFieldItem *itemCustom in _fields)
    {
        itemCustom.value = nil;
    }
}

@end
