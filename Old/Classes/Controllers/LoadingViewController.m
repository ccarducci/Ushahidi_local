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

#import "LoadingViewController.h"
#import "Device.h"

@interface LoadingViewController ()

@property (nonatomic, retain) UIViewController *controller;

- (void) removeFromSuperview;
- (void) removeFromSuperviewAfterDelay:(NSNumber*)delay;
@end


@implementation LoadingViewController

@synthesize controller, activityIndicator, activityIndicatorLabel, activityIndicatorBackground;

- (id) initWithController:(UIViewController *)theController {
	NSString *nibName = [Device isIPad] ? @"LoadingViewController_iPad" : @"LoadingViewController_iPhone";
	if (self = [super initWithNibName:nibName bundle:[NSBundle mainBundle]]) {
		self.controller = theController;
	}
    return self;
}

- (void)dealloc {
	[controller release];
	[activityIndicator release];
	[activityIndicatorLabel release];
	[activityIndicatorBackground release];
	[super dealloc];	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.activityIndicatorBackground.layer.cornerRadius = 20.0f;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) show {
	[self showWithMessage:NSLocalizedString(@"Loading...", nil) afterDelay:0.0 animated:YES];
}

- (void) showAfterDelay:(NSTimeInterval)delay {
	[self showWithMessage:NSLocalizedString(@"Loading...", nil) afterDelay:delay animated:YES];
}

- (void) showWithMessage:(NSString *)message {
	[self showWithMessage:message afterDelay:0.0 animated:YES];
}

- (void) showWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay {
	[self showWithMessage:message afterDelay:delay animated:YES];
}


- (void) showWithMessage:(NSString *)message animated:(BOOL)animated {
	[self showWithMessage:message afterDelay:0.0 animated:animated];
}

- (void) showWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay animated:(BOOL)animated {
	if ([NSThread isMainThread]) {
		if (self.view.superview == nil) {
			[self.controller.view performSelector:@selector(addSubview:) withObject:self.view afterDelay:delay];
			self.view.alpha = 1.0;
			self.view.center = self.controller.view.center;
            self.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                                         UIViewAutoresizingFlexibleRightMargin |
                                         UIViewAutoresizingFlexibleTopMargin |
                                         UIViewAutoresizingFlexibleBottomMargin;
		}
		self.activityIndicatorLabel.text = message;
		self.activityIndicator.hidden = !animated;
	}
	else {
		if (self.view.superview == nil) {
			[self.controller.view performSelectorOnMainThread:@selector(addSubview:) withObject:self.view waitUntilDone:NO];
			[self.view performSelectorOnMainThread:@selector(setCenter:) withObject:self.controller.view waitUntilDone:NO];
			[self.activityIndicatorLabel performSelectorOnMainThread:@selector(setText:) withObject:message waitUntilDone:NO];
		}
		[self.activityIndicatorLabel performSelectorOnMainThread:@selector(setText:) withObject:message waitUntilDone:NO];
	}
}

- (BOOL) isShowing {
	return self.view.superview != nil;
}

- (NSString *) message {
	return self.activityIndicatorLabel.text;
}

- (void) hide {
	[self hideAfterDelay:0.0];
}

- (void) hideAfterDelay:(NSTimeInterval)delay {
    if ([NSThread isMainThread]) {
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:delay];
	}
	else {
        [self performSelectorOnMainThread:@selector(removeFromSuperviewAfterDelay:) withObject:[NSNumber numberWithFloat:delay] waitUntilDone:NO];
    }
}

- (void) removeFromSuperviewAfterDelay:(NSNumber*)delay {
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:[delay floatValue]];
}

- (void) removeFromSuperview {
    [UIView beginAnimations:@"RemoveFromSuperView" context:nil];
	[UIView setAnimationDuration:0.3];
	self.view.alpha = 0.0;
	[UIView commitAnimations];
	[self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];	
}

@end
