//
//  Photo.h
//  ITRex_TestProj_Obj-C
//
//  Created by Maxim Shirko on 21.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Photo : NSObject <NSCoding> 

@property (strong, nonatomic) NSData *photoData;
@property (strong, nonatomic) NSDate *photoCreatedDate;
@property (strong, nonatomic) Location *photoLocation;

@end
