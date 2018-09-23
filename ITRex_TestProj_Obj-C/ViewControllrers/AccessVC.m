//
//  AccessVC.m
//  ITRex_TestProj_Obj-C
//
//  Created by Maxim Shirko on 19.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

#import "AccessVC.h"

@interface AccessVC ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *getCameraAccessButton;
@property (weak, nonatomic) IBOutlet UIButton *getLocationAccessButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL locationAccessGranted;
@property (assign, nonatomic) BOOL cameraAccessGranted;

@end

@implementation AccessVC

- (void)viewDidLoad {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _cameraAccessGranted = ([AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo] == AVAuthorizationStatusAuthorized);
    [self checkAccess];
}

- (void)checkAccess {
    if (!_locationAccessGranted) {
        [self.getLocationAccessButton setTitleColor:[UIColor redColor] forState: normal];
    }
    if (!_cameraAccessGranted) {
        [self.getCameraAccessButton setTitleColor:[UIColor redColor] forState: normal];
    }
}

- (IBAction)getCameraAccessButton:(UIButton *)sender {
    AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
    if (cameraStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted && self.locationAccessGranted) {
                self.cameraAccessGranted = true;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.getCameraAccessButton setTitleColor:[UIColor whiteColor] forState: normal];
                });
                [self goToPhotoCollection];
            } else if (granted) {
                self.cameraAccessGranted = true;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.getCameraAccessButton setTitleColor:[UIColor whiteColor] forState: normal];
                });
            } else if (!granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.getCameraAccessButton setTitleColor:[UIColor redColor] forState: normal];
                });
            }
        }];
    } else if (cameraStatus == AVAuthorizationStatusDenied) {
        [self openSettings];
    } else if (cameraStatus == AVAuthorizationStatusAuthorized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.getCameraAccessButton setTitleColor:[UIColor whiteColor] forState: normal];
        });
    }
}

- (IBAction)getLocationAccessButton:(UIButton *)sender {
    CLAuthorizationStatus locationStatus = [CLLocationManager authorizationStatus];
    if (locationStatus == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    } else if (locationStatus == kCLAuthorizationStatusDenied) {
        [self openSettings];
    }
}

- (void) openSettings {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
    }];
}

- (void) locationManager:(CLLocationManager *) manager didChangeAuthorizationStatus:(CLAuthorizationStatus) status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse && self.cameraAccessGranted) {
        _locationAccessGranted = true;
        [self goToPhotoCollection];
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        _locationAccessGranted = true;
        [self.getLocationAccessButton setTitleColor:[UIColor whiteColor] forState: normal];
    } else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusNotDetermined) {
        _locationAccessGranted = false;
        [self.getLocationAccessButton setTitleColor:[UIColor redColor] forState: normal];
    }
}
    
- (void) goToPhotoCollection {
    if (self.locationAccessGranted && self.cameraAccessGranted) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *galleryVC = [storyboard instantiateViewControllerWithIdentifier:@"NavigationVC"];
        [self presentViewController:galleryVC animated:true completion:nil];
    }
}

@end
