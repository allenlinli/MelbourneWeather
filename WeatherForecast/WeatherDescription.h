//
//  WeatherDescription.h
//  WeatherForecast
//
//  Created by allenlinli on 9/28/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WeatherDescription : MTLModel <MTLJSONSerializing>
@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *main;
@property (strong, nonatomic) NSString *weatherDescription;
@property (strong, nonatomic) NSString *icon;
@end
