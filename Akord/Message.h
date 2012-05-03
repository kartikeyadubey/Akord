//
//  Message.h
//  Akord
//
//  Created by Kartikeya Dubey on 4/28/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property int mId;
@property int mDate;
@property(strong, nonatomic) NSString* mSubject;
@property(strong, nonatomic) NSString* mBody;
@property(strong, nonatomic) NSString* mUid;
@property int mSize;
@property int mIsUnread;

@property(strong, nonatomic) NSMutableArray *tos;
@property(strong, nonatomic) NSString *froms;
@property(strong, nonatomic) NSMutableArray *ccs;

@property(strong, nonatomic) NSArray* emailAddresses;

@end
