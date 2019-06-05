//
//  ASMessageModel.h
//  ASChatViewKit
//
//  Created by Lifee on 2019/4/27.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASMessageProtocol.h"

@interface TestMessageModel : NSObject <ASMessageProtocol>

- (instancetype)initWithText:(NSString *)txt  ;
- (instancetype)initWithImagePath:(NSString *)imgPath ;
- (instancetype)initWithVideoPath:(NSString *)videoPath ;

@end

