//
//  USHCustomFieldSingleViewController.m
//  App
//
//  Created by Cristiano Carducci on 15/05/14.
//  Copyright (c) 2014 Ushahidi. All rights reserved.
//

#import "USHCustomFieldSingleViewController.h"

@interface USHCustomFieldSingleViewController ()

@end

@implementation USHCustomFieldSingleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_back release];
    [_reset release];
    [super dealloc];
}
- (IBAction)resetev:(id)sender {
}

- (IBAction)backev:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
