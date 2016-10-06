//
//  WeatherAPIManager.m
//  WeatherForecast
//
//  Created by allenlinli on 10/5/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherManager.h"
#import "WeatherAPIClient.h"
#import <Realm/Realm.h>
#import "WeatherRealm.h"
#import "TSMessage.h"

static const NSTimeInterval TimeIntervalForUpdatingCurrentWeather = 60;
static const NSTimeInterval TimeIntervalForUpdatingForecastHourWeather = 600;

@interface WeatherManager ()
@property (nonatomic, strong) NSDate *lastGetCurrentMelbourneWeatherTime;
@property (nonatomic, strong) NSDate *lastGetForecastMelbourneWeather;
@property (nonatomic, strong) NSTimer *periodicGetCurrentWeatherTimer;
@property (nonatomic, strong) NSTimer *periodicGetForecastHourWeatherTimer;
@end

@implementation WeatherManager

- (void)dealloc
{
    [self.periodicGetCurrentWeatherTimer invalidate];
    self.periodicGetCurrentWeatherTimer = nil;
    [self.periodicGetForecastHourWeatherTimer invalidate];
    self.periodicGetForecastHourWeatherTimer = nil;
}

+ (id)sharedInstance {
    static WeatherManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)startPeriodicGetWeather
{
    __weak typeof(self) wSelf = self;
    self.periodicGetCurrentWeatherTimer = [NSTimer scheduledTimerWithTimeInterval:TimeIntervalForUpdatingCurrentWeather repeats:true block:^(NSTimer * _Nonnull timer) {
        [wSelf getCurrentMelbourneWeather:^(NSError *error) {
            if (error) {
                [TSMessage showNotificationWithTitle:@"Error"
                                            subtitle:error.description
                                                type:TSMessageNotificationTypeError];
                return;
            }
        }];
    }];
    [self.periodicGetCurrentWeatherTimer fire];
    
    self.periodicGetForecastHourWeatherTimer = [NSTimer scheduledTimerWithTimeInterval:TimeIntervalForUpdatingForecastHourWeather repeats:true block:^(NSTimer * _Nonnull timer) {
        [wSelf getForecastMelbourneWeather:^(NSError *error) {
            if (error) {
                [TSMessage showNotificationWithTitle:@"Error"
                                            subtitle:error.description
                                                type:TSMessageNotificationTypeError];
                return;
            }
        }];
    }];
    [self.periodicGetForecastHourWeatherTimer fire];
}

- (BOOL)shouldGetCurrentMelbourneWeather
{
    if (self.lastGetCurrentMelbourneWeatherTime == nil) {
        return true;
    }
    
    if ([[NSDate date] timeIntervalSinceDate: self.lastGetForecastMelbourneWeather] < TimeIntervalForUpdatingCurrentWeather ) {
        return false;
    }
    
    return true;
}

- (BOOL)shouldGetForecastMelbourneWeather
{
    if (self.lastGetCurrentMelbourneWeatherTime == nil) {
        return true;
    }
    
    if ([[NSDate date] timeIntervalSinceDate: self.lastGetForecastMelbourneWeather] < TimeIntervalForUpdatingForecastHourWeather ) {
        return false;
    }
    
    return true;
}

- (void)getCurrentMelbourneWeather:(void(^)(NSError *error)) handler
{
    if (! [self shouldGetCurrentMelbourneWeather]) {
        NSError *error = [[NSError alloc] initWithDomain:@"TimeIntervalForUpdatingLimit" code:1 userInfo:@{@"description":@"Can not update weather in too short time. Please update it later."}];
        handler(error);
        return;
    }
    
    [[WeatherAPIClient sharedInstance] getCurrentMelbourneWeather:^(Weather *weather, NSError *error) {
        if (error) {
            handler(error);
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                RLMRealm *realm = [RLMRealm defaultRealm];
                
                [realm beginWriteTransaction];
                
                NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"weatherApiType = %i",WeatherApiTypeCurrent];
                RLMResults<WeatherRealm *> *oldWeatherRealms = [WeatherRealm objectsWithPredicate:pred1];
                
                RLMResults<WeatherDescriptionRealm *> *oldWeatherDescriptionRealms = [WeatherDescriptionRealm objectsWithPredicate:pred1];
                
                [realm deleteObjects:oldWeatherRealms];
                [realm deleteObjects:oldWeatherDescriptionRealms];
                
                NSError *realmError1;
                [realm commitWriteTransaction:&realmError1];
                if (realmError1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(realmError1);
                    });
                    return;
                }
                
                [realm beginWriteTransaction];
                WeatherRealm *currentWeatherRealm = [[WeatherRealm alloc] initWithMantleModel:weather weatherApiType:WeatherApiTypeCurrent];
                
                NSMutableArray *currentWeatherDescriptionRealmArray = [[NSMutableArray alloc] initWithCapacity:currentWeatherRealm.weatherDescriptionRealms.count];
                for (WeatherDescription *weatherDescription in weather.weatherDescriptions) {
                    WeatherDescriptionRealm *currentWeatherDescriptionRealm = [[WeatherDescriptionRealm alloc] initWithMantleModel:weatherDescription weatherApiType:WeatherApiTypeCurrent];
                    [currentWeatherDescriptionRealmArray addObject:currentWeatherDescriptionRealm];
                }
                
                if (currentWeatherDescriptionRealmArray.count != 0) {
                    [currentWeatherRealm.weatherDescriptionRealms addObjects:currentWeatherDescriptionRealmArray];
                    [realm addObjects:currentWeatherDescriptionRealmArray];
                }
                [realm addObject:currentWeatherRealm];
                
                NSError *realmError2;
                [realm commitWriteTransaction:&realmError2];
                
                if (realmError2) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(realmError2);
                    });
                    return;
                }
                
                
                
                handler(nil);
            }
        });
    }];
}

- (void)getForecastMelbourneWeather:(void(^)(NSError *error)) handler
{
    [[WeatherAPIClient sharedInstance] getForecastMelbourneWeather:^(NSArray *weathers, NSError *error) {
        if (error) {
            //show user error
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            [realm beginWriteTransaction];
            
            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"weatherApiType = %i",WeatherApiTypeForecastHour];
            RLMResults<WeatherRealm *> *oldWeatherRealms = [WeatherRealm objectsWithPredicate:pred1];
            
            RLMResults<WeatherDescriptionRealm *> *oldWeatherDescriptionRealms = [WeatherDescriptionRealm objectsWithPredicate:pred1];
            
            [realm deleteObjects:oldWeatherRealms];
            [realm deleteObjects:oldWeatherDescriptionRealms];
            
            NSError *realmError1;
            [realm commitWriteTransaction:&realmError1];
            if (realmError1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(realmError1);
                });
                return;
            }
            
            @autoreleasepool {
                [realm beginWriteTransaction];
                for (Weather *weather in weathers) {
                    WeatherRealm *weatherRealm = [[WeatherRealm alloc] initWithMantleModel:weather weatherApiType:WeatherApiTypeForecastHour];
                    
                    NSMutableArray *weatherDescriptionRealmArray = [[NSMutableArray alloc] initWithCapacity:weatherRealm.weatherDescriptionRealms.count];
                    for (WeatherDescription *weatherDescription in weather.weatherDescriptions) {
                        WeatherDescriptionRealm *weatherDescriptionRealm = [[WeatherDescriptionRealm alloc] initWithMantleModel:weatherDescription weatherApiType:WeatherApiTypeForecastHour];
                        [weatherDescriptionRealmArray addObject:weatherDescriptionRealm];
                    }
                    if (weatherDescriptionRealmArray.count != 0) {
                        [weatherRealm.weatherDescriptionRealms addObjects:weatherDescriptionRealmArray];
                        [realm addObjects:weatherDescriptionRealmArray];
                    }
                    
                    [realm addObject:weatherRealm];
                }
                
                NSError *realmError2;
                [realm commitWriteTransaction:&realmError2];
                if (realmError2) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(realmError2);
                    });
                    return;
                }
            }
        });
    }];
}

@end
