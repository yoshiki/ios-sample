//
//  DetailViewController.m
//  F8SlideView
//
//  Created by Kurihara Yoshiki on 12/04/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

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
    
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    self.view.layer.shadowRadius = 1.0;
    self.view.layer.shadowOffset = CGSizeMake(-5, 0);
    self.view.layer.shadowOpacity = 0.3;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(handleBack:)];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) handleBack:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

@end
