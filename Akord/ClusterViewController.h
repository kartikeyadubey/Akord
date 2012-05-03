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

@interface ClusterViewController : UIViewController

@property (strong, retain) Cluster *cluster;
-(void) getMessages;


@end
