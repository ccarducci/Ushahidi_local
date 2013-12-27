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

#import <Foundation/Foundation.h>
#import "IndexedTableCell.h"

@protocol CheckBoxTableCellDelegate;

@interface CheckBoxTableCell : IndexedTableCell {

@public
	UIImage *checkedImage;
	UIImage *uncheckedImage;

@private
	id<CheckBoxTableCellDelegate> delegate;
}

@property (nonatomic, retain) UIImage *checkedImage;
@property (nonatomic, retain) UIImage *uncheckedImage;
@property (nonatomic, assign) UIColor *selectedColor;
@property (nonatomic, assign) BOOL checked;

- (id)initForDelegate:(id<CheckBoxTableCellDelegate>)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void) setTitle:(NSString *)title;
- (void) setDescription:(NSString *)description;
- (void) setTextColor:(UIColor *)color;

@end

@protocol CheckBoxTableCellDelegate <NSObject>

@optional

- (void) checkBoxTableCellChanged:(CheckBoxTableCell *)cell index:(NSIndexPath *)indexPath checked:(BOOL)checked;

@end