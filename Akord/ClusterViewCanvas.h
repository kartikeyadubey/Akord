//
//  ClusterViewCanvas.h
//  Akord
//
//  Created by Kartikeya Dubey on 5/3/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cluster.h"
#import "Message.h"
#import "ClusterPoint.h"


@interface ClusterViewCanvas : UIView


@property (strong, nonatomic) Cluster *cluster;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableDictionary *emailColors;
@property (strong, nonatomic) NSMutableArray *processedMessages;
@property (strong, nonatomic) NSMutableDictionary *emailHeights;
@property (strong, nonatomic) NSMutableArray *drawNames;

-(void) processMessagesFromStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate;

- (float) bigMapWithInitialRangeMin:(long long) initMin andInitialRangeMax:(long long) initMax andFinalRangeMin:(long long)finalMin andFinalRangeMax:(long long)finalMax andValue:(long long) value;
- (float) mapWithInitialRangeMin:(int) initMin andInitialRangeMax:(int) initMax andFinalRangeMin:(int)finalMin andFinalRangeMax:(int)finalMax andValue:(int) value;
@end
