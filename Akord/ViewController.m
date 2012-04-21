//
//  ViewController.m
//  Akord
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize canvas;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib
    self.canvas.clusters = [[NSMutableArray alloc] init];
    
    Cluster *c = [[Cluster alloc] init];
    c.coordinate = CGPointMake(200, 200);
    c.clusterId = 0;
    [self.canvas.clusters addObject:c];
    
    DBManager *dbMan = [[DBManager alloc]init];
    for(Cluster *c in [dbMan getClustersFromDB:@"/Users/kartikeyadubey/Documents/Classes/Spring 2012/iPad/EmailData.sqlite"])
    {
        NSLog(@"%@", [c.emailAddresses objectAtIndex:0]);
    }
}

- (void)viewDidUnload
{
    [self setCanvas:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


//Single click on a cluster
- (IBAction)singleTap:(UIGestureRecognizer*)sender {
    if([self clusterUnderPoint:[sender locationInView:self.view]])
    {
        NSLog(@"Create interaction here");
    }
    else
    {
        NSLog(@"No cluster was found");
    }
}

-(Cluster*)clusterUnderPoint:(CGPoint) handPoint
{
    for(Cluster *c in self.canvas.clusters)
    {
        if([self getDistance:c.coordinate and:handPoint] < 30.0)
        {
            return c;
        }
    }
    return nil;
}

//Get the distance between two cgpoints
-(double)getDistance:(CGPoint)firstPoint and:(CGPoint)secondPoint
{
    double distance = sqrt(pow((firstPoint.x - secondPoint.x), 2.0) + pow((firstPoint.y - secondPoint.y), 2.0));
    
    return distance;
}


@end
