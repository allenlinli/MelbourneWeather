//
//  WeatherDescriptionRealm.m
//  WeatherForecast
//
//  Created by allenlinli on 9/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherDescriptionRealm.h"

@implementation WeatherDescriptionRealm

- (id)initWithMantleModel:(WeatherDescription *)weatherDescription{
    self = [super init];
    if(!self) return nil;
    
    _identifier = weatherDescription.identifier;
    _main = weatherDescription.main;
    _weatherDescription = weatherDescription.weatherDescription;
    _icon = weatherDescription.icon;
    
    return self;
}

- (id)initWithMantleModel:(WeatherDescription *)weatherDescription weatherApiType:(WeatherApiType)type
{
    self = [self initWithMantleModel:weatherDescription];
    if(!self) return nil;
    
    _weatherApiType = type;
    
    return self;
}

@end
