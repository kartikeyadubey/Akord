//
//  Cluster.h
//  Akord
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cluster : NSObject

@property(strong, nonatomic) NSMutableArray *emailAddresses;
@property int clusterId;
@property CGPoint coordinate;

@end
