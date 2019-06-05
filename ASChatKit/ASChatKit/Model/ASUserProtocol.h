//
//  ASUserProtocol.h
//  ASChatViewKit
//
//  Created by Lifee on 2019/4/27.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASUserProtocol <NSObject>

@property (nonatomic ,copy ,readonly) NSString * usr_id ;
@property (nonatomic ,copy ,readonly) NSString * displayName ;
@property (nonatomic ,strong ,readonly) NSString * avatar ;
@property (nonatomic ,copy ,readonly) NSString * avatarURL ;

@end

