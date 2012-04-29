//
//  ViewController.m
//  Akord
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "ViewController.h"
#import "RangeSlider.h"

@implementation ViewController
@synthesize canvas;
@synthesize toolbar;
@synthesize invisibleButton;


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
    
    RangeSlider *slider=  [[RangeSlider alloc] initWithFrame:CGRectMake(0, 0, 600, toolbar.frame.size.height)];
    slider.minimumValue = 1;
    slider.selectedMinimumValue = 2;
    slider.maximumValue = 10;
    slider.selectedMaximumValue = 8;
    slider.minimumRange = 2;
    [slider addTarget:self action:@selector(updateRangeLabel:) forControlEvents:UIControlEventValueChanged];

    [self.toolbar addSubview:slider];
}

- (void)viewDidUnload
{
    [self setCanvas:nil];
    [self setCanvas:nil];
    [self setToolbar:nil];
    [self setInvisibleButton:nil];
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
        [self performSegueWithIdentifier:@"ToPersonPage" sender:self];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [dateFormatter dateFromString:@"2012-04-01"];    
        NSDate *endDate = [dateFormatter dateFromString:@"2012-04-28"];    
        [self.canvas getClusters:startDate andEndDate:endDate];
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

-(void)updateRangeLabel:(RangeSlider *)slider{
    //NSLog(@"Slider Range: %f - %f", slider.selectedMinimumValue, slider.selectedMaximumValue);
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
