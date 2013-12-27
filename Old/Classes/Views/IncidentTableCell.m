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

#import "IncidentTableCell.h"
#import "UIColor+Extension.h"
#import "Device.h"
#import "Settings.h"
#import "NSString+Extension.h"

@implementation IncidentTableCell

typedef enum {
	VerifiedNo,
	VerifiedYes
} Verified;

@synthesize titleLabel, locationLabel, categoryLabel, dateLabel, verifiedLabel, descriptionLabel, imageView, webView, activityIndicator;

- (void)dealloc {
	[titleLabel release];
	[locationLabel release];
	[categoryLabel release];
	[dateLabel release];
	[imageView release];
	[verifiedLabel release];
    [webView release];
    [descriptionLabel release];
	[activityIndicator release];
    [super dealloc];
}

- (void) setDescription:(NSString *)theDescription {
    if (self.descriptionLabel != nil) {
        [self.descriptionLabel setText:theDescription];
    }
}

- (NSString *) description {
    return self.descriptionLabel.text;
}

- (void) setHTML:(NSString *)html {
    if ([NSString isNilOrEmpty:html]) {
        self.imageView.hidden = NO;
        self.webView.hidden = YES;
    }
    else {
        self.imageView.hidden = YES;
        self.webView.hidden = NO;
        [self.webView loadHTMLString:html baseURL:nil];
    }
}

- (CGSize) webViewSize {
    return self.imageView.frame.size;
}

- (void) setTitle:(NSString *)title {
	self.titleLabel.text = title;
}

- (NSString *) title {
	return self.titleLabel.text;
}

- (void) setLocation:(NSString *)location {
	if (location != nil && [location length] > 0) {
		self.locationLabel.text = location;
	}
	else {
		self.locationLabel.text = NSLocalizedString(@"No Location Specified", nil);
	}
}

- (NSString *) location {
	return self.titleLabel.text;
}

- (void) setCategory:(NSString *)category {
	if (category != nil && [category length] > 0) {
		self.categoryLabel.text = category;
	}
	else {
		self.categoryLabel.text = NSLocalizedString(@"No Category Specified", nil);
	}
}

- (NSString *) category {
	return self.categoryLabel.text;
}

- (void) setDate:(NSString *)date {
	if (date != nil && [date length] > 0) {
		self.dateLabel.text = date;
	}
	else {
		self.dateLabel.text = NSLocalizedString(@"No Date Specified", nil);
	}
}

- (NSString *) date {
	return self.dateLabel.text;
}

- (void) setImage:(UIImage *)image {
	if (image != nil) {
		self.imageView.image = image;
	} 
	else {
		self.imageView.image = [UIImage imageNamed:@"placeholder.png"];
	}
}

- (UIImage *) image {
	return self.imageView.image;
}

- (void) setSelectedColor:(UIColor *)color {
	UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
	[selectedBackgroundView setBackgroundColor:color];
	[self setSelectedBackgroundView:selectedBackgroundView];
	[selectedBackgroundView release];	
}

- (UIColor *) selectedColor {
	return self.selectedBackgroundView.backgroundColor;
}

- (void) setVerified:(BOOL) verified {
	if (verified) {
		self.verifiedLabel.text = NSLocalizedString(@"Verified", nil);
		self.verifiedLabel.textColor = [[Settings sharedSettings] verifiedTextColor];
		self.verifiedLabel.tag = VerifiedYes;
	}
	else {
		self.verifiedLabel.text = NSLocalizedString(@"Unverified", nil);
		self.verifiedLabel.textColor = [[Settings sharedSettings] unverifiedTextColor];
		self.verifiedLabel.tag = VerifiedNo;
	}
}

- (BOOL) verified {
	return self.verifiedLabel.tag == VerifiedYes;
}

+ (CGFloat) getCellHeight {
	return [Device isIPad] ? 110 : 90;
}

- (BOOL) uploading {
	return [self.activityIndicator isAnimating];
}

- (void) setUploading:(BOOL)isUploading {
	if (isUploading) {
		[self.activityIndicator startAnimating];
	}
	else {
		[self.activityIndicator stopAnimating];
	}
}

@end
