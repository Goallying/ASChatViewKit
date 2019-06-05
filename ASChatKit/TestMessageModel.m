//
//  ASMessageModel.m
//  ASChatViewKit
//
//  Created by Lifee on 2019/4/27.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "TestMessageModel.h"
#import "TestUser.h"

@interface TestMessageModel()
@property (nonatomic ,copy) NSString * txt ;
@property (nonatomic ,assign) BOOL isOutGoing ;
@property (nonatomic ,assign) ASMessageType msgType ;
@property (nonatomic ,copy) NSString * mediaPath ;
@property (nonatomic ,assign) CGSize contentSize ;
@property (nonatomic ,assign) CGFloat duration ;
@end

@implementation TestMessageModel

- (instancetype)initWithText:(NSString *)txt {
    if (self = [super init]) {
        _txt = txt ;
        _isOutGoing = YES ;
        _msgType = ASMessageTypeText ;
        
        _contentSize = [_txt boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size ;
    }
    return self ;
}
- (instancetype)initWithImagePath:(NSString *)imgPath {
    if (self = [super init]) {
        _isOutGoing = YES ;
        _msgType = ASMessageTypeImage ;
        _mediaPath = imgPath ;
        
        NSURL * url = [NSURL URLWithString:self.mediaPath];
        NSData * data = [NSData dataWithContentsOfURL:url];
        UIImage * img = [UIImage imageWithData:data];
        if (img.size.width > 160) {
            _contentSize = CGSizeMake(160, img.size.height * 160.f / img.size.width) ;
        }else{
            _contentSize = img.size ;
        }
    }
    return self ;
}
- (instancetype)initWithVideoPath:(NSString *)videoPath {
    if (self = [super init]) {
        _isOutGoing = YES ;
        _msgType = ASMessageTypeVideo ;
        _mediaPath = videoPath ;
        
        _contentSize = CGSizeMake(160, 190);
    }
    return self ;
}
- (instancetype)initWithVoicePath:(NSString *)voicePath duration:(CGFloat)duration {
    if (self = [super init]) {
        
//        file:///private/var/mobile/Containers/Data/Application/88E3A128-2C16-4ED4-A9E6-C96FC0A6411F/tmp/58140876399__A37E4228-ED82-4290-8191-72BBF293BAA3.MOV
        _isOutGoing = YES ;
        _msgType = ASMessageTypeVoice ;
        _mediaPath = voicePath ;
        _duration = duration ;
        
        UIImage * img = [UIImage imageNamed:@"ChatRoom_Bubble_Voice_Sender"];
        _contentSize = CGSizeMake(img.size.width + 44 + duration * 2, img.size.height);
    }
    return  self ;
}

- (instancetype)initWithJMSGMessage:(JMSGMessage *)message {
    if (self = [super init]) {
        _isOutGoing = NO ;
        NSString * root =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        switch (message.contentType) {
            case kJMSGContentTypeText:
            {
                _msgType = ASMessageTypeText ;
            }
                break;
            case kJMSGContentTypeImage:
            {
                _msgType = ASMessageTypeImage ;
                _mediaPath = [root stringByAppendingFormat:@"/jImage%@" ,message.serverMessageId];
            }
                break ;
            case kJMSGContentTypeVoice:
            {
                _msgType = ASMessageTypeVoice ;
                _mediaPath = [root stringByAppendingFormat:@"/jVoice%@" ,message.serverMessageId];
            }
                break ;
            case kJMSGContentTypeVideo:
            {
                _msgType = ASMessageTypeVideo ;
                _mediaPath = [root stringByAppendingFormat:@"/jVideo%@" ,message.serverMessageId];
            }
                break ;
            default:
                _msgType = ASMessageTypeNone ;
                break;
        }
    }
    return self ;
}


- (CGFloat)msgDuration {
    return _duration ;
}
- (NSString *)text {
    return _txt;
}
- (BOOL)isOutGoing {
    return _isOutGoing;
}
- (ASMessageType)msgType {
    return _msgType ;
}
- (NSString *)media_file_path{
    return _mediaPath ;
}
- (NSString *)time {
    return @"2019" ;
}
- (NSString *)msgId{
    return @"ID1111111";
}
- (NSString *)image_url {
    return  @"" ;
}
- (CGSize)contentSize {
    return _contentSize ;
}
- (id<ASUserProtocol>)target {
    TestUser * u = [[TestUser alloc]init];
    return u ;
}

@end
