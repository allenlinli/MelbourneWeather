//
//  WeatherAPIClient.h
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

@interface WeatherAPIClient : NSObject

+ (id)sharedManager;

- (void)getCurrentMelbourneWeather:(void(^)(Weather *weather, NSError *error)) handler;
- (void)getForecastMelbourneWeather:(void(^)(NSArray *weathers, NSError *error)) handler;

@end
