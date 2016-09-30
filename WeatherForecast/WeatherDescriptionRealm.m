//
//  WeatherDescriptionRealm.m
//  WeatherForecast
//
//  Created by allenlinli on 9/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherDescriptionRealm.h"

@implementation WeatherDescriptionRealm

- (id)initWithMantleModel:(WeatherDescription *)weatherDescription{
    self = [super init];
    if(!self) return nil;
    
    self.identifier = weatherDescription.identifier;
    self.main = weatherDescription.main;
    self.weatherDescription = weatherDescription.weatherDescription;
    self.icon = weatherDescription.icon;
    
    return self;
}

@end
