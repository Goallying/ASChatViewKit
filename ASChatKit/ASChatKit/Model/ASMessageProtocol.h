//
//  ASMessageProtocol.h
//  ASChatViewKit
//
//  Created by Lifee on 2019/4/27.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASUserProtocol.h"

typedef NS_ENUM(NSInteger ,ASMessageType) {
    ASMessageTypeText ,
    ASMessageTypeImage ,
    ASMessageTypeVoice ,
    ASMessageTypeVideo ,
    ASMessageTypeNone
};
@protocol ASMessageProtocol <NSObject>

@optional
- (NSString *) msgId ;
- (id <ASUserProtocol>) target;
- (NSString *)time ;
- (NSString *)media_file_path ;
- (NSString *)image_url ;
- (NSString *)text ;
- (BOOL)isOutGoing ;
- (CGSize)contentSize ;
- (ASMessageType)msgType ;
- (CGFloat)msgDuration ;
@end
