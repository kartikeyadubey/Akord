//
//  PersonViewController.h
//  Akord
//
//  Created by Kevin McMillin on 5/3/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "Cluster.h"
#import "DBManager.h"

@interface PersonViewController : UIViewController

@property (strong, retain) Person* person;
@property (strong, retain) NSMutableArray* messages;
@property (strong, retain) DBManager* dbManager;

-(void) getMessagesFromTime:(NSDate*) startDate toEndTime:(NSDate*) endDate;
@end
