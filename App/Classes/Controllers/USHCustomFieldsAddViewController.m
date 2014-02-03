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

@interface USHCustomFieldsAddViewController ()



@end

@implementation USHCustomFieldsAddViewController



- (void)dealloc {
    [_cancel release];
    [_done release];
    [_reportAdd release];
    [_Mess release];
    [_Custom1 release];
    [_Custom2 release];
    [_Custom3 release];
    [_Custom4 release];
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
    self.Custom1.hidden=YES;
        self.Custom2.hidden=YES;
        self.Custom3.hidden=YES;
        self.Custom4.hidden=NO;
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
@end
