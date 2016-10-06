//
//  WeatherAPIManager.h
//  WeatherForecast
//
//  Created by allenlinli on 10/5/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherManager : NSObject

+ (id)sharedInstance;

- (void)startPeriodicGetWeather;
- (void)getCurrentMelbourneWeather:(void(^)(NSError *error)) handler;
- (void)getForecastMelbourneWeather:(void(^)(NSError *error)) handler;

@end
