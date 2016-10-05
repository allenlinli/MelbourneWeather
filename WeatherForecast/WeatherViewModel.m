//
//  WeatherViewModel.m
//  WeatherForecast
//
//  Created by allenlinli on 10/3/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherViewModel.h"

@interface WeatherViewModel ()

@end

@implementation WeatherViewModel

+ (instancetype)sharedInstance {
    static WeatherViewModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)reloadData
{
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"weatherApiType = %i",WeatherApiTypeCurrent];
    self.currentWeathers = [WeatherRealm objectsWithPredicate:pred1];
    self.currentWeatherDescriptions = [WeatherDescriptionRealm objectsWithPredicate:pred1];
    
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"weatherApiType = %i",WeatherApiTypeForecastHour];
    self.forecastHourWeathers = [WeatherRealm objectsWithPredicate:pred2];
    self.forecastHourWeatherDescriptions = [WeatherDescriptionRealm objectsWithPredicate:pred2];
}

@end
