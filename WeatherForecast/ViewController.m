//
//  ViewController.m
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "ViewController.h"

#import "WeatherAPIClient.h"

#import "WeatherRealm.h"
#import "WeatherDescriptionRealm.h"


#import "Mantle.h"
#import <Realm/Realm.h>
#import "AFNetworking.h"
#import "TSMessage.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UILabel *currentTempHigh;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLow;
@property (weak, nonatomic) IBOutlet UILabel *currentWeatherDescription;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tempHigh;
@property (weak, nonatomic) IBOutlet UILabel *tempLow;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescription;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) RLMNotificationToken *notificationToken;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    __weak typeof(self) wSelf = self;
    self.notificationToken = [realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
        __strong typeof(self) sSelf = wSelf;
        [sSelf.tableView reloadData];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [TSMessage showNotificationWithTitle:@"Your Title"
                                    subtitle:@"A description"
                                        type:TSMessageNotificationTypeError];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [self updateCurrentWeather];
    [self updateHourForecastWeather];
}

- (void)updateHourForecastWeather
{
    [[WeatherAPIClient sharedManager] getForecastMelbourneWeather:^(NSArray *weathers, NSError *error) {
        if (error) {
            //show user error
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
                RLMRealm *realm = [RLMRealm defaultRealm];
                
                [realm beginWriteTransaction];
                NSError *realmError;
                
                NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"weatherApiType = %i",WeatherApiTypeForecastHour];
                RLMResults<WeatherRealm *> *oldWeatherRealms = [WeatherRealm objectsWithPredicate:pred1];
                
                RLMResults<WeatherDescriptionRealm *> *oldWeatherDescriptionRealms = [WeatherDescriptionRealm objectsWithPredicate:pred1];
                NSLog(@"oldHourForecastWeatherRealms123:%@",oldWeatherRealms);
                NSLog(@"oldHourForecastWeatherDescriptionRealms:%@",oldWeatherDescriptionRealms);
                
                [realm deleteObjects:oldWeatherRealms];
                [realm deleteObjects:oldWeatherDescriptionRealms];
                
                [realm commitWriteTransaction:&realmError];
                if (realmError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //hint user error
                        NSLog(@"realmError: %@",realmError);
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
                
                [realm commitWriteTransaction:&realmError];
                
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
}

- (void)updateCurrentWeather
{
    [[WeatherAPIClient sharedManager] getCurrentMelbourneWeather:^(Weather *weather, NSError *error) {
        if (error) {
            //show user error
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                RLMRealm *realm = [RLMRealm defaultRealm];
                
                [realm beginWriteTransaction];
                NSError *realmError;
                
                NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"weatherApiType = %i",WeatherApiTypeCurrent];
                RLMResults<WeatherRealm *> *oldWeatherRealms = [WeatherRealm objectsWithPredicate:pred1];
                
                RLMResults<WeatherDescriptionRealm *> *oldWeatherDescriptionRealms = [WeatherDescriptionRealm objectsWithPredicate:pred1];
                NSLog(@"oldHourForecastWeatherRealms123:%@",oldWeatherRealms);
                NSLog(@"oldHourForecastWeatherDescriptionRealms:%@",oldWeatherDescriptionRealms);
                
                [realm deleteObjects:oldWeatherRealms];
                [realm deleteObjects:oldWeatherDescriptionRealms];
                
                [realm commitWriteTransaction:&realmError];
                if (realmError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //hint user error
                        NSLog(@"realmError: %@",realmError);
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
        
                [realm commitWriteTransaction:&realmError];
                
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
}

- (void)dealloc {
    [self.notificationToken stop];
}

#pragma MARK - TableView DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
}

#pragma MARK - TableView DataSource

@end


