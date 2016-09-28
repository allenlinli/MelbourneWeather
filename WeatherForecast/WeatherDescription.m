//
//  WeatherDescription.m
//  WeatherForecast
//
//  Created by allenlinli on 9/28/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherDescription.h"

@implementation WeatherDescription
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"identifier" : @"id",
             @"main" : @"main",
             @"weatherDescription" : @"description",
             @"icon" : @"icon",
    };
}
@end
