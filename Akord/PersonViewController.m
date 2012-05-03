//
//  PersonViewController.m
//  Akord
//
//  Created by Kevin McMillin on 5/3/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController ()

@end

@implementation PersonViewController

@synthesize person;
@synthesize dbManager;
@synthesize messages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dbManager = [[DBManager alloc] init];
        messages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void) getMessagesFromTime:(NSDate*) startDate toEndTime:(NSDate*) endDate
{
    messages = [dbManager getMessagesForPerson:person.emailAddress fromStartDate:startDate andEndDate:endDate];
}

@end
