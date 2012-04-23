//
//  ViewController.h
//  Akord
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Canvas.h"
#import "Cluster.h"
#import "DBManager.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet Canvas *canvas;
- (IBAction)singleTap:(UIGestureRecognizer*)sender;


-(Cluster*)clusterUnderPoint:(CGPoint) handPoint;
-(double)getDistance:(CGPoint)firstPoint and:(CGPoint)secondPoint;
@end
