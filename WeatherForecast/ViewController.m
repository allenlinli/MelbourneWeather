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
#import "WeatherViewModel.h"
#import "WeatherTableViewCell.h"


NSString * const KVOWeatherViewModelPropertyCurrentWeathers = @"currentWeathers";
NSString * const KVOWeatherViewModelPropertyForecastHourWeathers = @"forecastHourWeathers";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UILabel *currentTempHigh;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLow;
@property (weak, nonatomic) IBOutlet UILabel *currentWeatherDescription;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tempHigh;
@property (weak, nonatomic) IBOutlet UILabel *tempLow;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescription;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) RLMNotificationToken *notificationToken;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [[WeatherViewModel sharedInstance] reloadData];
    
    self.notificationToken = [realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
        NSLog(@"1234 notification:%@, realm:%@",notification,realm);
        [[WeatherViewModel sharedInstance] reloadData];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                [TSMessage showNotificationWithTitle:@"Your Title"
                                            subtitle:@"A description"
                                                type:TSMessageNotificationTypeError];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [TSMessage dismissActiveNotification];

                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[WeatherViewModel sharedInstance] addObserver:self forKeyPath:KVOWeatherViewModelPropertyCurrentWeathers options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld context:nil];
    [[WeatherViewModel sharedInstance] addObserver:self forKeyPath:KVOWeatherViewModelPropertyForecastHourWeathers options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld context:nil];
    
    [self updateCurrentWeather];
    [self updateHourForecastWeather];
}

- (void)updateHourForecastWeather
{
    [[WeatherAPIClient sharedInstance] getForecastMelbourneWeather:^(NSArray *weathers, NSError *error) {
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
    [[WeatherAPIClient sharedInstance] getCurrentMelbourneWeather:^(Weather *weather, NSError *error) {
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

- (void)updateUIWithCurrentWeather
{
    WeatherRealm *currentWeather = [[[WeatherViewModel sharedInstance] currentWeathers] firstObject];
    self.currentTemp.text =  [NSString stringWithFormat:@"%ld",(long)currentWeather.temperature.integerValue];
    self.currentTempHigh.text = [NSString stringWithFormat:@"%ld",(long)currentWeather.tempLow.integerValue];
    self.currentTempLow.text = [NSString stringWithFormat:@"%ld",(long)currentWeather.tempLow.integerValue];
    self.currentWeatherDescription.text = [[currentWeather.weatherDescriptionRealms firstObject] weatherDescription];
}

- (void)updateUIWithForecastWeathers
{
    [self.tableView reloadData];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:KVOWeatherViewModelPropertyCurrentWeathers]) {
        [self updateUIWithCurrentWeather];
    }
    else if ([keyPath isEqualToString:KVOWeatherViewModelPropertyForecastHourWeathers]) {
        [self updateUIWithForecastWeathers];
    }
}

#pragma MARK - TableView DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"WeatherTableViewCellID"];
    WeatherRealm *forecastHourWeather = [[[WeatherViewModel sharedInstance] forecastHourWeathers] objectAtIndex:indexPath.row];
    
//    self.currentTemp.text = [forecastHourWeather.temperature stringValue];
//    self.currentTempHigh.text = [forecastHourWeather.tempHigh stringValue];
//    self.currentTempLow.text = [forecastHourWeather.tempLow stringValue];
//    self.currentWeatherDescription.text = [[forecastHourWeather.weatherDescriptionRealms firstObject] weatherDescription];
//    self.time.text = forecastHourWeather.date;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[WeatherViewModel sharedInstance] forecastHourWeathers] count];
}

#pragma MARK - TableView DataSource

@end


