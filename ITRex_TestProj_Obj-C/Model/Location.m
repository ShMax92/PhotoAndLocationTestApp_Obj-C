//
//  Location.m
//  ITRex_TestProj_Obj-C
//
//  Created by Maxim Shirko on 21.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

#import "Location.h"

@implementation Location

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:self.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.longitude forKey:@"longitude"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        _longitude = [aDecoder decodeDoubleForKey:@"longitude"];
    }
    return self;
}

@end
