//
//  GalleryVC.m
//  ITRex_TestProj_Obj-C
//
//  Created by Maxim Shirko on 21.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

#import "GalleryVC.h"

@interface GalleryVC () <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *photos;
@end

@implementation GalleryVC

static NSString * const reuseIdentifier = @"GalleryCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //loading photos
    _photos = [NSMutableArray arrayWithArray:[PhotoStorage loadPhotos]];
    [self.collectionView reloadData];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
}

- (IBAction)cameraButton:(UIBarButtonItem *)sender {
    BOOL locationAccessGranted = ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse);
    BOOL cameraAccessGranted = ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized);
    
    if (cameraAccessGranted && locationAccessGranted) {
        [self takePhoto];
    } else {
        UIAlertController *noAccessAlert = [[UIAlertController alloc] init];
        UIAlertAction *getAccessAction = [UIAlertAction actionWithTitle:@"Access needed!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            }];
        }];
        [noAccessAlert addAction:getAccessAction];
        [self presentViewController:noAccessAlert animated:YES completion:nil];
    }
}

- (void) takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *newPhoto = info[UIImagePickerControllerOriginalImage];
    if (newPhoto != nil) {
        UIImage *fixedPhoto = [self fixedOrientation:newPhoto];
        [_locationManager startUpdatingLocation];
        NSData *photoData = UIImagePNGRepresentation(fixedPhoto);
        NSDate *photoCreatedDate = [NSDate date];
        Location *photoLocation = [[Location alloc] init];
        CLLocation *currantLocation = [_locationManager location];
        if (currantLocation != nil) {
            photoLocation.latitude = currantLocation.coordinate.latitude;
            photoLocation.longitude = currantLocation.coordinate.longitude;
        }
        Photo *photo = [[Photo alloc] init];
        photo.photoData = photoData;
        photo.photoCreatedDate = photoCreatedDate;
        photo.photoLocation = photoLocation;
        
        [_photos addObject:photo];
    }

    [picker dismissViewControllerAnimated:YES completion:^{
        [self.locationManager stopUpdatingLocation];
        [self storeData];
        [self.collectionView reloadData];
    }];
    
}

- (void) storeData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL success = [PhotoStorage storePhotos:self.photos];
        if (!success) {
            //ahtung!
            __weak __typeof(self)weakSelf = self;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Can't save photo" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.photos removeLastObject];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView reloadData];
                });
            }];
            [alert addAction:cancelAction];
            [weakSelf presentViewController:alert animated:YES completion:^{
            }];
        }
    });
}

//rotating image
//https://gist.github.com/schickling/b5d86cb070130f80bb40
-(UIImage *) fixedOrientation:(UIImage *) image {
    
    if (image.imageOrientation == UIImageOrientationUp) {
        return image;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default: break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            CGAffineTransformTranslate(transform, image.size.width, 0);
            CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            CGAffineTransformTranslate(transform, image.size.height, 0);
            CGAffineTransformScale(transform, -1, 1);
            break;
            
        default: break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(nil, image.size.width, image.size.height, CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), kCGImageAlphaPremultipliedLast);
    
    CGContextConcatCTM(ctx, transform);
    
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.height, image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
            break;
    }
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    
    return [UIImage imageWithCGImage:cgImage];
}

#pragma mark <UICollectionViewDataSource> <UICollectionViewDelegate> <UICollectionViewDelegateFlowLayout>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (_photos[indexPath.row] != nil) {
        Photo *photo = _photos[indexPath.row];
        UIImage *photoImage = [UIImage imageWithData:photo.photoData];
        cell.photoImageView.image = photoImage;
    }
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.bounds.size.width / 3 - 3;
    return CGSizeMake(width, width);
}

#pragma mark Alerts

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Actions" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self)weakSelf = self;
    if (_photos[indexPath.row] != nil) {
        //details
        UIAlertAction *detailsAction = [UIAlertAction actionWithTitle:@"Details" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DetailsVC *detailsVC = [storyboard instantiateViewControllerWithIdentifier:@"DetailsVC"];
            if (detailsVC != nil) {
                detailsVC.photo = weakSelf.photos[indexPath.row];
                [weakSelf.navigationController pushViewController:detailsVC animated:YES];
            }
        }];
        //map
        UIAlertAction *mapAction = [UIAlertAction actionWithTitle:@"Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            MapVC *mapVC = [storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
            if (mapVC != nil) {
                mapVC.photo = weakSelf.photos[indexPath.row];
                [weakSelf.navigationController pushViewController:mapVC animated:YES];
            }
        }];
        //delete
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (weakSelf.photos[indexPath.row] != nil) {
                [weakSelf.photos removeObjectAtIndex:indexPath.row];
                [weakSelf storeData];
                [weakSelf.collectionView reloadData];
            }
        }];
        //cancel
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:detailsAction];
        [alert addAction:mapAction];
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
