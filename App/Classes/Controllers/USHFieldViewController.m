//
//  USHFieldViewController.m
//  App
//
//  Created by Cristiano Carducci on 13/05/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import "USHFieldViewController.h"
#import <Ushahidi/CustomFieldTypeDetail.h>
#import "USHTableCellFactory.h"

typedef enum {
    TextFieldType = 1,
    TextAreaFieldType = 2,
    DateFieldType = 3,
    PasswordFieldType = 4,
    RadioFieldType = 5,
    CheckBoxFieldType = 6,
    DropDownFieldType = 7
} CustomFieldType;

typedef enum {
	CheckedFalse,
	CheckedTrue
} Checked;

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
    _selected = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_selected removeAllObjects];
    // _selected = [[NSMutableArray alloc] init];
    if ( _field.type.intValue == 5 || _field.type.intValue == 7  ){
        if (_field.value != nil && _field.value.length>0){
            NSString *itemSelected = [self getIndexSingleValue:_field.value];
            [_selected addObject:itemSelected];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_selected removeAllObjects];
    //[_selected release];
}

- (void)dealloc {
    [_Back release];
    [_Reset release];
    [_selected release];
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

-(NSString*)getIndexSingleValue:(NSString*)value
{
    NSArray *listItems = [_field.defaultvalue componentsSeparatedByString:@","];
    NSInteger item = 0;
    NSInteger itemNotFound = -1;
    for (NSString *object in listItems) {
        if ( [object isEqualToString:value])
        {
            return [@(item ) stringValue];
        }
        item++;
    }
    return [@(itemNotFound ) stringValue];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *value =[self getFieldValue:indexPath.row];
    
    
    if (_field.type.intValue == 5 ){


        BOOL checked = true;
        if ( [_selected count] > 0 )
        {
            NSString *itemSselected =_selected[0];
            NSInteger indexInt = indexPath.row;
            NSString *itemS = [@(indexInt ) stringValue];
            if ( [itemS isEqualToString:itemSselected] )checked = false;
        }
        
        return [USHTableCellFactory customOptionBoxTableCellForTable:tableView
                                                          indexPath:indexPath
                                                           delegate:self
                                                               text:value
                                                            details:nil
                                                            checked:checked
                                                              color:Nil];
    }else if (_field.type.intValue == 6 ){
        BOOL checked = false;
        if ( _field.value != nil && _field.value.length > 0){
            if ( [_field.value rangeOfString:value].location != NSNotFound){
                checked = true;
            }
        }
        return [USHTableCellFactory customCheckBoxTableCellForTable:tableView
                                                          indexPath:indexPath
                                                           delegate:self
                                                               text:value
                                                            details:nil
                                                            checked:checked
                                                              color:Nil];
    }else if (_field.type.intValue == 7 ){
        BOOL checked = true;
        if ( [_selected count] > 0 )
        {
            NSString *itemSselected =_selected[0];
            NSInteger indexInt = indexPath.row;
            NSString *itemS = [@(indexInt ) stringValue];
            if ( [itemS isEqualToString:itemSselected] )checked = false;
        }
        return [USHTableCellFactory customComboBoxTableCellForTable:tableView
                                                          indexPath:indexPath
                                                           delegate:self
                                                               text:value
                                                            details:nil
                                                            checked:checked
                                                              color:Nil];
    }else{
        nil;
    }
    return nil;
}

#pragma mark  action

- (IBAction)BackEv:(id)sender {
    if (_field.type.intValue == 5 || _field.type.intValue == 7  ){
        if ( _selected.count > 0 ){
            NSString *itemSselected =_selected[0];
            _field.value = [self getFieldValue:[itemSselected integerValue]];
        }else if (_selected.count == 0)
        {
            _field.value = nil;
        }
    }
    if(_field.type.intValue == 6)
    {
        NSString *value = @"";
        int item = 1;
        [_selected removeAllObjects];
        for (int section = 0; section < 1; section++) {
            for (int row = 0; row < [self getCount]; row++) {
                NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
                USHCustomCheckBoxTableCell* cell = (USHCustomCheckBoxTableCell*)[self.tableView cellForRowAtIndexPath:cellPath];
                
                if (cell.tag == CheckedTrue)
                {
                    if(item == 1)
                    {
                        value = [value stringByAppendingString:cell.textLabel.text];

                    }else{
                        value = [value stringByAppendingString:@","];
                        value = [value stringByAppendingString:cell.textLabel.text];
                    }
                    item++;
                }
            }
            NSLog(@"_selected %@", value);
            //[_selected addObject:value];
            _field.value = value;
        }
        
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)ResetEv:(id)sender {
    if (_field.type.intValue == 5 || _field.type.intValue == 7 || _field.type.intValue == 6 ){
            [_selected removeAllObjects];
            [self.tableView reloadData];
    }
}

#pragma mark - USHCheckBoxTableCell

- (void) checkBoxChanged:(USHCheckBoxTableCell *)cell index:(NSIndexPath *)indexPath checked:(BOOL)checked {

    if (_field.type.intValue == 5 || _field.type.intValue == 7 ){
        
        if (_selected.count >0){
            [_selected removeAllObjects];
            NSInteger indexInt = indexPath.row;
            NSString *itemS = [@(indexInt ) stringValue];
            [_selected addObject:itemS];
            [self.tableView reloadData];
        }else{
            NSInteger indexInt = indexPath.row;
            NSString *itemS = [@(indexInt ) stringValue];
            [_selected addObject:itemS];
        }
    }
}
@end
