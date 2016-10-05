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
NSString* const TYPE_API_FORECAST = @"forecast";
NSString* const TYPE_API_CURRENT = @"weather";

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

+ (id)sharedInstance {
    static WeatherAPIClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _session = [NSURLSession sharedSession];
    }
    return self;
}

- (void)getCurrentMelbourneWeather:(void(^)(Weather *weather, NSError *error)) handler
{
    NSURL *url = [[self class] getURLFromWeatherTypeString:TYPE_API_CURRENT cityID:CITY_ID_MELBOURNE];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error in getMelbourneWeather:%@",error);
            handler(nil,error);
            return;
        }
        
        NSError *errorInJson;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorInJson];
        
        if (errorInJson) {
            NSLog(@"error in JSONObjectWithData:%@",error);
            handler(nil,errorInJson);
            return;
        }
        
        NSError *errorInMTLJSONAdapter = nil;
        Weather *weather =  [MTLJSONAdapter modelOfClass:[Weather class] fromJSONDictionary:(NSDictionary *)json error:&errorInMTLJSONAdapter];
        NSLog(@"weather123: %@",weather);
        
        if (errorInMTLJSONAdapter) {
            NSLog(@"error in MTLJSONAdapter : %@",errorInMTLJSONAdapter);
            handler(nil, errorInMTLJSONAdapter);
            return;
        }
        
        handler(weather,nil);
    }];
    
    [dataTask resume];
}

- (void)getForecastMelbourneWeather:(void(^)(NSArray *weathers, NSError *error)) handler
{
    NSURL *url = [[self class] getURLFromWeatherTypeString:TYPE_API_FORECAST cityID:CITY_ID_MELBOURNE];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error in getMelbourneWeather:%@",error);
            handler(nil,error);
            return;
        }
        
        NSError *errorInJson;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorInJson];
        
        if (errorInJson) {
            NSLog(@"error in JSONObjectWithData:%@",error);
            handler(nil,errorInJson);
            return;
        }
        
        NSArray *list = json[@"list"];
        NSMutableArray *weathers = [[NSMutableArray alloc] initWithCapacity:list.count];
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *errorInMTLJSONAdapter;
            
            //NSLog(@"obj123:%@",obj);
            Weather *weather =  [MTLJSONAdapter modelOfClass:[Weather class] fromJSONDictionary:(NSDictionary *)obj error:&errorInMTLJSONAdapter];
//            NSLog(@"weather123: %@",weather);
            
            if (errorInMTLJSONAdapter) {
                NSLog(@"error in MTLJSONAdapter : %@",errorInMTLJSONAdapter);
                handler(nil, errorInMTLJSONAdapter);
                return;
            }
            
            [weathers addObject:weather];
        }];
        
        handler(weathers,nil);
    }];
    
    [dataTask resume];
}

+ (NSURL *)getURLFromWeatherTypeString:(NSString *)weatherTypeString cityID:(NSString *)cityID
{
    NSString *urlStr =
    [[[[WEATHER_API_BASE
        stringByReplacingOccurrencesOfString:TYPE_API_FOO_PATH withString:weatherTypeString]
       stringByReplacingOccurrencesOfString:CITY_ID_API_FOO_PATH withString:cityID]
      stringByReplacingOccurrencesOfString:METRIC_API_FOO_PATH withString:METRIC]
     stringByReplacingOccurrencesOfString:APP_ID_FOO_API_PATH withString:APP_ID];
    return [NSURL URLWithString:urlStr];
}

@end
