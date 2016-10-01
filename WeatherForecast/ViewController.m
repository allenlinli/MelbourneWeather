//
//  ViewController.m
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "ViewController.h"

#import "WeatherAPIClient.h"

#import "CurrentWeatherRealm.h"
#import "CurrentWeatherDescriptionRealm.h"
#import "HourForecastWeatherRealm.h"
#import "HourForecastWeatherDescriptionRealm.h"


#import <Mantle.h>
#import <Realm/Realm.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) RLMNotificationToken *notificationToken;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    __weak typeof(self) wSelf = self;
    self.notificationToken = [realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
        __strong typeof(self) sSelf = wSelf;
        [sSelf.tableView reloadData];
    }];
    
    [[WeatherAPIClient sharedManager] getCurrentMelbourneWeather:^(Weather *weather, NSError *error) {
        if (error) {
            //show user error
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                RLMRealm *realm = [RLMRealm defaultRealm];
                
                [realm beginWriteTransaction];
                RLMResults<CurrentWeatherRealm *> *oldCurrentWeatherRealms = [CurrentWeatherRealm allObjects];
                RLMResults<CurrentWeatherDescriptionRealm *> *oldCurrentWeatherDescriptionRealms = [CurrentWeatherDescriptionRealm allObjects];
                [realm deleteObjects:oldCurrentWeatherRealms];
                [realm deleteObjects:oldCurrentWeatherDescriptionRealms];
                [realm commitWriteTransaction];
                
                [realm beginWriteTransaction];
                CurrentWeatherRealm *currentWeatherRealm = [[CurrentWeatherRealm alloc] initWithMantleModel:weather];
                
                NSMutableArray *currentWeatherDescriptionRealmArray = [[NSMutableArray alloc] initWithCapacity:currentWeatherRealm.currentWeatherDescriptionRealms.count];
                for (WeatherDescription *weatherDescription in weather.weatherDescriptions) {
                    CurrentWeatherDescriptionRealm *currentWeatherDescriptionRealm = [[CurrentWeatherDescriptionRealm alloc] initWithMantleModel:weatherDescription];
                    [currentWeatherDescriptionRealmArray addObject:currentWeatherDescriptionRealm];
                }
                if (currentWeatherDescriptionRealmArray.count != 0) {
                    [currentWeatherRealm.currentWeatherDescriptionRealms addObjects:currentWeatherDescriptionRealmArray];
                    [realm addObjects:currentWeatherDescriptionRealmArray];
                }
                
                [realm addObject:currentWeatherRealm];
                
                NSError *realmError;
                [realm commitWriteTransaction:&realmError];
                
                RLMResults<CurrentWeatherDescriptionRealm *> *newCurrentWeatherDescriptionRealms = [CurrentWeatherDescriptionRealm allObjects];
                NSLog(@"[newCurrentWeatherDescriptionRealms firstObject]:%@",(CurrentWeatherDescriptionRealm *)[newCurrentWeatherDescriptionRealms firstObject]);
                
                RLMResults<CurrentWeatherRealm *> *newCurrentWeatherRealms = [CurrentWeatherRealm allObjects];
                NSLog(@"[newCurrentWeatherRealms firstObject]:%@",(CurrentWeatherRealm *)[newCurrentWeatherRealms firstObject]);
                
                if (realmError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //hint user error
                        NSLog(@"realmError: %@",realmError);
                    });
                    return;
                }
            }
        });
    }];
    
    [[WeatherAPIClient sharedManager] getForecastMelbourneWeather:^(NSArray *weathers, NSError *error) {
        if (error) {
            //show user error
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                RLMRealm *realm = [RLMRealm defaultRealm];
                
                [realm beginWriteTransaction];
                RLMResults<CurrentWeatherRealm *> *oldCurrentWeatherRealms = [CurrentWeatherRealm allObjects];
                RLMResults<CurrentWeatherDescriptionRealm *> *oldCurrentWeatherDescriptionRealms = [CurrentWeatherDescriptionRealm allObjects];
                [realm deleteObjects:oldCurrentWeatherRealms];
                [realm deleteObjects:oldCurrentWeatherDescriptionRealms];
                [realm commitWriteTransaction];
                
                [realm beginWriteTransaction];
                CurrentWeatherRealm *currentWeatherRealm = [[CurrentWeatherRealm alloc] initWithMantleModel:weather];
                
                NSMutableArray *currentWeatherDescriptionRealmArray = [[NSMutableArray alloc] initWithCapacity:currentWeatherRealm.currentWeatherDescriptionRealms.count];
                for (WeatherDescription *weatherDescription in weather.weatherDescriptions) {
                    CurrentWeatherDescriptionRealm *currentWeatherDescriptionRealm = [[CurrentWeatherDescriptionRealm alloc] initWithMantleModel:weatherDescription];
                    [currentWeatherDescriptionRealmArray addObject:currentWeatherDescriptionRealm];
                }
                if (currentWeatherDescriptionRealmArray.count != 0) {
                    [currentWeatherRealm.currentWeatherDescriptionRealms addObjects:currentWeatherDescriptionRealmArray];
                    [realm addObjects:currentWeatherDescriptionRealmArray];
                }
                
                [realm addObject:currentWeatherRealm];
                
                NSError *realmError;
                [realm commitWriteTransaction:&realmError];
                
                RLMResults<CurrentWeatherDescriptionRealm *> *newCurrentWeatherDescriptionRealms = [CurrentWeatherDescriptionRealm allObjects];
                NSLog(@"[newCurrentWeatherDescriptionRealms firstObject]:%@",(CurrentWeatherDescriptionRealm *)[newCurrentWeatherDescriptionRealms firstObject]);
                
                RLMResults<CurrentWeatherRealm *> *newCurrentWeatherRealms = [CurrentWeatherRealm allObjects];
                NSLog(@"[newCurrentWeatherRealms firstObject]:%@",(CurrentWeatherRealm *)[newCurrentWeatherRealms firstObject]);
                
                if (realmError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //hint user error
                        NSLog(@"realmError: %@",realmError);
                    });
                    return;
                }
            }
        });
    }];
    
//    [[WeatherAPIClient sharedManager] getForecastMelbourneWeather:^(NSArray *weathers, NSError *error) {
//        
//        if (error) {
//            //show user error
//        }
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            @autoreleasepool {
//                RLMRealm *realm = [RLMRealm defaultRealm];
//                
//                [realm beginWriteTransaction];
//                RLMResults<HourForecastWeatherRealm *> *oldHourForecastWeatherRealms = [HourForecastWeatherRealm allObjects];
//                RLMResults<HourForecastWeatherDescriptionRealm *> *oldHourForecastWeatherDescriptionRealms = [HourForecastWeatherDescriptionRealm allObjects];
//                [realm deleteObjects:oldHourForecastWeatherRealms];
//                [realm deleteObjects:oldHourForecastWeatherDescriptionRealms];
//                
//                for (Weather *weather in weathers) {
//                    HourForecastWeatherRealm *hourForecastWeatherRealm = [[HourForecastWeatherRealm alloc] initWithMantleModel:weather];
//                    
//                    NSMutableArray *weatherDescriptionRealmArray = [[NSMutableArray alloc] initWithCapacity:hourForecastWeatherRealm.weatherDescriptions.count];
//                    for (WeatherDescription *weatherDescription in weather.weatherDescriptions) {
//                        HourForecastWeatherDescriptionRealm *forecastWeatherDescriptionRealm = [[HourForecastWeatherDescriptionRealm alloc] initWithMantleModel:weatherDescription];
//                        [weatherDescriptionRealmArray addObject:forecastWeatherDescriptionRealm];
//                    }
//                    [hourForecastWeatherRealm.weatherDescriptions addObjects:weatherDescriptionRealmArray];
//                    [realm addObjects:weatherDescriptionRealmArray];
//                    [realm addObject:hourForecastWeatherRealm];
//                }
//                
//                NSError *realmError;
//                [realm commitWriteTransaction:&realmError];
//                
//                if (realmError) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //hint user error
//                        NSLog(@"realmError: %@",realmError);
//                    });
//                    return;
//                }
//            }
//        });
//    }];
}

- (void)dealloc {
    [self.notificationToken stop];
}

@end
