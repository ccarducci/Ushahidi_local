//
//  MDTreeViewCell.m
//  TreeDemo
//
//  Created by Max Desyatov on 10/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import "MDTreeAddViewCell.h"
#import <Ushahidi/USHDevice.h>

@implementation MDTreeAddViewCell

@synthesize buttonCheck;
@synthesize buttonExpand;
@synthesize buttonRowIndex;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        needsAdditionalIndentation = NO;
        _isExpanded = NO;
        _hasChildren = NO;
    }
    
    return self;
}

- (void)prepareForReuse
{
    BOOL checked = false;
    NSLog(@"prepareForReuse button.tag: %@",(NSString *)buttonCheck.tag);
    
    NSMutableDictionary *flatCategoryToAddSelected = [[Ushahidi sharedInstance] flatCategoryToAddSelected];
    NSInteger myInteger = [buttonCheck.tag integerValue];
    NSString *key =[NSString stringWithFormat:@"%i", myInteger];
    USHCategory *category = [flatCategoryToAddSelected objectForKey:key];
    
    if (category != NULL )
    {
        [buttonCheck setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
        checked = true;
    }else{
        
            [buttonCheck setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
            checked = false;
    }
    

    if (_hasChildren)
    {
        [self.buttonExpand setHidden:NO];

    } else
    {
        [self.buttonExpand setHidden:YES];
    }
    
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float indentPoints = self.indentationLevel * self.indentationWidth;
    
    if ([USHDevice isIPad]) indentPoints = indentPoints + 40;
    
    if (self.editing && needsAdditionalIndentation)
        indentPoints += 32;

    self.contentView.frame =
        CGRectMake(indentPoints,
                   self.contentView.frame.origin.y,
                   self.contentView.frame.size.width - indentPoints,
                   self.contentView.frame.size.height);
}

- (void)spinNodeStateIndicatorWithDuration:(float)duration
{
    CABasicAnimation *spin =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setToValue:[NSNumber numberWithFloat:-M_PI_2]];
    [spin setDuration:duration];
    [spin setSpeed:(_isExpanded ? 1 : -1)];
    [spin setRemovedOnCompletion:NO];
    [spin setFillMode:kCAFillModeForwards];
    [triangleLayer addAnimation:spin forKey:@"spinAnimation"];
}

- (void)dealloc {
    [_nodeTitleField release];
    [_treeImage release];
    [_treeCheckImage release];
    [buttonExpand release];
    [super dealloc];
}

- (IBAction)check:(id)sender {

}

@end
