//
//  Cluster.h
//  Akord
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cluster : NSObject

@property(strong, nonatomic) NSArray *emailAddresses;
@property int clusterId;
@property CGPoint coordinate;
@property int numberOfMessages;
@property int numberOfPeople;
@property int radius;
@property int averageTime;


-(id)initWithEmailAddress:(NSArray*) addresses andClusterId:(int) cId andNumberOfMessages:(int) numMessages;
@end
