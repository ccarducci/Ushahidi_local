//
//  TreeViewController.m
//  TreeDemo
//
//  Created by Max Desyatov on 08/11/2012.
//  Copyright (c) 2012 Max Desyatov. All rights reserved.
//

#import "MDTreeAddViewController.h"
#import <Ushahidi/MDTreeAddNodestore.h>
#import <Ushahidi/MDTreeNode.h>
#import "MDTreeAddViewCell.h"
#import <Ushahidi/Ushahidi.h>
#import <Ushahidi/CategoryTreeManager.h>
#import <Ushahidi/CategoryTree.h>
#import "USHSettings.h"

@implementation MDTreeAddViewController

@synthesize mapControllerTree;
@synthesize map;
@synthesize report;


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [[USHSettings sharedInstance] tableRowColor];
}

- (UIColor *)toUIColor :(NSString *)colorHex{
    
    unsigned int c;

    if ([colorHex characterAtIndex:0] == '#') {
        
        [[NSScanner scannerWithString:[colorHex substringFromIndex:1]] scanHexInt:&c];
        
    } else {
        
        [[NSScanner scannerWithString:colorHex] scanHexInt:&c];
        
    }
    
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0 green:((c & 0xff00) >> 8)/255.0 blue:(c & 0xff)/255.0 alpha:1.0];
    
}

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        UINavigationItem *n = [self navigationItem];

        [n setTitle:NSLocalizedString(@"cat_new", nil)];
        
        UIBarButtonItem *bbi =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonItemStylePlain
         target:self
         action:@selector(done:)];

        [[self navigationItem] setRightBarButtonItem:bbi];

    }
    NSNumber *selectedId = [self getSelected];
    [[MDTreeAddNodeStore sharedStore]   removeAll];
    NSMutableArray *flatCategory = [[Ushahidi sharedInstance] flatCategory];
    NSLog(@"Count in MDTreeAddViewController: %i",flatCategory.count);
    CategoryTreeManager *operazione = [[CategoryTreeManager alloc] init];
    [operazione createTreeAdd:flatCategory];
    [operazione dealloc];
    [self setDefaultChioice:selectedId];
    return self;
}



- (void) setDefaultChioice:(NSNumber*) idCategoryStart
{
    NSArray *items = [[MDTreeAddNodeStore sharedStore] allNodesAll];
    for (MDTreeNode *item in items) {
        if ( item.id == idCategoryStart)
        {
            item.isSelected = true;
            item.isDisabled = false;
        }else{
            item.isSelected = false;
            item.isDisabled = true;
        }
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:@"MDTreeAddViewCell" bundle:nil];

    [[self tableView] registerNib:nib forCellReuseIdentifier:@"MDTreeAddViewCell"];
    
    self.tableView.backgroundColor = [[USHSettings sharedInstance] tableBackColor];
    
    self.navigationController.navigationBar.tintColor = [[USHSettings sharedInstance] navBarColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[MDTreeAddNodeStore sharedStore] allNodes] count];
}

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-------------------------------"  );
    MDTreeAddViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"MDTreeAddViewCell"];

    if (!cell)
    {
        cell =
            [[MDTreeAddViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"MDTreeAddViewCell"];
    }

    MDTreeNode *n =
        [[[MDTreeAddNodeStore sharedStore] allNodes]
            objectAtIndex:[indexPath row]];
    
    
    cell.buttonCheck.tag =(NSInteger) n.id;
    [cell.buttonCheck addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonRowIndex.tag = [indexPath row];
    [[cell nodeTitleField] setText:[n description]];
    [cell setIndentationWidth:8];
    [cell setIsExpanded:[n isExpanded]];
    [cell setHasChildren:([[n children] count] > 0)];
    [cell prepareForReuse];
    
    if ( [self getSelected] == -1 )
    {
        [cell.buttonCheck setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
        UIColor *coll =  cell.buttonCheck.tintColor;
        
        //cell.buttonCheck.tintColor = UIColor.blueColor;[UIColor colorWithRed:((float)((rgbValue & 0xFF0000)
        // 0x0ce28c30
        cell.buttonCheck.tintColor = UIColorFromRGB(0x0ce28c30);
    }else{
        if ( n.isSelected == true)
        {
            [cell.buttonCheck setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
            cell.buttonCheck.tintColor = UIColorFromRGB(0x0ce28c30);
        }else{
            [cell.buttonCheck setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
            cell.buttonCheck.tintColor = UIColor.grayColor;
        }
        
    }
    
    
    NSLog(@"cell.buttonCheck.tag  - %@" ,(NSString *)cell.buttonCheck.tag );
    NSLog(@"index cell  - %d" , cell.buttonRowIndex.tag );
    NSLog(@"-------------------------------"  );
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = [[MDTreeAddNodeStore sharedStore] allNodes];
    MDTreeNode *n = [items objectAtIndex:[indexPath row]];

    NSInteger result = -1;

    while (n && n.parent)
    {
        ++result;
        n = n.parent;
    }

    return result * 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click %d",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *nodes = [[MDTreeAddNodeStore sharedStore] allNodes];
    MDTreeNode *selectedNode = [nodes objectAtIndex:[indexPath row]];
    if ([[selectedNode children] count] < 1)
        return;
    
    MDTreeAddViewCell *cell =
    (MDTreeAddViewCell *)[[self tableView] cellForRowAtIndexPath:indexPath];
    [cell spinNodeStateIndicatorWithDuration:0.25];
    
    
    BOOL oldIsExpanded = [selectedNode isExpanded];
    
    if (oldIsExpanded)
    {
        NSArray *flattenedChildren = [selectedNode flatten];
        NSMutableArray *rowsToDelete = [NSMutableArray array];
        
        NSLog(@"-------------------------");
        NSLog(@"DeExpand node %d",cell.tag);
        for (MDTreeNode *child in flattenedChildren)
        {
            NSUInteger row = [nodes indexOfObjectIdenticalTo:child];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
            [rowsToDelete addObject:ip];
        }
        NSLog(@"-------------------------");
        [selectedNode setIsExpanded:!oldIsExpanded];
        [cell setIsExpanded:!oldIsExpanded];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:rowsToDelete
                         withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];
        
        // SET IMAGE EXPAND PLUS
        [cell.buttonExpand setImage:[UIImage imageNamed:@"button_plus_blue.png"] forState:UIControlStateNormal];
        
    } else
    {
        [selectedNode setIsExpanded:!oldIsExpanded];
        [cell setIsExpanded:!oldIsExpanded];
        
        NSArray *flattenedChildren = [selectedNode flatten];
        NSMutableArray *rowsToInsert = [NSMutableArray array];
        // refreshing list of all nodes after expand
        nodes = [[MDTreeAddNodeStore sharedStore] allNodes];
        
        NSLog(@"-------------------------");
        NSLog(@"Expand node %d",cell.tag);
        for (MDTreeNode *child in flattenedChildren)
        {
            NSUInteger row = [nodes indexOfObjectIdenticalTo:child];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
            [rowsToInsert addObject:ip];
        }
        NSLog(@"-------------------------");
        
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:rowsToInsert
                         withRowAnimation:UITableViewRowAnimationBottom];
        [tableView endUpdates];
        
        // SET IMAGE EXPAND MINUS
        [cell.buttonExpand setImage:[UIImage imageNamed:@"button_minus_blue.png"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - Action

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) setIsDisabled:(NSNumber*)selected
{
    NSArray *items = [[MDTreeAddNodeStore sharedStore] allNodesAll];
    for (MDTreeNode *item in items) {
        if ( item.id == selected){
            item.isDisabled = false;
        }else{
            item.isDisabled = true;
        }
    }
}

- (void) resetIsDisabled
{
    NSArray *items = [[MDTreeAddNodeStore sharedStore] allNodesAll];
    for (MDTreeNode *item in items) {
        item.isDisabled = false;
    }
}

- (NSNumber*) getSelected
{
    NSArray *items = [[MDTreeAddNodeStore sharedStore] allNodesAll];
    for (MDTreeNode *item in items) {
        if ( item.isSelected == true) return item.id;
    }
    return -1;
}

-(void) check:(id)sender{
    NSLog(@"BEGIN CLICK CHECK ----");
    UIButton *button = (UIButton *)sender;
    for (UIView *parent = [button superview]; parent != nil; parent = [parent superview]) {
        if ([parent isKindOfClass: [UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell *) parent;
            NSIndexPath *pathOfTheCell = [self.tableView indexPathForCell: cell];
            
            NSInteger rowOfTheCell = pathOfTheCell.row;
            NSLog(@"rowofthecell %d", rowOfTheCell);
            NSArray *nodes = [[MDTreeAddNodeStore sharedStore] allNodes];
            MDTreeNode *selectedNode = [nodes objectAtIndex:pathOfTheCell.row];
            NSLog(@"selectedNode parent_root %i", selectedNode.parent_root);
            NSInteger myInteger = [button.tag integerValue];
            NSString *key =[NSString stringWithFormat:@"%i", myInteger];
            
            
            NSMutableDictionary *flatCategoryToAdd = [[Ushahidi sharedInstance] flatCategoryToAdd];
            NSMutableDictionary *flatCategoryToAddSelected = [[Ushahidi sharedInstance] flatCategoryToAddSelected];
            USHCategory *category = [flatCategoryToAddSelected objectForKey:key];
            USHCategory *categoryDic = [flatCategoryToAdd objectForKey:key];
            
            if ( [self getSelected] == -1 )
            {
                selectedNode.isSelected = true;
                [self setIsDisabled:selectedNode.id];
                category = categoryDic;
                if (category!=NULL)
                {
                    [report addCategoriesObject:category];
                    [flatCategoryToAddSelected setObject:category forKey:key];
                }
            }else{
                if ( selectedNode.isSelected == true)
                {
                    selectedNode.isSelected = false;
                    if (category!=nil)
                    {
                        [report removeCategoriesObject:category];
                        [flatCategoryToAddSelected removeObjectForKey:key];
                    }
                    [self resetIsDisabled];
                }
            }
            
            /*
            if( [[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox_checked.png"]])
            {
                [button setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
                if (category!=nil)
                {
                    [report removeCategoriesObject:category];
                    [flatCategoryToAddSelected removeObjectForKey:key];
                }
                selected = -1;
                //NSLog(@"set ---------- selected %i",selected);
            }
            else
            {
                
                category = categoryDic;
                if (category!=NULL)
                {
                    [button setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
                    [report addCategoriesObject:category];
                    [flatCategoryToAddSelected setObject:category forKey:key];
                }
            }
            */
            [self.tableView reloadData];
            break;
        }
    }
  
    NSLog(@"BEGIN CLICK CHECK ----");
}

- (void)setCildren:(NSString *)value node:(MDTreeNode *)selectedNode withCell:(NSString *)refreshImageCheck {
    NSMutableDictionary *dictionary = [[Ushahidi sharedInstance] flatCategorySelected];
    
    NSMutableArray *children = selectedNode.children;
    for (MDTreeNode *child in children) {
        [dictionary setValue:value forKey:(NSString *)child.id];
        [self setCildren:value node:child withCell:refreshImageCheck];
        if ([refreshImageCheck isEqual:@"YES"] ) [self setCell:child.id numberRows: [[[MDTreeAddNodeStore sharedStore] allNodes] count] value:value];
    }
}

- (void)setCell:(NSNumber *)index numberRows:(NSInteger) rows value:(NSString *)check{

    for ( NSInteger i = 0; i < rows;i++){
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        MDTreeAddViewCell *pp = (MDTreeAddViewCell *) [[self tableView] cellForRowAtIndexPath:path];
        if (pp.buttonCheck.tag == index ){
            if ( [check isEqualToString:@"YES"]){
                [pp.buttonCheck setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
            }else{
                [pp.buttonCheck setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
            }
        }
    }
}

/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [self dismissModalViewControllerAnimated:YES];
}
*/

/*
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 MDTreeAddNodeStore *store = [MDTreeAddNodeStore sharedStore];
 NSArray *items = [store allNodes];
 MDTreeNode *n = [items objectAtIndex:[indexPath row]];
 NSLog(@"deleting row %d", [indexPath row]);
 MDTreeAddViewCell *cell =
 (MDTreeAddViewCell *)[tableView cellForRowAtIndexPath:indexPath];
 
 NSArray *childrenToReload;
 // no need to reload children if they're removed with the parent
 // but if they're not removed with the parent, we need to get those
 // before changes to the store were applied
 if ([cell isExpanded])
 {
 childrenToReload = [n flatten];
 [store removeNode:n];
 } else
 [store removeNodeWithChildren:n];
 
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
 withRowAnimation:UITableViewRowAnimationFade];
 
 // no need to reload children if they're removed with the parent
 if (![cell isExpanded])
 return;
 
 NSMutableArray *indexPathsToReload = [NSMutableArray array];
 // reloading all items to get refreshed indexes
 items = [store allNodes];
 for (MDTreeNode *nodeToReload in childrenToReload)
 {
 NSUInteger index = [items indexOfObjectIdenticalTo:nodeToReload];
 
 [indexPathsToReload addObject:[NSIndexPath indexPathForRow:index
 inSection:0]];
 }
 
 [tableView beginUpdates];
 [tableView reloadRowsAtIndexPaths:indexPathsToReload
 withRowAnimation:UITableViewRowAnimationFade];
 [tableView endUpdates];
 }
 }
 */

/*
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)oldPath toIndexPath:(NSIndexPath *)newPath
 {
 MDTreeAddNodeStore *store = [MDTreeAddNodeStore sharedStore];
 NSArray *items = [store allNodes];
 MDTreeNode *n = [items objectAtIndex:[oldPath row]];
 MDTreeAddViewCell *cell =
 (MDTreeAddViewCell *)[tableView cellForRowAtIndexPath:oldPath];
 
 NSArray *childrenToReload;
 
 // no need to reload children if they're moved with the parent
 // but if they're not moved with the parent, we need to get those
 // before changes to the store were applied
 if ([cell isExpanded])
 childrenToReload = [n flatten];
 
 NSInteger oldRow = [oldPath row];
 NSInteger newRow = [newPath row];
 
 if (![cell isExpanded])
 [store moveNodeAtRowWithChildren:oldRow toRow:newRow];
 else
 [store moveNodeAtRow:oldRow toRow:newRow];
 
 [cell setIndentationLevel:[self tableView:[self tableView]
 indentationLevelForRowAtIndexPath:newPath]];
 [cell setNeedsLayout];
 
 // no need to reload children if they're moved with the parent
 if (![cell isExpanded])
 return;
 
 // reloading all items to get refreshed indexes
 items = [store allNodes];
 for (MDTreeNode *nodeToReload in childrenToReload)
 {
 NSUInteger row = [items indexOfObjectIdenticalTo:nodeToReload];
 NSIndexPath *indexPathToUpdate =
 [NSIndexPath indexPathForRow:row inSection:0];
 
 UITableViewCell *cell =
 [[self tableView] cellForRowAtIndexPath:indexPathToUpdate];
 [cell setIndentationLevel:[self tableView:[self tableView]
 indentationLevelForRowAtIndexPath:indexPathToUpdate]];
 [cell setNeedsLayout];
 }
 }
 
 - (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
 {
 
 }
 */
@end
