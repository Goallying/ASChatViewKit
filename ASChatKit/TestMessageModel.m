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
