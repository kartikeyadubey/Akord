//
//  DBManager.h
//  SQLLite
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Cluster.h"
#import "Message.h"

@interface DBManager : NSObject

@property(strong, nonatomic) NSString* dbPath;

-(id) initWithPath;

-(NSMutableArray*) getClustersFromStartDate:(NSDate*) startDate andEndDate:(NSDate *)endDate;

-(Cluster*) getClusterWithId:(int) clusterID;

-(NSMutableArray*) getMessagesForClusterWithID:(int) cluster fromStartDate:(NSDate*)startDate andEndDate:(NSDate*) endDate;

-(NSArray*) getMinAndMaxTime;

@end
