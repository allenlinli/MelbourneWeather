//
//  Weather.h
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import <Foundation/Foundation.h>

// [Comment] I am not sure if making Weather a struct is better or not.

@interface Weather : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *tempHigh;
@property (nonatomic, strong) NSNumber *tempLow;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *conditionDescription;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSNumber *windSpeed;
@property (nonatomic, strong) NSString *icon;


@end

/*
 {
 "city":{
 "id":2158177,
 "name":"Melbourne",
 "coord":{
 "lon":144.963318,
 "lat":-37.813999
 },
 "country":"AU",
 "population":0,
 "sys":{
 "population":0
 }
 },
 "cod":"200",
 "message":0.0098,
 "cnt":40,
 "list":[]
 }
 
*/

/*
 {
 "dt":1474934400,
 "main":{
 "temp":282.55,
 "temp_min":282.55,
 "temp_max":282.911,
 "pressure":1008.56,
 "sea_level":1026.43,
 "grnd_level":1008.56,
 "humidity":98,
 "temp_kf":-0.36
 },
 "weather":[
 {
 "id":500,
 "main":"Rain",
 "description":"light rain",
 "icon":"10d"
 }
 ],
 "clouds":{
 "all":32
 },
 "wind":{
 "speed":1.52,
 "deg":293.003
 },
 "rain":{
 "3h":0.015
 },
 "sys":{
 "pod":"d"
 },
 "dt_txt":"2016-09-27 00:00:00"
 },
 
*/
