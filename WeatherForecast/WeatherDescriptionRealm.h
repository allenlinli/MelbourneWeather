//
//  WeatherDescriptionRealm.h
//  WeatherForecast
//
//  Created by allenlinli on 9/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherDescription.h"
#import "Constants.h"
#import <Realm/Realm.h>

@interface WeatherDescriptionRealm : RLMObject

@property (strong, nonatomic) NSNumber<RLMInt> *identifier;
@property (strong, nonatomic) NSString *main;
@property (strong, nonatomic) NSString *weatherDescription;
@property (strong, nonatomic) NSString *icon;
@property (nonatomic, assign) WeatherApiType weatherApiType;

- (id)initWithMantleModel:(WeatherDescription *)weatherDescription;
- (id)initWithMantleModel:(WeatherDescription *)weatherDescription weatherApiType:(WeatherApiType)type;

@end

RLM_ARRAY_TYPE(WeatherDescriptionRealm)
