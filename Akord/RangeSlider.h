//
//  RangeSlider.h
//  Akord
//
//  Created by kaushal agrawal on 25/04/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RangeSlider : UIControl{
    float minimumValue;
    float maximumValue;
    float minimumRange;
    float selectedMinimumValue;
    float selectedMaximumValue;
    float distanceFromCenter;
    
    float _padding;
    
    BOOL _maxThumbOn;
    BOOL _minThumbOn;
    
    UIImageView * _minThumb;
    UIImageView * _maxThumb;
    UIImageView * _track;
    UIImageView * _trackBackground;
}

@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;
@property(nonatomic) float minimumRange;
@property(nonatomic) float selectedMinimumValue;
@property(nonatomic) float selectedMaximumValue;

@end
