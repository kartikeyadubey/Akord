//
//  Canvas.h
//  Akord
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cluster.h"
#import "DBManager.h"

@interface Canvas : UIView

@property(strong, nonatomic) NSMutableArray *clusters;
@property(strong, nonatomic) DBManager *dbManager;

-(void) allocDB;
- (void)getClusters:(NSDate*)startDate andEndDate:(NSDate*) endDate;
- (void)drawCluster:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context;
- (float) mappingFunction:(int) initMin andInitialRangeMax:(int) initMax andFinalRangeMin:(int)finalMin andFinalRangeMax:(int)finalMax andValue:(int) value;
@end
