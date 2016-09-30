//
//  CurrentWeatherRealm.h
//  WeatherForecast
//
//  Created by allenlinli on 9/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherRealm.h"
#import "CurrentWeatherDescriptionRealm.h"

@interface CurrentWeatherRealm : RLMObject
@property (strong, nonatomic) WeatherRealm *weatherRealm;

@property (strong, nonatomic) RLMArray<CurrentWeatherDescriptionRealm *><CurrentWeatherDescriptionRealm> *currentWeatherDescriptionRealms;

- (id)initWithMantleModel:(Weather *)weather;
@end

