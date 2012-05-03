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
#import "PersonViewCanvas.h"
#import "ViewController.h"

@interface PersonViewController : UIViewController

@property (strong, retain) Person* person;
@property (strong, retain) NSMutableArray* messages;
@property (strong, retain) DBManager* dbManager;
@property (strong, nonatomic) IBOutlet PersonViewCanvas *canvas;
@property  (strong, nonatomic) NSDate* startD;
@property (strong, nonatomic) NSDate* endD;

-(void) getMessagesFromTime:(NSDate*) startDate toEndTime:(NSDate*) endDate;
@end
