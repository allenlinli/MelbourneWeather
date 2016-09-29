//
//  ViewController.m
//  WeatherForecast
//
//  Created by allenlinli on 9/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

#import "ViewController.h"
#import "WeatherAPIClient.h"
#import <Mantle.h>

@interface ViewController ()
@property Weather *weather;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[WeatherAPIClient sharedManager] getCurrentMelbourneWeather:^(Weather *weather, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
