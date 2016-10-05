//
//  WeatherViewModel.h
//  WeatherForecast
//
//  Created by allenlinli on 10/3/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherRealm.h"
#import "WeatherDescriptionRealm.h"

@interface WeatherViewModel : NSObject
@property (strong, nonatomic) RLMResults<WeatherRealm *> *currentWeathers;
@property (strong, nonatomic) RLMResults<WeatherDescriptionRealm *> *currentWeatherDescriptions;
@property (strong, nonatomic) RLMResults<WeatherRealm *> *forecastHourWeathers;
@property (strong, nonatomic) RLMResults<WeatherDescriptionRealm *> *forecastHourWeatherDescriptions;

@property (strong, nonatomic) RLMNotificationToken *notificationToken;

+ (id)sharedInstance;
- (void)reloadData;

@end
