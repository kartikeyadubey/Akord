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
@synthesize drawPeople;
@synthesize people;

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
}

- (void) getClusters:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    [dbManager getMessagesForClusterWithID:0 fromStartDate:NULL andEndDate:NULL];
    [clusters removeAllObjects];
    clusters = [dbManager getClustersFromStartDate:startDate andEndDate:endDate];
    int maxPeople = -1;
    int maxMessages = -1;
    int maxSize = -1;
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
        if(c.messagesSize > maxSize){
            maxSize = c.messagesSize;
        }
    }
  
    int margin = 100;
    int minWidthRange = margin;
    int maxWidthRange = self.frame.size.width - margin;
    int minHeightRange = margin;
    int maxHeightRange = self.frame.size.height - 150;
    for(Cluster *c in clusters){
        int people = c.numberOfPeople;
        int messages = c.numberOfMessages;
        float xPos = [self mapWithInitialRangeMin:1 andInitialRangeMax:maxPeople andFinalRangeMin:minWidthRange andFinalRangeMax:maxWidthRange andValue:people];
        float yPos = [self mapWithInitialRangeMin:1 andInitialRangeMax:maxMessages andFinalRangeMin:minHeightRange andFinalRangeMax:maxHeightRange andValue:messages];
        yPos = (maxHeightRange)-(yPos - minHeightRange);
        c.coordinate = CGPointMake(xPos, yPos);
        c.radius = [self mapWithInitialRangeMin:1 andInitialRangeMax:maxSize andFinalRangeMin:20 andFinalRangeMax:100 andValue:c.messagesSize];
    }
    [self setNeedsDisplay];
}

- (float) mapWithInitialRangeMin:(int) initMin andInitialRangeMax:(int) initMax andFinalRangeMin:(int)finalMin andFinalRangeMax:(int)finalMax andValue:(int) value{
    float newValue = ((float)((value-initMin)*(finalMax-finalMin))/(float)(initMax-initMin))+finalMin;
    //NSLog(@"NewValue:%f, initMin:%d, initMax:%d, finalMin:%d, finalMax:%d, Value: %d", newValue,initMin,initMax,finalMin,finalMax,value);
    return newValue;
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
//        NSLog(@"%lu, %d", c.messagesSize, c.radius);
        [self drawCluster:c.coordinate withRadius:c.radius inContext:context];
    }
    
    for(NSValue *point in people)
    {
        CGPoint centerCoordinate = [point CGPointValue];
        float R = [self mapWithInitialRangeMin:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:142];
        float G = [self mapWithInitialRangeMin:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:206];
        float B = [self mapWithInitialRangeMin:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:236];
        UIColor *ringColor = [[UIColor alloc] initWithRed:R green:G blue:B alpha:0.5];
        CGContextAddArc(context, centerCoordinate.x, centerCoordinate.y, 10, 0, 2*M_PI, YES);
        CGContextSetLineWidth(context, 5);
        CGContextSetStrokeColorWithColor(context,[ringColor CGColor]);
        CGContextStrokePath(context);
    }
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
    NSLog(@"Point @ %d: %@", i, [NSStringFromCGRect(self.frame) description]);

    while(i < 360)
    {
        CGPoint rotatePoint = [self rotatedPoint:startingTestPoint withAngle:i aroundCenter: centerOfCircle];
        if(CGRectContainsPoint(self.frame, rotatePoint))
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
    NSLog(@"%@", [retVal description]);
    
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
    Cluster *currentCluster = [[Cluster alloc] init];
    for (Cluster* c in self.clusters) {
        if (c.clusterId == clusterID) {
            currentCluster = c;
        }
    }

    
    //TODO: REMOVE THIS BY FINDING OUT WHAT DISTANCE FROM THE CLUSTER PEOPLE SHOULD BE DRAWN
    int checkRadius = 50 + currentCluster.radius;
    
    NSArray *angles = [self findPeopleStartAndEnd:currentCluster.coordinate withRadius:checkRadius];
    
    NSLog(@"Angles: %@", angles);
    NSNumber* startAngle = [angles objectAtIndex:0];
    NSNumber* endAngle = [angles objectAtIndex:1];
   
    [self drawPeopleFromAngle:startAngle toAngle:endAngle forCluster: currentCluster];
    
}


-(void) drawPeopleFromAngle:(NSNumber*) startAngle toAngle:(NSNumber*) endAngle forCluster:(Cluster*) cluster
{
    NSMutableArray *peopleCoordinates = [[NSMutableArray alloc] init];
    int theta = [endAngle intValue] - [startAngle intValue];
    
    float perimeter = theta*2*M_PI*cluster.radius/360;
    NSLog(@"Perimeter: %f", perimeter);
    //TODO: THIS IS ASSUMING EACH PERSON DRAW IS 50px
    int numPeople = perimeter/50;
    float anglePerPerson = theta/numPeople;
    NSLog(@"Angle per person: %f" , anglePerPerson);
    //ASSUMPTION OF 50
    CGPoint startingTestPoint = CGPointMake(cluster.coordinate.x, cluster.coordinate.y - cluster.radius - 30);
    
    int angleToDraw = [startAngle intValue];
    for(int i = 0; i < numPeople; i++)
    {
        
        [peopleCoordinates addObject:[NSValue valueWithCGPoint:[self rotatedPoint:startingTestPoint withAngle:angleToDraw aroundCenter:cluster.coordinate]]];
        angleToDraw += anglePerPerson;
    }
    
    NSLog(@"Coordinates for people: %@", [peopleCoordinates description]);
    people = [[NSMutableArray alloc] initWithArray:peopleCoordinates];
    
    [self setNeedsDisplay];
    
    
}
@end
