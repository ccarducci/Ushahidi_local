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

#import <Ushahidi/USHAddViewController.h>
#import <Ushahidi/USHDatePicker.h>
#import <Ushahidi/USHLocator.h>
#import <Ushahidi/USHImagePicker.h>
#import <Ushahidi/USHVideoPicker.h>
#import <Ushahidi/USHLoginDialog.h>
#import <Ushahidi/Ushahidi.h>
#import <Ushahidi/USHShareController.h>
#import "USHInputTableCell.h"


@class USHCategoryTableViewController;
@class USHLocationAddViewController;
@class USHSettingsViewController;
@class USHMap;
@class USHReport;
@class USHReportAddViewController;

@interface USHCustomFieldsAddViewController : USHTableViewController

@property (retain, nonatomic) IBOutlet UILabel *Mess;
@property (retain, nonatomic) IBOutlet UIView *Custom1;
@property (retain, nonatomic) IBOutlet UIView *Custom2;
@property (retain, nonatomic) IBOutlet UIView *Custom3;
@property (retain, nonatomic) IBOutlet UIView *Custom4;

@property (retain, nonatomic) IBOutlet USHReportAddViewController *reportAdd;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *cancel;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *done;

- (IBAction)CancelEv:(id)sender;
- (IBAction)DoneEv:(id)sender;

@end
