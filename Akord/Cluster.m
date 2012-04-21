//
//  Cluster.m
//  Akord
//
//  Created by Kartikeya Dubey on 4/21/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "Cluster.h"

@implementation Cluster
@synthesize emailAddresses;
@synthesize clusterId;
@synthesize coordinate;
@synthesize numberOfMessages;

-(id)initWithEmailAddress:(NSArray*) addresses andClusterId:(int) cId andNumberOfMessages:(int) numMessages
{
    self = [super init];
    if(self)
    {
        self.emailAddresses = addresses;
        self.clusterId = cId;
        self.numberOfMessages = numMessages;
    }
    
    return self;
}
@end
