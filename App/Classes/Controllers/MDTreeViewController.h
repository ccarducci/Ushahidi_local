//
//  MDTreeViewController.h
//  App
//
//  Created by Cristiano Carducci on 01/02/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USHReportMapViewController.h"

@interface MDTreeViewController : UITableViewController{
    USHReportMapViewController *mapControllerTree;
}

@property (strong, nonatomic) USHReportMapViewController *mapControllerTree;
- (IBAction)done:(id)sender;
- (UIColor *)toUIColor :(NSString *)colorHex;

@end
