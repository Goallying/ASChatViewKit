//
//  ASImagePicker.m
//  ASChatKit
//
//  Created by Lifee on 2019/6/10.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASImagePicker.h"
#import <Photos/Photos.h>

@interface ASImagePicker()
@property (nonatomic ,copy) void (^completion)(NSArray * images) ;
@property (nonatomic ,strong) UICollectionView * collectonView ;
@end

@implementation ASImagePicker
- (NSString *)title {
    return @"相机胶卷";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)imagePickerWithLimit:(NSInteger)limit completion:(void (^)(NSArray *))completion {
    PHAuthorizationStatus st =  [PHPhotoLibrary authorizationStatus] ;
    if (st == PHAuthorizationStatusNotDetermined ) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    self.completion = completion ;
                } else {
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该应用没有访问相册的权限，您可以在设置中修改该配置" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:act];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            });
        }];
    }else if (st == PHAuthorizationStatusAuthorized) {
        
    }else {
        
    }
}


@end
