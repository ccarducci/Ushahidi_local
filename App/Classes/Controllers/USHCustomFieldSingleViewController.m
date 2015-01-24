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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [_back release];
    [_reset release];
    [_testo release];
    [super dealloc];
}
- (IBAction)resetev:(id)sender {
    self.testo.text = nil;
}

- (IBAction)backev:(id)sender {
    _field.value = self.testo.text;
    [self dismissModalViewControllerAnimated:YES];
}
@end
