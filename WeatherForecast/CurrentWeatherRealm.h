//
//  CurrentWeatherRealm.h
//  WeatherForecast
//
//  Created by allenlinli on 9/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherRealm.h"
#import "CurrentWeatherDescriptionRealm.h"

@interface CurrentWeatherRealm : WeatherRealm

@property RLMArray<CurrentWeatherDescriptionRealm *><CurrentWeatherDescriptionRealm> *weatherDescriptions;
@end

