//
//  WeatherViewModel.m
//  WeatherForecast
//
//  Created by allenlinli on 10/3/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherViewModel.h"

@interface WeatherViewModel ()

@property (strong, nonatomic) RLMResults<WeatherRealm *> *currentWeathers;
@property (strong, nonatomic) RLMResults<WeatherDescriptionRealm *> *currentWeatherDescriptions;

@property (strong, nonatomic) RLMResults<WeatherRealm *> *forecastHourWeathers;
@property (strong, nonatomic) RLMResults<WeatherDescriptionRealm *> *forecastHourWeatherDescriptions;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
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

- (NSArray<NSArray *> *)dataSourceForForecastHourWeathers
{
    NSMutableArray *arrayWithDifferentDayArrays = [[NSMutableArray alloc] init];
    
    for (WeatherRealm *weatherRealm in self.forecastHourWeathers)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:weatherRealm.date];
        
        BOOL isFoundInWeatherWithTheSameDayArray = false;
        for (NSMutableArray *weatherWithTheSameDayArray in arrayWithDifferentDayArrays)
        {
            WeatherRealm *weather2 = [weatherWithTheSameDayArray firstObject];
            NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:weather2.date];
            if (components2.day == components.day) {
                [weatherWithTheSameDayArray addObject:weatherRealm];
                isFoundInWeatherWithTheSameDayArray = true;
                break;
            }
            //            WeatherRealm *weather2 = [weathers firstObject];
            //            NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:weather2.date];
            //            if (components.day != components2.day)
            //            {
            //                NSMutableArray *mArray = [[NSMutableArray alloc] init];
            //                [mArray addObject:weatherRealm];
            //                [sections addObject:mArray];
            //            }
            //            else
            //            {
            //                [weathers addObject:weatherRealm];
            //            }
        }
        if (!isFoundInWeatherWithTheSameDayArray) {
            NSMutableArray *weatherWithTheSameDayArray2 = [[NSMutableArray alloc] init];
            [weatherWithTheSameDayArray2 addObject:weatherRealm];
            [arrayWithDifferentDayArrays addObject:weatherWithTheSameDayArray2];
        }
    }
    
    return [arrayWithDifferentDayArrays copy];
}

- (NSArray<NSString *> *)sectionTitlesForForecastHourWeathers
{
    __block NSMutableArray *sectionTitles = [[NSMutableArray alloc] init];
    [[self dataSourceForForecastHourWeathers] enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WeatherRealm *weatherRealm = [obj firstObject];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"d/MMM"];
        
        //Optionally for time zone conversions
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        
        NSString *stringFromDate = [formatter stringFromDate:weatherRealm.date];
        [sectionTitles addObject:stringFromDate];
    }];
    
    return [sectionTitles copy];
}

@end
