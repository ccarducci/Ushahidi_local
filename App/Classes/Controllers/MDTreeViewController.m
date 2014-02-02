//
//  MDTreeViewController.m
//  App
//
//  Created by Cristiano Carducci on 01/02/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import "MDTreeViewController.h"
#import <Ushahidi/MDTreeNodestore.h>
#import <Ushahidi/MDTreeNode.h>
#import "MDTreeViewCell.h"
#import <Ushahidi/Ushahidi.h>
#import <Ushahidi/CategoryTreeManager.h>
#import <Ushahidi/CategoryTree.h>
#import "USHSettings.h"
#import <Ushahidi/USHDatabase.h>
#import <Ushahidi/USHCategoriesUtility.h>

@interface MDTreeViewController ()
    @property (strong, nonatomic)  NSArray *nodes;
    @property (nonatomic, strong, readwrite) USHCategory *category;
@end


@implementation MDTreeViewController


@synthesize mapControllerTree;


- (IBAction)done:(id)sender
{
    NSMutableDictionary *dictionary = [[Ushahidi sharedInstance] flatCategorySelected];
    NSMutableArray *flatCategory = [[Ushahidi sharedInstance] flatCategory] ;
    NSMutableDictionary *flatOnlyCategoryYES = [[Ushahidi sharedInstance] flatOnlyCategoryYES];
    
    for (CategoryTree* pp in flatCategory) {
        NSString *selected = [dictionary objectForKey:pp.indetifier];
        pp.selected = selected;
        
        if ([selected isEqual:@"YES"]){
            [flatOnlyCategoryYES setValue:@"YES" forKey:pp.id];
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        // CREO PULSANTE DONE
        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"cat_new", nil)];
        
        UIBarButtonItem *bbi =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonItemStylePlain
         target:self
         action:@selector(done:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];

    }
    
    [[MDTreeNodeStore sharedStore]   removeAll] ;
    NSMutableArray *flatCategory = [[Ushahidi sharedInstance] flatCategory];
    NSMutableDictionary *flatCategorySelected = [[Ushahidi sharedInstance] flatCategorySelected] ;
    NSMutableDictionary *flatOnlyCategoryYES = [[Ushahidi sharedInstance] flatOnlyCategoryYES];
    
    NSLog(@"Count in MDTreeViewController: %i",flatCategory.count);

        
    [USHCategoriesUtility   getCategories:flatCategory
                     flatCategorySelected:flatCategorySelected
                      flatOnlyCategoryYES:flatOnlyCategoryYES];
    
    [flatOnlyCategoryYES removeAllObjects];
    
    CategoryTreeManager *operazione = [[CategoryTreeManager alloc] init];
    [operazione createTree:flatCategory];
    [operazione dealloc];
    
    self.nodes = [[MDTreeNodeStore sharedStore] allNodes];
    int count = self.nodes.count;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // CARICO NIB CELLA
    UINib *nib = [UINib nibWithNibName:@"MDTreeViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"MDTreeViewCell"];
    // BACKGROUND TABLE
    self.tableView.backgroundColor = [[USHSettings sharedInstance] tableBackColor];
    // COLORE NAVIGATION
    self.navigationController.navigationBar.tintColor = [[USHSettings sharedInstance] navBarColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count =[[[MDTreeNodeStore sharedStore] allNodes] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDTreeViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"MDTreeViewCell"];
    
    if (!cell)
    {
        cell =
        [[MDTreeViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                              reuseIdentifier:@"MDTreeViewCell"];
    }
    
    MDTreeNode *n =
    [[[MDTreeNodeStore sharedStore] allNodes]
     objectAtIndex:[indexPath row]];
    
    
    cell.buttonCheck.tag =(NSInteger) n.id;
    cell.buttonRowIndex.tag = [indexPath row];
    [[cell nodeTitleField] setText:[n description]];
    [cell setIndentationWidth:8]; // INDENTAZIONE
    [cell setIsExpanded:[n isExpanded]];
    [cell setHasChildren:([[n children] count] > 0)];

    NSLog(@"-------------------------------"  );
    NSLog(@"buttonCheck.tag - %@" ,(NSString *)cell.buttonCheck.tag );
    NSLog(@"buttonRowIndex.tag  - %d" , cell.buttonRowIndex.tag );
    [cell prepareForReuse];
    NSLog(@"-------------------------------"  );
    return cell;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click %d",indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *nodes = [[MDTreeNodeStore sharedStore] allNodes];
    MDTreeNode *selectedNode = [nodes objectAtIndex:[indexPath row]];
    if ([[selectedNode children] count] < 1)
        return;
    
    // -----------------------
    // SE HA FIGLI VADO AVANTI
    // -----------------------
    MDTreeViewCell *cell =
    (MDTreeViewCell *)[[self tableView] cellForRowAtIndexPath:indexPath];
    [cell spinNodeStateIndicatorWithDuration:0.25];
    
    
    BOOL oldIsExpanded = [selectedNode isExpanded];
    
    if (oldIsExpanded)
    {
        cell.isExpanded = true;
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
    }else{
        // --------------------------
        // SE NON ERA APERTO LO APRO
        // --------------------------
        cell.isExpanded = true;
        [selectedNode setIsExpanded:!oldIsExpanded];
        [cell setIsExpanded:!oldIsExpanded];
        
        NSArray *flattenedChildren = [selectedNode flatten];
        NSMutableArray *rowsToInsert = [[NSMutableArray array] init];
        
        nodes = [[MDTreeNodeStore sharedStore] allNodes];
        
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
        
    }
    
}


@end
