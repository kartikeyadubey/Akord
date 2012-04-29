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
@synthesize tempPeopleCircle;

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
    //TODO REMOVE THIS, ONLY FOR TESTING
    [self findPeopleStartAndEnd:CGPointMake(0, 20) withRadius:10];
    
    [dbManager getMessagesForClusterWithID:0 fromStartDate:NULL andEndDate:NULL];
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
    int maxWidthRange = self.frame.size.width - margin;
    int minHeightRange = margin;
    int maxHeightRange = self.frame.size.height - 150;
    for(Cluster *c in clusters){
        int people = c.numberOfPeople;
        int messages = c.numberOfMessages;
        float xPos = [self mappingFunction:1 andInitialRangeMax:maxPeople andFinalRangeMin:minWidthRange andFinalRangeMax:maxWidthRange andValue:people];
        float yPos = [self mappingFunction:1 andInitialRangeMax:maxMessages andFinalRangeMin:minHeightRange andFinalRangeMax:maxHeightRange andValue:messages];
        yPos = (maxHeightRange)-(yPos - minHeightRange);
        c.coordinate = CGPointMake(xPos, yPos);
        c.radius = (arc4random()%50)+1;
        //c.radius = 2;
    }
    [self setNeedsDisplay];
}

- (float) mappingFunction:(int) initMin andInitialRangeMax:(int) initMax andFinalRangeMin:(int)finalMin andFinalRangeMax:(int)finalMax andValue:(int) value{
    float newValue = ((float)((value-initMin)*(finalMax-finalMin))/(float)(initMax-initMin))+finalMin;
    //NSLog(@"NewValue:%f, initMin:%d, initMax:%d, finalMin:%d, finalMax:%d, Value: %d", newValue,initMin,initMax,finalMin,finalMax,value);
    return newValue;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //NSLog(@"Draw rectangle");
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	//CGContextSetLineWidth(context, 5.0);
	//[[UIColor blueColor] setStroke];
    
    //Draw all the clusters
    for(Cluster *c in self.clusters)
    {
        [self drawCluster:c.coordinate withRadius:c.radius inContext:context];
    }
    
    for(NSValue *v in self.tempPeopleCircle)
    {
        CGPoint p = [v CGPointValue];
        CGContextFillRect(context, CGRectMake(p.x,p.y,1,1));
    }
}


- (void)drawCluster:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    float R = [self mappingFunction:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:142];
    float G = [self mappingFunction:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:206];
    float B = [self mappingFunction:0 andInitialRangeMax:255 andFinalRangeMin:0 andFinalRangeMax:1 andValue:236];
    UIColor *ringColor = [[UIColor alloc] initWithRed:R green:G blue:B alpha:1.0];
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
    tempPeopleCircle = [[NSMutableArray alloc] init];
    
    int i = 0;
    NSLog(@"Point @ %d: %@", i, [NSStringFromCGRect(self.frame) description]);

    while(i < 360)
    {
        CGPoint rotatePoint = [self rotatedPoint:startingTestPoint withAngle:i aroundCenter: centerOfCircle];
        if(CGRectContainsPoint(self.frame, rotatePoint))
        {   
            if(i%5==0)
                NSLog(@"Point @ %d: %f, %f", i, rotatePoint.x, rotatePoint.y);
            if(!foundStartPoint){
                foundStartPoint = true;
                startAngle = i;
            }
            if(i > endAngle){
                endAngle = i;
            }
//            if(!startPoint)
//            {
//                startPoint = true;
//                NSLog(@"%f, %f", rotatePoint.x, rotatePoint.y);
//                [retVal addObject:[NSValue valueWithCGPoint:rotatePoint]];
//            }
//            else if(startPoint && !endPoint)
//            {
//                endPoint = true;
//                NSLog(@"%f, %f", rotatePoint.x, rotatePoint.y);
//                [retVal addObject:[NSValue valueWithCGPoint:rotatePoint]];
//            }
        }
        [tempPeopleCircle addObject:[NSValue valueWithCGPoint:rotatePoint]];
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

@end
