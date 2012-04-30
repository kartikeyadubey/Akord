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
#import "Person.h"

@interface Canvas : UIView

@property(strong, nonatomic) NSMutableArray *clusters;
@property(strong, nonatomic) DBManager *dbManager;
@property Boolean drawPeople;
@property(strong, nonatomic) NSMutableArray* peopleCircle;

-(void) allocDB;
- (void)getClusters:(NSDate*)startDate andEndDate:(NSDate*) endDate;
- (void)drawCluster:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context;
- (float) mapWithInitialRangeMin:(int) initMin andInitialRangeMax:(int) initMax andFinalRangeMin:(int)finalMin andFinalRangeMax:(int)finalMax andValue:(int) value;

-(NSMutableArray*) findPeopleStartAndEnd:(CGPoint) centerOfCircle withRadius:(int) radius;
-(CGPoint) rotatedPoint:(CGPoint) point withAngle:(float) angle aroundCenter:(CGPoint) center;
-(void) drawPeopleOnClustersPage:(int) clusterID;
-(void) drawPeopleFromAngle:(NSNumber*) startAngle toAngle:(NSNumber*) endAngle forCluster:(Cluster*) cluster;
-(void) drawPeopleCircles:(Person*) person inContext:(CGContextRef) context;
-(void) drawPersonDetailsOnClustersPage:(Person*) person;
@end
