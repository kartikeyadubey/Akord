//
//  PersonViewCanvas.h
//  Akord
//
//  Created by Kartikeya Dubey on 5/3/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface PersonViewCanvas : UIView

@property(strong, retain) NSMutableArray *messages;
@property(strong, retain) NSMutableDictionary *messageDisplay;


-(void) processMessages;
@end
