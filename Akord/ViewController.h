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
#import "RangeSlider.h"

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet Canvas *canvas;
@property (strong, nonatomic) RangeSlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;
@property (strong, nonatomic) IBOutlet UILabel *yAxisMax;
@property (strong, nonatomic) IBOutlet UILabel *yAxisAvg;

- (IBAction)singleTap:(UIGestureRecognizer*)sender;
- (IBAction)longPress:(UILongPressGestureRecognizer *)sender;

-(Cluster*)clusterUnderPoint:(CGPoint) handPoint;
-(double)getDistance:(CGPoint)firstPoint and:(CGPoint)secondPoint;
-(float) mappingFunction:(int) initMin andInitialRangeMax:(int) initMax andFinalRangeMin:(int)finalMin andFinalRangeMax:(int)finalMax andValue:(int) value;
-(Person*) personUnderPoint:(CGPoint) handPoint;
-(void) getClusters;
-(void) setDrawingVariablesClusterDrawn:(BOOL) cDrawn andPeopleDrawn:(BOOL) pDrawn andPeopleArcsDrawn:(BOOL) pArcsDrawn;
-(void) updateRangeLabel;
-(void) findClassForSlider;

@end
