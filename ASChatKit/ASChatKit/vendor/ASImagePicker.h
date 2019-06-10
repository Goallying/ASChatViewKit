//
//  ASImagePicker.h
//  ASChatKit
//
//  Created by Lifee on 2019/6/10.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASImagePicker : UINavigationController

- (void)imagePickerWithLimit:(NSInteger)limit completion:(void(^)(NSArray * images))completion ;
@end

