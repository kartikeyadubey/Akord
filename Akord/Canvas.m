//
//  Canvas.m
//  Akord
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "Canvas.h"

@implementation Canvas
@synthesize clusters;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"Draw rectangle");
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextSetLineWidth(context, 5.0);
	[[UIColor blueColor] setStroke];
    
    //Draw all the clusters
    for(Cluster *c in self.clusters)
    {
        [self drawCluster:c.coordinate withRadius:10.0f inContext:context];
    }
}


- (void)drawCluster:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
	UIGraphicsPushContext(context);
	CGContextBeginPath(context);
	CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
	CGContextSetFillColorWithColor(context, 
                                   [UIColor blueColor].CGColor);
    CGContextFillPath(context);
	UIGraphicsPopContext();
}

@end
