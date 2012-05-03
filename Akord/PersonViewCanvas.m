//
//  PersonViewCanvas.m
//  Akord
//
//  Created by Kartikeya Dubey on 5/3/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "PersonViewCanvas.h"
#import "PersonPoint.h"

@implementation PersonViewCanvas
@synthesize messages;
@synthesize messageDisplay;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id) init {
    self = [super init];
    if(self){
        messages = [[NSMutableArray alloc] init];
        messageDisplay = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for(NSString *key in messageDisplay){
        PersonPoint *pp = [messageDisplay objectForKey:key];
        UIColor *ringColor = [UIColor orangeColor];
        CGContextAddArc(context, pp.point.x, pp.point.y,  pp.count*5, 0, 2*M_PI, YES);
        CGContextSetLineWidth(context, 5);
        CGContextSetStrokeColorWithColor(context,[ringColor CGColor]);
        CGContextStrokePath(context);
    }
}

-(void) processMessages
{
    NSMutableDictionary *pts = [NSMutableDictionary dictionaryWithCapacity:24*7];
    int x;
    int y;
    NSDateFormatter *dfX = [[NSDateFormatter alloc] init];
    NSDateFormatter *dfY = [[NSDateFormatter alloc] init];
    [dfX setDateFormat:@"H"];
    [dfY setDateFormat:@"c"];
    for (Message *m in messages) {
        x = [[dfX stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[NSNumber numberWithInt:m.mDate] doubleValue]]] intValue];
        y = [[dfY stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[NSNumber numberWithInt:m.mDate] doubleValue]]] intValue];
        PersonPoint *pp = [[PersonPoint alloc] init];
        pp.point = CGPointMake(1024/24*x, 660/7*y);
        if([pts objectForKey:[NSString stringWithFormat:@"%d,%d", x, y]] != nil){
            pp.count = [[pts objectForKey:[NSString stringWithFormat:@"%d,%d",x,y]] count] + 1;
            [pts setObject:pp forKey:[NSString stringWithFormat:@"%d,%d", x,y]];
        }
        else{
            pp.count = 1;
            [pts setObject:pp forKey:[NSString stringWithFormat:@"%d,%d",x,y]];
        }
    }
    messageDisplay = pts;
    NSLog(@"%@", [pts description]);
}
@end
