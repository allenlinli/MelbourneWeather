//
//  Weather.m
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "Weather.h"

@implementation Weather

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"date" : @"dt",
             
             @"temperature" : @"main.temp",
             @"tempHigh" : @"main.temp_max",
             @"tempLow" : @"main.temp_min",
             @"humidity" : @"main.humidity",
             
             //@"description" : @"weather[0].description",
             @"rainingPercentage" : @"rain.3h",
             @"windSpeed" : @"wind.speed"
    };
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        
        return [NSDate dateWithTimeIntervalSince1970:((NSNumber *)value).floatValue];
    } reverseBlock:^id(NSDate *value, BOOL *success, NSError *__autoreleasing *error) {
        
        return [NSNumber numberWithDouble:[((NSDate *)value) timeIntervalSince1970]];
    }];
}



@end
