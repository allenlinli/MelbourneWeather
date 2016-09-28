//
//  WeatherDataManager.h
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

extern NSString * const NSErrorDomainWeatherManager;

typedef void (^WeatherManagerCompletionHandler)(NSError *error);

@interface WeatherManager : NSObject
+ (id)sharedManager;

@property (strong, nonatomic) NSDate *lastUpdateTime;
@property (strong, nonatomic) NSArray *weathers;

- (void)updateMelbourneWeather:(WeatherManagerCompletionHandler) handler;
@end
