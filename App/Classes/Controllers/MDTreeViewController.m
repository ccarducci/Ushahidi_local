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
//#import "MDTreeViewCell.h"
#import <Ushahidi/Ushahidi.h>
#import <Ushahidi/CategoryTreeManager.h>
#import <Ushahidi/CategoryTree.h>
#import "USHSettings.h"

@interface MDTreeViewController ()

@end


@implementation MDTreeViewController


@synthesize mapControllerTree;

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
    
    //[mapControllerTree refreshMap];
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
    NSLog(@"Count in MDTreeViewController: %i",flatCategory.count);
    CategoryTreeManager *operazione = [[CategoryTreeManager alloc] init];
    [operazione createTree:flatCategory];
    NSMutableDictionary *flatOnlyCategoryYES = [[Ushahidi sharedInstance] flatOnlyCategoryYES];
    [flatOnlyCategoryYES removeAllObjects];
    [operazione dealloc];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    #warning Potentially incomplete method implementation.

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


@end
