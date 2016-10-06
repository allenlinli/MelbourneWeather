//
//  WeatherTableViewCell.m
//  WeatherForecast
//
//  Created by allenlinli on 10/3/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "WeatherTableViewCell.h"

@implementation WeatherTableViewCell

- (void)configureCellWithWeather:(WeatherRealm *)weather
{
    self.weatherRealm = weather;
    self.tempLowLabel.text = [NSString stringWithFormat:@"%ld", (long)self.weatherRealm.tempLow.integerValue];
    self.tempHighLabel.text = [NSString stringWithFormat:@"%ld", (long)self.weatherRealm.tempHigh.integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    self.timeLabel.text = [formatter stringFromDate:self.weatherRealm.date];
    
    WeatherDescriptionRealm *weatherDescription = self.weatherRealm.weatherDescriptionRealms.firstObject;
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@", weatherDescription.weatherDescription];
}

@end
