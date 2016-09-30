//
//  CurrentWeatherDescriptionRealm.h
//  WeatherForecast
//
//  Created by allenlinli on 9/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherDescriptionRealm.h"

@interface CurrentWeatherDescriptionRealm : RLMObject
@property (strong, nonatomic) WeatherDescriptionRealm *weatherDescriptionRealm;
- (id)initWithMantleModel:(WeatherDescription *)weatherDescription;
@end

RLM_ARRAY_TYPE(CurrentWeatherDescriptionRealm)
