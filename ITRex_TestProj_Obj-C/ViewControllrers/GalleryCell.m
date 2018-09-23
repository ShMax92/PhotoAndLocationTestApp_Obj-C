//
//  GalleryCell.m
//  ITRex_TestProj_Obj-C
//
//  Created by Maxim Shirko on 21.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

#import "GalleryCell.h"

@implementation GalleryCell

- (void) awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 8.0;
    _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
