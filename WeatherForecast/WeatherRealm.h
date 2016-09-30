//
//  WeatherRealm.h
//  WeatherForecast
//
//  Created by allenlinli on 9/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import <Realm/Realm.h>
#import "Weather.h"
#import "WeatherDescriptionRealm.h"

@interface WeatherRealm : RLMObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber<RLMFloat> *temperature;
@property (nonatomic, strong) NSNumber<RLMFloat> *tempHigh;
@property (nonatomic, strong) NSNumber<RLMFloat> *tempLow;
@property (nonatomic, strong) NSNumber<RLMFloat> *humidity;
@property (nonatomic, strong) NSNumber<RLMFloat> *rainingPercentage;
@property (nonatomic, strong) NSNumber<RLMFloat> *windSpeed;

@property RLMArray<WeatherDescriptionRealm *><WeatherDescriptionRealm> *weatherDescriptions;

- (id)initWithMantleModel:(Weather *)weather;

@end
