//
//  MDTreeViewCell.m
//  TreeDemo
//
//  Created by Max Desyatov on 10/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import "MDTreeViewCell.h"
#import <Ushahidi/USHDevice.h>

@implementation MDTreeViewCell

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

/*
- (BOOL)hasChildren{
    return _hasChildren;
}
*/

- (void)prepareForReuse
{
    BOOL checked = false;
    NSLog(@"prepareForReuse button.tag: %@",(NSString *)buttonCheck.tag);
    
    NSMutableDictionary *dictionary = [[Ushahidi sharedInstance] flatCategorySelected];
    NSString *selected = [dictionary objectForKey:(NSString *)buttonCheck.tag];
    if ( [selected isEqualToString:@"YES"] ){
        [buttonCheck setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
        checked = true;
    }else
    {
        [buttonCheck setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
        checked = false;
    }
    
    // QUI METTO CODICE PER APERTURA CELLA
    if (_hasChildren)
    {
        // SETTO PRIMA LE STRUTTURE
        [self.buttonExpand setHidden:NO];
        /*
        if (_isExpanded){
            
        }
        */
    } else
    {
        [self.buttonExpand setHidden:YES];
    }
    
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    //[super willTransitionToState:state];
    //needsAdditionalIndentation =
    //    state & UITableViewCellStateShowingEditControlMask;
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
