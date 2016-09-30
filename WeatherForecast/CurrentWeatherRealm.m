//
//  CurrentWeatherRealm.m
//  WeatherForecast
//
//  Created by allenlinli on 9/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "CurrentWeatherRealm.h"

@implementation CurrentWeatherRealm
- (id)initWithMantleModel:(Weather *)weather{
    self = [super init];
    if(!self) return nil;
    
    self.weatherRealm = [[WeatherRealm alloc] initWithMantleModel:weather];
    return self;
}
@end
