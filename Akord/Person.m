//
//  Person.m
//  Akord
//
//  Created by Kartikeya Dubey on 4/29/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "Person.h"

@implementation Person
@synthesize coordinate;
@synthesize emailAddress;
@synthesize currentClusterID;
@synthesize angleToDraw;

-(id) initWithCoordinate:(CGPoint) coord andEmailAddress:(NSString*) email andClusterID:(int) cID andAngle:(int) angle
{
    self = [super init];
    if(self)
    {
        self.coordinate = coord;
        self.emailAddress = email;
        self.currentClusterID = cID;
        self.angleToDraw = angle;
    }
    
    return self;
}
@end
