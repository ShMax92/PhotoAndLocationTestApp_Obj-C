//
//  Location.h
//  ITRex_TestProj_Obj-C
//
//  Created by Maxim Shirko on 21.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject <NSCoding>

@property (assign, nonatomic) CLLocationDegrees latitude;
@property (assign, nonatomic) CLLocationDegrees longitude;

@end
