//
//  ViewController.m
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "ViewController.h"
#import <Realm/Realm.h>
#import "Mantle.h"
#import "AFNetworking.h"
#import "TSMessage.h"

#import "WeatherAPIClient.h"

#import "WeatherRealm.h"
#import "WeatherManager.h"

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
    
    [TSMessage setDefaultViewController:self];
    
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
    
    // view(ViewController) observes ViewModel
    [[WeatherViewModel sharedInstance] addObserver:self forKeyPath:KVOWeatherViewModelPropertyCurrentWeathers options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld context:nil];
    [[WeatherViewModel sharedInstance] addObserver:self forKeyPath:KVOWeatherViewModelPropertyForecastHourWeathers options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld context:nil];
    
    [[WeatherManager sharedInstance] startPeriodicGetWeather];
}

- (void)dealloc {
    [[WeatherViewModel sharedInstance] removeObserver:self forKeyPath:KVOWeatherViewModelPropertyCurrentWeathers context:nil];
    [[WeatherViewModel sharedInstance] removeObserver:self forKeyPath:KVOWeatherViewModelPropertyForecastHourWeathers context:nil];
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
    WeatherTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"WeatherTableViewCell"];
    WeatherRealm *forecastHourWeatherRealm = [[[[WeatherViewModel sharedInstance] dataSourceForForecastHourWeathers] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell configureCellWithWeather:forecastHourWeatherRealm];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[WeatherViewModel sharedInstance] dataSourceForForecastHourWeathers] objectAtIndex:section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[WeatherViewModel sharedInstance] sectionTitlesForForecastHourWeathers].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[WeatherViewModel sharedInstance] sectionTitlesForForecastHourWeathers] objectAtIndex:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backgroundView=[[UIView alloc]initWithFrame:[tableView rectForHeaderInSection:section]];
    backgroundView.backgroundColor=[UIColor whiteColor];
//    backgroundView.alpha = 0.5;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,180,CGRectGetHeight(backgroundView.frame))];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:104.0/255.0 green:168.0/255.0 blue:204.0/255.0 alpha:1];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:19];
    titleLabel.text = [[[WeatherViewModel sharedInstance] sectionTitlesForForecastHourWeathers] objectAtIndex:section];
    
    [backgroundView addSubview:titleLabel];
    
    return backgroundView;
}



@end


