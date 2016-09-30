//
//  WeatherDescriptionRealm.h
//  WeatherForecast
//
//  Created by allenlinli on 9/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherDescription.h"
#import <Realm/Realm.h>

@interface WeatherDescriptionRealm : RLMObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *main;
@property (strong, nonatomic) NSString *weatherDescription;
@property (strong, nonatomic) NSString *icon;

- (id)initWithMantleModel:(WeatherDescription *)weatherDescription;

@end

RLM_ARRAY_TYPE(WeatherDescriptionRealm)
