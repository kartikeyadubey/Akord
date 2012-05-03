//
//  ClusterViewController.m
//  Akord
//
//  Created by Kevin McMillin on 5/3/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "ClusterViewController.h"

@implementation ClusterViewController
@synthesize canvas;
@synthesize cluster, messages;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init{
    self = [super init];
    if(self){
        cluster = [[Cluster alloc] init];
        messages = [NSMutableArray array];
        canvas = [[ClusterViewCanvas alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.canvas setBackgroundColor:[UIColor blackColor]];
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


-(void) getMessagesFromStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate
{
    self.canvas.messages = [[DBManager sharedManager] getMessagesForClusterWithID:cluster.clusterId fromStartDate:startDate andEndDate:endDate];
    self.canvas.cluster = self.cluster;
    [self.canvas processMessagesFromStartDate:startDate andEndDate:endDate];
    [self.canvas setNeedsDisplay];
}
@end
