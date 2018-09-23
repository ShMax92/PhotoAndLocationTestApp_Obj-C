//
//  DetailsVC.m
//  ITRex_TestProj_Obj-C
//
//  Created by Maxim Shirko on 23.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

#import "DetailsVC.h"

@interface DetailsVC ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.photoImageView.backgroundColor = [UIColor blackColor];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (self.photo != nil) {
        UIImage *photo = [UIImage imageWithData:self.photo.photoData];
        self.photoImageView.image = photo;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
