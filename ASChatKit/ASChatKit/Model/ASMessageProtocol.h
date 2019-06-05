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
    ASMessageTypeVideo
};
@protocol ASMessageProtocol <NSObject>

@optional
@property (nonatomic ,copy ,readonly) NSString * msgId ;
@property (nonatomic ,strong ,readonly) id <ASUserProtocol> target;
@property (nonatomic ,copy ,readonly) NSString * time ;
@property (nonatomic ,strong ,readonly) NSString * media_file_path ;
@property (nonatomic ,copy ,readonly) NSString * image_url ;
@property (nonatomic ,copy ,readonly) NSString * text ;
@property (nonatomic ,assign ,readonly) BOOL isOutGoing ;
@property (nonatomic ,assign ,readonly) CGSize contentSize ;
@property (nonatomic ,assign ,readonly) ASMessageType msgType ;
@property (nonatomic ,assign ,readonly) CGFloat msgDuration ;
@end
