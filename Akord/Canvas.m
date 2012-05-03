//
//  Canvas.m
//  Akord
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "Canvas.h"
#define degreesToRadians(x) (M_PI * x / 180.0)

@implementation Canvas

@synthesize clusters;
@synthesize dbManager;
@synthesize peopleCircle;
@synthesize currentPerson;
@synthesize clustersDrawn;
@synthesize peopleDrawn;
@synthesize peopleArcsDrawn;
@synthesize currentCluster;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void) allocDB
{
    dbManager = [[DBManager alloc] initWithPath];
    peopleCircle = [[NSMutableArray alloc] init];
    currentPerson = [[Person alloc] init];
}

- (void) getClusters:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    [clusters removeAllObjects];
    clusters = [dbManager getClustersFromStartDate:startDate andEndDate:endDate];
    int maxPeople = -1;
    int maxMessages = -1;
    for (Cluster *c in clusters) {
        int numPeopleInGrp = [c.emailAddresses count];
        c.numberOfPeople = numPeopleInGrp;
        if(numPeopleInGrp>maxPeople){
            maxPeople = numPeopleInGrp;
        }
        int numMessages = c.numberOfMessages;
        if(numMessages > maxMessages){
            maxMessages = numMessages;
        }
    }
  
    int margin = 100;
    int minWidthRange = margin;
    int maxWidthRange = self.bounds.size.width - margin;
    int minHeightRange = margin;
    int maxHeightRange = self.bounds.size.height - 150;
    for(Cluster *c in clusters){
        float xPos = [self bigMapWithInitialRangeMin:(long long)[startDate timeIntervalSince1970] andInitialRangeMax:(long long)[endDate timeIntervalSince1970] andFinalRangeMin:minWidthRange andFinalRangeMax:maxWidthRange andValue:c.averageTime];
        //NSLog(@"xPos: %f time: %d start: %d end: %d", xPos, c.averageTime, (int)[startDate timeIntervalSince1970], (int)[endDate timeIntervalSince1970]);
        float yPos = [self mapWithInitialRangeMin:1 andInitialRangeMax:maxMessages andFinalRangeMin:minHeightRange andFinalRangeMax:maxHeightRange andValue:c.numberOfMessages];
        yPos = (maxHeightRange)-(yPos - minHeightRange);
        c.coordinate = CGPointMake(xPos, yPos);
        c.radius = [self mapWithInitialRangeMin:1 andInitialRangeMax:maxMessages andFinalRangeMin:22 andFinalRangeMax:100 andValue:c.numberOfPeople];
    }
    [self setNeedsDisplay];
}

- (float) mapWithInitialRangeMin:(int) initMin andInitialRangeMax:(int) initMax andFinalRangeMin:(int)finalMin andFinalRangeMax:(int)finalMax andValue:(int) value{
    float newValue = ((float)((value-initMin)*(finalMax-finalMin))/(float)(initMax-initMin))+finalMin;
//    NSLog(@"NewValue:%f, initMin:%d, initMax:%d, finalMin:%d, finalMax:%d, Value: %d", newValue,initMin,initMax,finalMin,finalMax,value);
    return newValue;
}

- (float) bigMapWithInitialRangeMin:(long long) initMin andInitialRangeMax:(long long) initMax andFinalRangeMin:(long long)finalMin andFinalRangeMax:(long long)finalMax andValue:(long long) value{
    long long val1 = (value-initMin);
    long long val2 = (finalMax-finalMin);
    long long val3 = (initMax-initMin);
    
    long long val4 = (val1*val2);
    long long val5 = val4/val3;
    long long newValue = val5 + finalMin;
    return (float) newValue;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Draw all the clusters
    for(Cluster *c in self.clusters)
    {
        [self drawCluster:c.coordinate withRadius:c.radius inContext:context];
    }
    
    if(peopleDrawn)
    {
        for(Person *person in peopleCircle)
        {
            [self drawPeopleCircles:person inContext:context];
        }   
    }
    
    if(currentPerson){
        for (Cluster *c in clusters) {
            for (NSString* email in c.emailAddresses) {
                if([email isEqualToString:currentPerson.emailAddress])
                {
                    [self drawArcsBetweenPeople:currentPerson.coordinate andClusters:c.coordinate inContext:context];

                }
            }
        }
    }
}

-(void) drawArcsBetweenPeople:(CGPoint) start andClusters:(CGPoint) end inContext:(CGContextRef) context
{
    CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.0, 0.0, 1.0, 1.0};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

-(void) drawPeopleCircles:(Person*) person inContext:(CGContextRef) context
{
    float R = [self mapWithInitialRangeMin:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:142];
    float G = [self mapWithInitialRangeMin:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:206];
    float B = [self mapWithInitialRangeMin:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:236];
    UIColor *ringColor = [[UIColor alloc] initWithRed:R green:G blue:B alpha:1];
    CGContextAddArc(context, person.coordinate.x, person.coordinate.y, 10, 0, 2*M_PI, YES);
    CGContextSetLineWidth(context, 5);
    CGContextSetStrokeColorWithColor(context, [ringColor CGColor]);
    CGContextStrokePath(context);
    CGContextAddArc(context, person.coordinate.x, person.coordinate.y, 10, 0, 2*M_PI, YES);
    CGContextSetLineWidth(context, 5);
    CGContextSetFillColorWithColor(context, [ringColor CGColor]);
    //CGContextStrokePath(context);
    CGContextFillPath(context);
    CGContextSaveGState(context);
    CGContextSelectFont (context, "Helvetica-Bold", 16.0, kCGEncodingMacRoman);
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextTranslateCTM(context,person.coordinate.x, person.coordinate.y);
    CGContextSetTextMatrix (context, CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ), 0));
    int angleAdjustment = person.angleToDraw-90;
    int angleToRotate = 360 + angleAdjustment ;
    CGContextRotateCTM(context, degreesToRadians(angleToRotate));
    CGContextShowTextAtPoint(context, 20, 5,[person.emailAddress cStringUsingEncoding:NSASCIIStringEncoding],[person.emailAddress length]);
    CGContextRestoreGState(context);

}

-(void) drawPersonDetailsOnClustersPage:(Person*) person
{
    NSLog(@"Draw people details and all arcs here");

    self.currentPerson = person;
    
}

- (void)drawCluster:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    float R = [self mapWithInitialRangeMin:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:142];
    float G = [self mapWithInitialRangeMin:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:206];
    float B = [self mapWithInitialRangeMin:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:236];
    UIColor *ringColor = [[UIColor alloc] initWithRed:R green:G blue:B alpha:0.5];
	CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    CGContextSetLineWidth(context, 5);
    CGContextSetStrokeColorWithColor(context,[ringColor CGColor]);
    CGContextStrokePath(context);
}


/* 
 * Figure out where to start drawing and where to end drawing the
 * cluster circles
 */
-(NSMutableArray*) findPeopleStartAndEnd:(CGPoint) centerOfCircle withRadius:(int) radius
{
    BOOL foundStartPoint = NO;
    float startAngle;
    float endAngle = 0;

    //50 has been selected randomly optimize to make it look prettier
    CGPoint startingTestPoint = CGPointMake(centerOfCircle.x, centerOfCircle.y - radius);
    NSMutableArray* retVal = [NSMutableArray array];
    
    int i = 0;

    while(i < 360)
    {
        CGPoint rotatePoint = [self rotatedPoint:startingTestPoint withAngle:i aroundCenter: centerOfCircle];
        if(CGRectContainsPoint(self.bounds, rotatePoint))
        {   
            if(!foundStartPoint){
                foundStartPoint = true;
                startAngle = i;
            }
            if(i > endAngle){
                endAngle = i;
            }
        }
        i += 1;
    }
    [retVal addObject:[NSNumber numberWithFloat:startAngle]];
    [retVal addObject:[NSNumber numberWithFloat:endAngle]];
//    NSLog(@"%@", [retVal description]);
    
    [self setNeedsDisplay];
    return retVal;
}


-(CGPoint) rotatedPoint:(CGPoint) point withAngle:(float) angle aroundCenter:(CGPoint) center
{
    CGPoint retVal;
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(center.x, center.y);
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(degreesToRadians(angle));
    
    CGAffineTransform customRotation = CGAffineTransformConcat(CGAffineTransformConcat( CGAffineTransformInvert(translateTransform), rotationTransform), translateTransform);
    
    retVal = CGPointApplyAffineTransform(point, customRotation);
    
    return retVal;
}

//Draw the people for a specified cluster on the canvas
-(void) drawPeopleOnClustersPage:(int) clusterID
{
    [peopleCircle removeAllObjects];
    
    //TODO: REMOVE THIS BY FINDING OUT WHAT DISTANCE FROM THE CLUSTER PEOPLE SHOULD BE DRAWN
    int checkRadius = 50 + currentCluster.radius;
    
    NSArray *angles = [self findPeopleStartAndEnd:currentCluster.coordinate withRadius:checkRadius];
    NSNumber* startAngle = [angles objectAtIndex:0];
    NSNumber* endAngle = [angles objectAtIndex:1];
   
    [self drawPeopleFromAngle:startAngle toAngle:endAngle forCluster: currentCluster];
    
}


-(void) drawPeopleFromAngle:(NSNumber*) startAngle toAngle:(NSNumber*) endAngle forCluster:(Cluster*) cluster
{
    int theta = [endAngle intValue] - [startAngle intValue];
    
    float perimeter = theta*2*M_PI*cluster.radius/360;

    //TODO: THIS IS ASSUMING EACH PERSON DRAW IS 50px
    int numPeople = MIN(((int) perimeter/15), [cluster.emailAddresses count]);
    //int numPeople = cluster.numberOfPeople;
    
    float anglePerPerson = theta/numPeople;
    //ASSUMPTION OF 50
    CGPoint startingTestPoint = CGPointMake(cluster.coordinate.x, cluster.coordinate.y - cluster.radius - 30);
   
    
    int angleToDraw = [startAngle intValue];
    for(int i = 0; i < numPeople; i++)
    {
        Person *person = [[Person alloc] initWithCoordinate:[self rotatedPoint:startingTestPoint withAngle:angleToDraw aroundCenter:cluster.coordinate] andEmailAddress:[cluster.emailAddresses objectAtIndex:i] andClusterID:cluster.clusterId andAngle:angleToDraw];
        [peopleCircle addObject:person];
        angleToDraw += anglePerPerson;
    }
    
    //NSLog(@"Coordinates for people: %@", [peopleCoordinates description]);
    
    [self setNeedsDisplay];
}
@end
