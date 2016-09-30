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
    
    self.date = weather.date;
    self.temperature = weather.temperature;
    self.tempHigh = weather.tempHigh;
    self.tempLow = weather.tempLow;
    self.humidity = weather.humidity;
    self.rainingPercentage = weather.rainingPercentage;
    self.windSpeed = weather.windSpeed;

    return self;
}

@end


