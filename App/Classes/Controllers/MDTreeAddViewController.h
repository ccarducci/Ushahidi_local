//
//  TreeViewController.h
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USHReportMapViewController.h"
#import <Ushahidi/USHMap.h>

@class USHMap;
@class USHReport;

@interface MDTreeAddViewController : UITableViewController{
    USHReportMapViewController *mapControllerTree;
    USHMap *map;
    USHReport *report;
    NSInteger *selected;
}

@property (strong, nonatomic) USHReportMapViewController *mapControllerTree;
@property (strong, nonatomic) USHMap *map;
@property (strong, nonatomic) USHReport *report;
- (IBAction)done:(id)sender;
- (UIColor *)toUIColor :(NSString *)colorHex;
+ (void) resetMDStore;
@end
