//
//  WeatherDataManager.m
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherManager.h"
#import "WeatherAPIClient.h"


NSInteger const GET_WEATHER_COUNT = 16;
//Prevent user update weather within 10 minutes according to the openweathermap website.
NSInteger const MIN_UPDATE_TIME_INTERVAL = 600;
NSString * const NSErrorDomainWeatherManager = @"NSErrorDomainWeatherManager";

@implementation WeatherManager

+ (id)sharedManager {
    static WeatherManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)updateMelbourneWeather:(WeatherManagerCompletionHandler) handler;
{
    __weak typeof(self) wSelf = self;
    if ([[NSDate date] timeIntervalSinceDate:self.lastUpdateTime] < MIN_UPDATE_TIME_INTERVAL) {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:400 userInfo:@{@"description":@"Last update time is less than 10 minutes. Please update weather latter."}];
        handler(error);
    }
    
    [[WeatherAPIClient sharedManager] getForecastWeather:^(NSDictionary *json, NSError *error) {
        if (error) {
            handler(error);
            return;
        }
        
        NSArray *list = json[@"list"];
        //NSLog(@"list123:%@",list);
        NSMutableArray *weathers = [[NSMutableArray alloc] initWithCapacity:GET_WEATHER_COUNT];
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *errorInMTLJSONAdapter;
            
            //NSLog(@"obj123:%@",obj);
            Weather *weather =  [MTLJSONAdapter modelOfClass:[Weather class] fromJSONDictionary:(NSDictionary *)obj error:&errorInMTLJSONAdapter];
            //NSLog(@"weather123: %@",weather);
            
            if (errorInMTLJSONAdapter) {
                NSLog(@"error in MTLJSONAdapter : %@",errorInMTLJSONAdapter);
                handler(errorInMTLJSONAdapter);
                return;
            }
            
            [weathers addObject:weather];
        }];
        
        __strong typeof(self) strongSelf = wSelf;
        strongSelf.weathers = weathers;
        strongSelf.lastUpdateTime = [NSDate date];
        handler(nil);
    }];
}



@end
