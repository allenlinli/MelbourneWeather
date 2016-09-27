//
//  WeatherDataManager.h
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

typedef void (^WeatherManagerCompletionHandler)(Weather *weather, NSError *error);

@interface WeatherManager : NSObject
- (Weather *) getWeather:(WeatherManagerCompletionHandler) handler;
@end
