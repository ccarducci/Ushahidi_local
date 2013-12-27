/*****************************************************************************
 ** Copyright (c) 2010 Ushahidi Inc
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

#import <UIKit/UIKit.h>
#import "BaseTabViewController.h"
#import "UserDialog.h"
#import "Ushahidi.h"

@class CheckinTableViewController;
@class CheckinMapViewController;

@interface CheckinTabViewController : BaseTabViewController<UshahidiDelegate, UserDialogDelegate> {

@public
	CheckinTableViewController *checkinTableViewController;
	CheckinMapViewController *checkinMapViewController;
	
@private
	UserDialog *userDialog;
}

@property(nonatomic,retain) IBOutlet CheckinTableViewController *checkinTableViewController;
@property(nonatomic,retain) IBOutlet CheckinMapViewController *checkinMapViewController;

@end
