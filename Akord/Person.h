//
//  Person.h
//  Akord
//
//  Created by Kartikeya Dubey on 4/29/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property CGPoint coordinate;
@property(strong, nonatomic) NSString *emailAddress;
@property int currentClusterID;
@property int angleToDraw;
-(id) initWithCoordinate:(CGPoint) coord andEmailAddress:(NSString*) email andClusterID:(int) cID andAngle:(int) angle;
@end
