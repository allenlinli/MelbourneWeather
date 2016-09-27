//
//  WeatherAPIClient.h
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

typedef void (^WeatherAPIClientCompletionHandler)(NSDictionary *json, NSError *error);

@interface WeatherAPIClient : NSObject

+ (id)sharedManager;

// [Comment] I didn't attatch Weather to WeatherAPIClient to have extra dependency for easier expandsion in the future.
- (void) getMelbourneWeather:(WeatherAPIClientCompletionHandler) handler;

@end
