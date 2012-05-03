//
//  AngleSpan.h
//  Akord
//
//  Created by kaushal agrawal on 03/05/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AngleSpan : NSObject

@property(nonatomic) int angleStart;
@property(nonatomic) int angleEnd;
@property(nonatomic) int span;

-(id) initWithStartAngle:(int) sAngle andEndAngle:(int) eAngle;
@end
