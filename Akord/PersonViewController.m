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
@synthesize canvas;
@synthesize messages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id) init {
    self = [super init];
    if(self){
        dbManager = [[DBManager alloc] initWithPath];
        messages = [[NSMutableArray alloc] init];
        canvas = [[PersonViewCanvas alloc] init];
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
    [self setCanvas:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void) getMessagesFromTime:(NSDate*) startDate toEndTime:(NSDate*) endDate
{
    self.canvas.messages = [[DBManager sharedManager] getMessagesForPerson:person.emailAddress fromStartDate:startDate andEndDate:endDate];
    [self.canvas processMessages];
    [self.canvas setNeedsDisplay];
}

@end
