//
//  ASMessageModel.h
//  ASChatViewKit
//
//  Created by Lifee on 2019/4/27.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>
#import "ASMessageProtocol.h"

@interface TestMessageModel : NSObject <ASMessageProtocol>

@property (nonatomic ,copy) NSString * txt ;
@property (nonatomic ,strong) UIImage * image ;
@property (nonatomic ,assign) BOOL isOutGoing ;
@property (nonatomic ,assign) ASMessageType msgType ;
@property (nonatomic ,copy) NSString * mediaPath ;
@property (nonatomic ,assign) CGSize contentSize ;
@property (nonatomic ,assign) CGFloat duration ;

//send
- (instancetype)initWithText:(NSString *)txt  ;
- (instancetype)initWithImage:(UIImage *)image ;
- (instancetype)initWithVideoPath:(NSString *)videoPath duration:(CGFloat)duration;
- (instancetype)initWithVoicePath:(NSString *)voicePath duration:(CGFloat)duration;

//receive
+ (void)messageContentDownloadWithJMSGMessage:(JMSGMessage *)message
                                   completion:(void(^)(TestMessageModel * model))completion;
@end

