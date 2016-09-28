//
//  WeatherAPIClient.m
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherAPIClient.h"

// Example API calls:
// Current Weather
//api.openweathermap.org/data/2.5/weather?id=2158177&units=metric&APPID=c00917c0051ef0413b0ffe7c4326bd7e
// Forecast Weather
//api.openweathermap.org/data/2.5/forecast?id=2158177&units=metric&APPID=c00917c0051ef0413b0ffe7c4326bd7e

//API document
//Current: http://openweathermap.org/current
//Forecast: http://openweathermap.org/forecast5

NSString* const WEATHER_API_BASE = @"http://api.openweathermap.org/data/2.5/<TYPE_API_FOO_PATH>?id=<CITY_ID_API_FOO_PATH>&<METRIC_API_FOO_PATH>&APPID=<APP_ID_FOO_API_PATH>";

NSString* const TYPE_API_FOO_PATH = @"<TYPE_API_FOO_PATH>";
NSString* const FORECAST = @"forecast";
NSString* const CURRENT = @"weather";

NSString* const CITY_ID_API_FOO_PATH = @"<CITY_ID_API_FOO_PATH>";
NSString* const CITY_ID_MELBOURNE = @"2158177";

NSString* const METRIC_API_FOO_PATH = @"<METRIC_API_FOO_PATH>";
NSString* const METRIC = @"units=metric";

NSString* const APP_ID_FOO_API_PATH = @"<APP_ID_FOO_API_PATH>";
NSString* const APP_ID = @"c00917c0051ef0413b0ffe7c4326bd7e";

@interface WeatherAPIClient ()
@property (nonatomic, strong) NSURLSession* session;

@end

@implementation WeatherAPIClient

+ (id)sharedManager {
    static WeatherAPIClient *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        _session = [NSURLSession sharedSession];
    }
    return self;
}

- (void)getCurrentWeather:(WeatherAPIClientCompletionHandler) handler
{
    
}

- (void)getForecastWeather:(WeatherAPIClientCompletionHandler) handler
{
    NSString *urlStr =
    [[[[WEATHER_API_BASE
        stringByReplacingOccurrencesOfString:TYPE_API_FOO_PATH withString:FORECAST]
       stringByReplacingOccurrencesOfString:CITY_ID_API_FOO_PATH withString:CITY_ID_MELBOURNE]
      stringByReplacingOccurrencesOfString:METRIC_API_FOO_PATH withString:METRIC]
     stringByReplacingOccurrencesOfString:APP_ID_FOO_API_PATH withString:APP_ID];
    //NSLog(@"urlStr123: %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error in getMelbourneWeather:%@",error);
            handler(nil,error);
            return;
        }
        
        NSError *errorInJson;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorInJson];
        
        //NSLog(@"json123: %@",json);
        
        if (errorInJson) {
            NSLog(@"error in JSONObjectWithData:%@",error);
            handler(nil,errorInJson);
            return;
        }
        
        handler(json,nil);
    }];
    
    [dataTask resume];
}



@end
