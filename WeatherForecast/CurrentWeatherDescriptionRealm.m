//
//  CurrentWeatherDescriptionRealm.m
//  WeatherForecast
//
//  Created by allenlinli on 9/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "CurrentWeatherDescriptionRealm.h"

@implementation CurrentWeatherDescriptionRealm

- (id)initWithMantleModel:(WeatherDescription *)weatherDescription{
    self = [super init];
    if(!self) return nil;
    
    self.weatherDescriptionRealm = [[WeatherDescriptionRealm alloc] initWithMantleModel:weatherDescription];
    
    return self;
}

@end
