//
//  PhotoStorage.h
//  ITRex_TestProj_Obj-C
//
//  Created by Maxim Shirko on 22.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoStorage : NSObject

+ (BOOL) storePhotos:(NSArray *) photos;
+ (NSArray *) loadPhotos;

@end
