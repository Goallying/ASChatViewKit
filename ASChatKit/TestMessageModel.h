//
//  ASMessageModel.h
//  ASChatViewKit
//
//  Created by Lifee on 2019/4/27.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMSGMessage.h>
#import "ASMessageProtocol.h"

@interface TestMessageModel : NSObject <ASMessageProtocol>

//send
- (instancetype)initWithText:(NSString *)txt  ;
- (instancetype)initWithImagePath:(NSString *)imgPath ;
- (instancetype)initWithVideoPath:(NSString *)videoPath duration:(CGFloat)duration;
- (instancetype)initWithVoicePath:(NSString *)voicePath duration:(CGFloat)duration;

//receive
- (instancetype)initWithJMSGMessage:(JMSGMessage *)message ;
@end

