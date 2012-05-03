//
//  ViewController.m
//  Akord
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "ViewController.h"
#import "RangeSlider.h"
#import "SVProgressHUD.h"

@implementation ViewController
@synthesize canvas;
@synthesize toolbar;
@synthesize invisibleButton;
@synthesize slider;
@synthesize leftLabel;
@synthesize rightLabel;

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
    float R = [self mappingFunction:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:255];
    float G = [self mappingFunction:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:255];
    float B = [self mappingFunction:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:255];
    
    UIColor *color = [[UIColor alloc] initWithRed:R green:G blue:B alpha:1.0];
    [self.canvas setBackgroundColor:color];
    //[self.canvas setBackgroundColor:[UIColor brownColor]];
    Cluster *c = [[Cluster alloc] init];
    c.coordinate = CGPointMake(200, 200);
    c.clusterId = 0;
    [self.canvas.clusters addObject:c];
    [self.canvas allocDB];
    
    slider= [[RangeSlider alloc] initWithFrame:CGRectMake(145, 0, 600, toolbar.frame.size.height)];
    NSArray *vals = [self.canvas.dbManager getMinAndMaxTime];
    float max = [[vals objectAtIndex:1] floatValue];
    float min = [[vals objectAtIndex:0] floatValue];
    float avg = (max+min)/2;
    slider.minimumValue = min;
    slider.selectedMinimumValue = avg-(max-min)/20;
    slider.maximumValue = max;
    slider.selectedMaximumValue = avg+(max-min)/20;
    slider.minimumRange = (max-min)/10;
    leftLabel.text = [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:[[NSNumber numberWithFloat:slider.selectedMinimumValue] doubleValue]]
                                                    dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    rightLabel.text = [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:[[NSNumber numberWithFloat:slider.selectedMaximumValue] doubleValue]]
                                                     dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]; 
    
    [slider addTarget:self action:@selector(getClusters) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(updateRangeLabel) forControlEvents:UIControlEventValueChanged];
    [self.toolbar addSubview:slider];
}

- (void)viewDidUnload
{
    [self setCanvas:nil];
    [self setCanvas:nil];
    [self setToolbar:nil];
    [self setInvisibleButton:nil];
    [self setLeftLabel:nil];
    [self setRightLabel:nil];
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
    
    [self getClusters];
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
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


-(void) getClusters{
    [SVProgressHUD showWithStatus:@"Reloading..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.canvas getClusters:[NSDate dateWithTimeIntervalSince1970:[[NSNumber numberWithFloat:slider.selectedMinimumValue] doubleValue]]
                  andEndDate:[NSDate dateWithTimeIntervalSince1970:[[NSNumber numberWithFloat:slider.selectedMaximumValue] doubleValue]]];
        [SVProgressHUD dismiss];
    });
}

//Single click on a cluster
- (IBAction)singleTap:(UIGestureRecognizer*)sender {
    Cluster* cluster = [self clusterUnderPoint:[sender locationInView:self.view]];
    //If people aren't drawn and a cluster was found then do cluster stuff
    if(cluster)
    {
        //THIS should not be here
        //[self performSegueWithIdentifier:@"ToPersonPage" sender:self];
        
        //TODO: FIX ACCORDING TO 50
        self.canvas.drawPeople = true;
        [self.canvas drawPeopleOnClustersPage:cluster.clusterId];
    }
    //Otherwise if people are drawn check if there is a person underneath the click
    else if(self.canvas.drawPeople)
    {
        Person *person = [self personUnderPoint:[sender locationInView:self.view]];
        //Person was found then do person stuff
        if(person)
        {
            [self.canvas drawPersonDetailsOnClustersPage:person];
            self.canvas.drawPeople = false;
            [self.canvas setNeedsDisplay];
        }
        else
        {
            self.canvas.drawPeople = false;
            [self.canvas setNeedsDisplay];
        }
    }
    else
    {
        self.canvas.drawPeople = false;
        self.canvas.currentPerson = nil;
    }
}

/*
 * Check if there is a person underneath the point touched by the user
 */
-(Person*) personUnderPoint:(CGPoint) handPoint
{
    for(Person *p in self.canvas.peopleCircle)
    {
        //TODO: THIS NUMBER SHOULD NOT BE 20 BUT SOMETHING BASED ON THE RADIUS OF THE SMALL CIRCLES BEING DRAWN
        if([self getDistance:p.coordinate and:handPoint] <= 20)
        {
            return p;
        }
    }
    
    return nil;
}

//TODO: OPTIMIZE FOR PRECISE TOUCHES AND MULTIPLE CONCENTRIC CIRCLES
-(Cluster*)clusterUnderPoint:(CGPoint) handPoint
{
    for(Cluster *c in self.canvas.clusters)
    {
        if([self getDistance:c.coordinate and:handPoint] <= c.radius)
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

-(void)updateRangeLabel{
    leftLabel.text = [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:[[NSNumber numberWithFloat:self.slider.selectedMinimumValue] doubleValue]]
                                                    dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    rightLabel.text = [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:[[NSNumber numberWithFloat:self.slider.selectedMaximumValue] doubleValue]]
                                                     dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
}

- (float) mappingFunction:(int) initMin andInitialRangeMax:(int) initMax andFinalRangeMin:(int)finalMin andFinalRangeMax:(int)finalMax andValue:(int) value{
    float newValue = ((float)((value-initMin)*(finalMax-finalMin))/(float)(initMax-initMin))+finalMin;
    return newValue;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@", [[touch.view class] description]);
    NSLog(@"Type: %@", NSStringFromCGRect(self.view.frame));
    if ([touch.view isKindOfClass:[UIControl class]]){
        return NO;
    }
    return YES;
}

@end
