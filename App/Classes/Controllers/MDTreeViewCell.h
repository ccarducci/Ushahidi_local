//
//  MDTreeViewCell.h
//  TreeDemo
//
//  Created by Max Desyatov on 10/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Ushahidi/Ushahidi.h>

@interface MDTreeViewCell : UITableViewCell
{
    CAShapeLayer *triangleLayer;
    UIBezierPath *path;
    BOOL needsAdditionalIndentation;
    IBOutlet UIButton *buttonCheck;
    IBOutlet UIButton *buttonExpand;
    IBOutlet UIButton *buttonRowIndex;
}

@property(nonatomic, retain) IBOutlet UIButton *buttonCheck;
@property(nonatomic, retain) IBOutlet UIButton *buttonExpand;
@property(nonatomic, retain) IBOutlet UIButton *buttonRowIndex;
@property (retain, nonatomic) IBOutlet UILabel *nodeTitleField;
@property (retain, nonatomic) IBOutlet UIImageView *treeImage;
@property (retain, nonatomic) IBOutlet UIImageView *treeCheckImage;


- (IBAction)check:(id)sender;


@property (assign) BOOL isExpanded;
@property (assign) BOOL hasChildren;

 

- (void)spinNodeStateIndicatorWithDuration:(float)duration;

@end
