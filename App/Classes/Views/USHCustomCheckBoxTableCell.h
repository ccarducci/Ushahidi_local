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

#import <Ushahidi/USHTableCell.h>

@protocol USHCustomCheckBoxTableCellDelegate;

@interface USHCustomCheckBoxTableCell : USHTableCell {
@public
    UILabel *textLabel;
    UILabel *detailsTextLabel;
}

@property (nonatomic, retain) IBOutlet UIButton *checkBox;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UILabel *detailsTextLabel;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, strong) NSObject<USHCustomCheckBoxTableCellDelegate> *delegate;

- (IBAction)checked:(id)sender event:(UIEvent*)event;

@end

@protocol USHCustomCheckBoxTableCellDelegate <NSObject>

@optional

- (void) checkBoxChanged:(USHCustomCheckBoxTableCell *)cell index:(NSIndexPath *)indexPath checked:(BOOL)checked;

@end