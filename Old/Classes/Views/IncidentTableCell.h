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
#import "IndexedTableCell.h"

@interface IncidentTableCell : IndexedTableCell {

@public
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *locationLabel;
	IBOutlet UILabel *categoryLabel;
    IBOutlet UILabel *descriptionLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *verifiedLabel;
	IBOutlet UIImageView *imageView;
    IBOutlet UIWebView *webView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UILabel *categoryLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *verifiedLabel;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL uploading;

@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSString *location;
@property (nonatomic, assign) NSString *category;
@property (nonatomic, assign) NSString *description;
@property (nonatomic, assign) NSString *date;
@property (nonatomic, assign) UIImage *image;
@property (nonatomic, assign) UIColor *selectedColor;
@property (nonatomic, assign) BOOL verified;

+ (CGFloat) getCellHeight;
- (void) setHTML:(NSString *)html;
- (CGSize) webViewSize;

@end
