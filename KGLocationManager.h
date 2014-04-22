//
//  KGLocationManager.h
//  Location
//
//  Created by tage on 14-4-21.
//  Copyright (c) 2014年 XT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGLocationManager : NSObject

+ (instancetype)sharedInstance;

- (void)resignLocation;

- (void)beginLocationWithExitTime:(NSInteger)seconds;

- (int)endLocation;

@end
