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

// for current weather
- (RLMResults<WeatherRealm *> *)currentWeathers;
- (RLMResults<WeatherDescriptionRealm *> *)currentWeatherDescriptions;

// for forecast hour weathers
@property (strong, nonatomic, readonly) NSArray<NSArray *> *dataSourceForForecastHourWeathers;
- (NSArray<NSString *> *)sectionTitlesForForecastHourWeathers;
@property (strong, nonatomic, readonly) RLMResults<WeatherRealm *> *currentWeathers;
@property (strong, nonatomic, readonly) RLMResults<WeatherDescriptionRealm *> *currentWeatherDescriptions;


@property (strong, nonatomic) RLMNotificationToken *notificationToken;

+ (id)sharedInstance;
- (void)reloadData;

@end
