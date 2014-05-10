/*****************************************************************************
 ** Copyright (c) 2012 Ushahidi Inc
 ** All rights reserved
 ** Contact: team@ushahidi.com
 ** Website: http://www.ushahidi.com
 **
 ** GNU Lesser General Public License Usage
 ** This file may be used under the terms of the GNU Lesser
 ** General Public License version 3 as published by the Free Software
 ** Foundation and appearing in the file LICENSE.LGPL included in the
 ** packaging of this file. Please review the following information to
 ** ensure the GNU Lesser General Public License version 3 requirements
 ** will be met: http://www.gnu.org/licenses/lgpl.html.
 **
 **
 ** If you have questions regarding the use of this file, please contact
 ** Ushahidi developers at team@ushahidi.com.
 **
 *****************************************************************************/

#import "USHCustomFieldsAddViewController.h"
#import "USHCategoryTableViewController.h"
#import "USHLocationAddViewController.h"
#import "USHSettingsViewController.h"
#import "USHTableCellFactory.h"
#import "USHIconTableCell.h"
#import "USHInputTableCell.h"
#import "USHImageTableCell.h"
#import "USHSettings.h"
#import <Ushahidi/UIAlertView+USH.h>
#import <Ushahidi/Ushahidi.h>
#import <Ushahidi/USHReport.h>
#import <Ushahidi/USHDevice.h>
#import <Ushahidi/USHReport.h>
#import <Ushahidi/USHMap.h>
#import <Ushahidi/Ushahidi.h>
#import <Ushahidi/USHInternet.h>
#import <Ushahidi/USHLocator.h>
#import <Ushahidi/NSString+USH.h>
#import <Ushahidi/UITableView+USH.h>
#import <Ushahidi/UIBarButtonItem+USH.h>
#import <Ushahidi/MDTreeAddNodestore.h>
#import <Ushahidi/MDTreeNode.h>
#import <Ushahidi/USHCustomFieldUtility.h>
#import <Ushahidi/CustomFieldTypeDetail.h>
#import <Ushahidi/USHCategoriesUtility.h>


@class USHCategoriesUtility;

@interface USHCustomFieldsAddViewController ()


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


@implementation USHCustomFieldsAddViewController


- (void)dealloc {
    [_cancel release];
    [_done release];
    [_reportAdd release];
    [_item release];
    [_fields removeAllObjects];
    [_fields release];
    [_fieldView release];
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

#pragma mark  action

- (IBAction)CancelEv:(id)sender {
}

- (IBAction)DoneEv:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
    
    self.fieldView.field = field;
    
    if ( field.type.intValue == 1)
    {
        NSLog(@"CustomFieldType: TextFieldType");
    }
    else if (field.type.intValue == 2)
    {
        NSLog(@"CustomFieldType: TextAreaFieldType");
    }
    else if (field.type.intValue == 3)
    {
        NSLog(@"CustomFieldType: DateFieldType");
    }else if (field.type.intValue == 4)
    {
        NSLog(@"CustomFieldType: PasswordFieldType");
    }else if (field.type.intValue == 5)
    {
        NSLog(@"CustomFieldType: RadioFieldType");
        [self presentModalViewController:self.fieldView animated:YES];
    }else if (field.type.intValue == 6)
    {
        NSLog(@"CustomFieldType: CheckBoxFieldType");
        [self presentModalViewController:self.fieldView animated:YES];
        
    }else if (field.type.intValue == 7)
    {
        NSLog(@"CustomFieldType: DropDownFieldType");
        [self presentModalViewController:self.fieldView animated:YES];
    }else
    {
    }
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CustomFieldTypeDetail *field= (CustomFieldTypeDetail *)[_fields objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:field.name];
    [cell.textLabel setText:field.name];

    [cell.detailTextLabel setText:field.value];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
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
