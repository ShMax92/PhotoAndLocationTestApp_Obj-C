//
//  PhotoStorage.m
//  ITRex_TestProj_Obj-C
//
//  Created by Maxim Shirko on 22.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

#import "PhotoStorage.h"


@implementation PhotoStorage

+ (BOOL) storePhotos:(NSArray *)photos {
        NSString *filename = @"photos.data";
        NSString *homeDirrectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [homeDirrectory stringByAppendingPathComponent:filename];
        return [NSKeyedArchiver archiveRootObject:photos toFile:filePath];
}

+ (NSMutableArray *) loadPhotos {
    NSString *filename = @"photos.data";
    NSString *homeDirrectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [homeDirrectory stringByAppendingPathComponent:filename];
    NSMutableArray *photos = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (photos != nil) {
        return photos;
    }
    return [[NSMutableArray alloc] init];
}

@end
