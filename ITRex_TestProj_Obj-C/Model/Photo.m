//
//  Photo.m
//  ITRex_TestProj_Obj-C
//
//  Created by Maxim Shirko on 21.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_photoData forKey:@"photoData"];
    [aCoder encodeObject:_photoCreatedDate forKey:@"photoCreatedDate"];
    [aCoder encodeObject:_photoLocation forKey:@"photoLocation"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _photoData = [aDecoder decodeObjectForKey:@"photoData"];
        _photoCreatedDate = [aDecoder decodeObjectForKey:@"_photoCreatedDate"];
        _photoLocation = [aDecoder decodeObjectForKey:@"photoLocation"];
    }
    return self;
}

@end
