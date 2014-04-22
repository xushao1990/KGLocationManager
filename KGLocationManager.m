//
//  KGLocationManager.m
//  Location
//
//  Created by tage on 14-4-21.
//  Copyright (c) 2014年 XT. All rights reserved.
//

#import "KGLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface KGLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic)CLLocationManager *locationManager;

@property (nonatomic)NSInteger seconds;

@property (nonatomic) int time;

@property (nonatomic) BOOL continueAdd;

@end

@implementation KGLocationManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)resignLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
}

- (void)beginLocationWithExitTime:(NSInteger)seconds
{
    if (!self.locationManager) {
        [self resignLocation];
    }
    self.time = 0;
    self.continueAdd = YES;
    self.seconds = seconds;
    [self.locationManager startUpdatingLocation];
    [self change];
}

- (int)endLocation
{
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]){
        
        [self.locationManager stopUpdatingLocation];
        
        self.continueAdd = NO;
        
        return self.time;
    }
    return -1;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.locationManager) {
            [self.locationManager stopUpdatingLocation];
            self.locationManager = nil;
        }
    });
}

- (void)change
{
    if (self.continueAdd) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(240 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.time += 240;
            [self change];
        });
    }
}

@end
