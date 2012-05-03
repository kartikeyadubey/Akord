//
//  AngleSpan.m
//  Akord
//
//  Created by kaushal agrawal on 03/05/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "AngleSpan.h"

@implementation AngleSpan
@synthesize angleStart;
@synthesize angleEnd;
@synthesize span;

-(id) initWithStartAngle:(int) sAngle andEndAngle:(int) eAngle{
    self = [super init];
    if(self){
        angleStart = sAngle;
        angleEnd = eAngle;
    }
    return self;
}
@end
