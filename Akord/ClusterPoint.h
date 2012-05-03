//
//  ClusterPoint.h
//  Akord
//
//  Created by Kartikeya Dubey on 5/3/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClusterPoint : NSObject

@property CGPoint point;
@property(strong, nonatomic) UIColor *color;
@property int radius;
@property (strong, nonatomic) NSString *email;

@end
