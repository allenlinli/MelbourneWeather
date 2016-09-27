//
//  WeatherAPIClient.m
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherAPIClient.h"

NSString* const WEATHER_API_BASE = @"http://api.openweathermap.org/data/2.5/forecast/city?id=<CITY_ID>&APPID=<APP_ID>";
NSString* const CITY_ID_KEY_IN_URL = @"<CITY_ID>";
NSString* const APP_ID_KEY_IN_URL = @"<APP_ID>";
NSString* const WEATHER_API_MELBOURNE_CITY_ID = @"2158177";
NSString* const WEATHER_API_KEY = @"c00917c0051ef0413b0ffe7c4326bd7e";

@interface WeatherAPIClient ()
@property (nonatomic, strong) NSURLSession* session;

@end

@implementation WeatherAPIClient

+ (id)sharedManager {
    static WeatherAPIClient *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _session = [NSURLSession sharedSession];
    }
    return self;
}

- (void)getMelbourneWeather:(WeatherAPIClientCompletionHandler) handler
{
    NSString *urlStr = [WEATHER_API_BASE stringByReplacingOccurrencesOfString:CITY_ID_KEY_IN_URL withString:WEATHER_API_MELBOURNE_CITY_ID];
    NSLog(@"urlStr122: %@", urlStr);
    urlStr = [urlStr stringByReplacingOccurrencesOfString:APP_ID_KEY_IN_URL withString:WEATHER_API_KEY];
    NSLog(@"urlStr123: %@", urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url123: %@", url);
    //http://api.openweathermap.org/data/2.5/forecast/city?id=2158177&APPID=c00917c0051ef0413b0ffe7c4326bd7e
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error in getMelbourneWeather:%@",error);
            handler(nil,error);
            return;
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (error) {
            NSLog(@"error in JSONObjectWithData:%@",error);
            handler(nil,error);
            return;
        }
        
        handler(json,nil);
    }];
    
    [dataTask resume];
}
@end
