//
//  ClusterViewController.h
//  Akord
//
//  Created by Kevin McMillin on 5/3/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cluster.h"
#import "Person.h"
#import "DBManager.h"

@interface ClusterViewController : UIViewController

@property (strong, retain) Cluster *cluster;
@property (strong, retain) NSMutableArray *messages;
@property (strong, retain) DBManager *dbManager;

-(void) getMessagesFromStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate;

@end
