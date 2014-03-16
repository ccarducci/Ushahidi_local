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
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MDTreeNode *item =[self getSelected];
        
    if ( item == nil )
    {
        [self createLabel:@"Devi selezionare prima la categoria" tag:@"1" pointX:20 pointY:100 width:300 height:100];
        //[self createText:@"test" tag:@"2" pointX:50 pointY:120 width:300 height:40];
    }else{
        NSLog(@"Form_id: %@",item.form_id);
        [USHCategoriesUtility getCustomFormDetailType];
        
        /*
        NSMutableArray *customFields = [USHCustomFieldUtility getCustomAllFields];
        for (CustomFieldTypeDetail *item in customFields)
        {
                NSLog(@"item form_id: %@",item.identifier);
                NSLog(@"item identifier: %@",item.identifierField);
                NSLog(@"item name: %@",item.name);
        }
        */
    }
}

- (MDTreeNode*) getSelected
{
    NSArray *items = [[MDTreeAddNodeStore sharedStore] allNodesAll];
    for (MDTreeNode *item in items) {
        if ( item.isSelected == true) return item;
    }
    return nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        NSLog(@"Remove subview: %@",v.tag);
        [v removeFromSuperview];
    }
}

#pragma mark  action
- (IBAction)CancelEv:(id)sender {
}

- (IBAction)DoneEv:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark  create control
- (void)createText:(NSString*)text
               tag:(NSString*)tag
            pointX:(NSInteger) pointX
            pointY:(NSInteger) pointY
             width:(NSInteger) width
            height:(NSInteger) height
{
    CGFloat fx = (CGFloat)pointX;
    CGFloat fy = (CGFloat)pointY;
    CGFloat fwidth = (CGFloat)width;
    CGFloat fheight = (CGFloat)height;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(fx, fy, fwidth, fheight)];
    textField.tag = tag;
    textField.text =text;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    textField.returnKeyType = UIReturnKeyDone;
    //set the delegate for the text field to the view controller so that it can listen for events
    textField.delegate = self;

    
    [self.view addSubview:textField];
    NSLog(@"Create subview text: %@",tag);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)createLabel:(NSString*)text
                tag:(NSString*)tag
             pointX:(NSInteger) pointX
             pointY:(NSInteger) pointY
              width:(NSInteger) width
             height:(NSInteger) height
{
    UILabel *label;
    CGFloat fx = (CGFloat)pointX;
    CGFloat fy = (CGFloat)pointY;
    CGFloat fwidth = (CGFloat)width;
    CGFloat fheight = (CGFloat)height;
    label = [[UILabel alloc] initWithFrame:CGRectMake(fx, fy, fwidth, fheight)];
    label.tag = tag;
    label.text =text;
    [self.view addSubview:label];
    NSLog(@"Create subview label: %@",tag);
}



@end
