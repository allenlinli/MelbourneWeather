//
//  WeatherRealm.m
//  WeatherForecast
//
//  Created by allenlinli on 9/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherRealm.h"

@implementation WeatherRealm

- (id)initWithMantleModel:(Weather *)weather{
    self = [super init];
    if(!self) return nil;
    
    _date = weather.date;
    _temperature = weather.temperature;
    _tempHigh = weather.tempHigh;
    _tempLow = weather.tempLow;
    _humidity = weather.humidity;
    _rainingPercentage = weather.rainingPercentage;
    _windSpeed = weather.windSpeed;
    
    return self;
}

- (id)initWithMantleModel:(Weather *)weather weatherApiType:(WeatherApiType)type
{
    self = [self initWithMantleModel:weather];
    if(!self) return nil;
    
    _weatherApiType = type;
    
    return self;
}

@end


