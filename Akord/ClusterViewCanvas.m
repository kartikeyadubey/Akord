//
//  ClusterViewCanvas.m
//  Akord
//
//  Created by Kartikeya Dubey on 5/3/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "ClusterViewCanvas.h"

@implementation ClusterViewCanvas
@synthesize cluster;
@synthesize messages;
@synthesize emailColors;
@synthesize processedMessages;
@synthesize emailHeights;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        emailColors = [[NSMutableDictionary alloc] init];
        messages = [[NSMutableArray alloc] init];
        processedMessages = [[NSMutableArray alloc] init];
        emailHeights = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for(ClusterPoint *cp in processedMessages){
        CGContextAddArc(context, cp.point.x, cp.point.y,  cp.radius, 0, 2*M_PI, YES);
        NSLog(@"Y coordinate: %f", cp.point.y);
        CGContextSetLineWidth(context, 5);
        CGContextSetStrokeColorWithColor(context, [cp.color CGColor]);
        CGContextStrokePath(context);
    }
}

-(void) processMessagesFromStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    int i = 1;
    NSMutableDictionary *tempColorsDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *tempHeightsDict = [[NSMutableDictionary alloc] init];
    
    for (NSString *str in cluster.emailAddresses)
    {
        NSLog(@"%@", [[tempColorsDict allKeys] description]);
        
        CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
        CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
        CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
        [tempColorsDict setObject:[UIColor colorWithRed:red green:green blue:blue alpha:0.5] forKey:str];
        i++;
    }
    emailColors = tempColorsDict;
    
    i = 1;
    for(NSString *str in cluster.emailAddresses)
    {
        float heightForEach = [self mapWithInitialRangeMin:1 andInitialRangeMax:[[tempColorsDict allKeys] count] andFinalRangeMin:100 andFinalRangeMax:575 andValue:i];
        [tempHeightsDict setObject:[NSNumber numberWithInt:heightForEach] forKey:str];
        i++;
    }
    emailHeights = tempHeightsDict;
    long long maxTime = (long long)[startDate timeIntervalSince1970];
    long long minTime = (long long)[endDate timeIntervalSince1970];
    NSMutableArray *tempMessages = [[NSMutableArray alloc] init];
    for(Message *m in messages)
    {
            ClusterPoint *cp = [[ClusterPoint alloc] init];
            cp.color = [tempColorsDict objectForKey:m.froms];
            cp.radius = m.mSize/100;
            //TODO: GET X
        float x = [self bigMapWithInitialRangeMin:minTime andInitialRangeMax:maxTime andFinalRangeMin:100 andFinalRangeMax:self.bounds.size.width-100 andValue:m.mDate];
            cp.point = CGPointMake(x, [[tempHeightsDict objectForKey:m.froms] floatValue]);
        [tempMessages addObject:cp];
    }
    self.processedMessages = tempMessages;
}

- (float) bigMapWithInitialRangeMin:(long long) initMin andInitialRangeMax:(long long) initMax andFinalRangeMin:(long long)finalMin andFinalRangeMax:(long long)finalMax andValue:(long long) value{
        long long val1 = (value-initMin);
        long long val2 = (finalMax-finalMin);
        long long val3 = (initMax-initMin);
        
        long long val4 = (val1*val2);
        long long val5 = val4/val3;
        long long newValue = val5 + finalMin;
        return (float)newValue;
    }
- (float) mapWithInitialRangeMin:(int) initMin andInitialRangeMax:(int) initMax andFinalRangeMin:(int)finalMin andFinalRangeMax:(int)finalMax andValue:(int) value{
    
    int val1 = (value-initMin);
    int val2 = (finalMax-finalMin);
    int val3 = (initMax-initMin);
    
    int val4 = (val1*val2);
    float val5 = val4/val3;
    int newValue = val5 + finalMin;
        
    //float newValue = ((float)((value-initMin)*(finalMax-finalMin))/(float)(initMax-initMin))+finalMin;
        NSLog(@"NewValue:%d, initMin:%d, initMax:%d, finalMin:%d, finalMax:%f, Value: %d", val1,val2,val3,val4,val5,newValue);
    return newValue;
}

@end
