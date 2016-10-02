//
//  Weather.h
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

// [Comment] I am not sure if making Weather a struct is better or not.

@interface Weather : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *tempHigh;
@property (nonatomic, strong) NSNumber *tempLow;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *rainingPercentage;
@property (nonatomic, strong) NSNumber *windSpeed;
@property (nonatomic, copy) NSArray *weatherDescriptions;

@end
