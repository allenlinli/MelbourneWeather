//
//  WeatherTableViewCell.h
//  WeatherForecast
//
//  Created by allenlinli on 10/3/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherRealm.h"

//NSString * const WEATHER_TABLEVIEWCELL_ID = @"WeatherTableViewCell";


@interface WeatherTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tempLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) WeatherRealm *weatherRealm;

- (void)configureCellWithWeather:(WeatherRealm *)weather;
@end
