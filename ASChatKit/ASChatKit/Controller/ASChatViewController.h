//
//  ASChatViewController.h
//  NewAS
//
//  Created by Lifee on 2019/5/15.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASMessageProtocol.h"
@class ASChatViewController ;

@protocol ASChatViewControllerDelegate <NSObject>

@optional
- (void)willSendText:(NSString *)txt ;
- (void)willSendImage:(UIImage *)image;

- (void)willRecordVoice:(ASChatViewController *)chatController ;
- (void)willCancelRecordVoice:(ASChatViewController *)chatController ;
- (void)willSendVoice:(ASChatViewController *)chatController voice:(NSString *)voicePath duration:(CGFloat)duration ;

- (void)willSendVideo:(NSString *)videoPath duration:(CGFloat)duration ;

// for override 如果不希望使用系统相册或者相机 ,willSendVideo/willSendImage 方法不会调用
- (void)willOpenAlbum ;
- (void)willOpenCamera ;
@end

@interface ASChatViewController : UIViewController

@property (nonatomic ,assign) id <ASChatViewControllerDelegate> delegate ;
- (void)appendMessage:(id<ASMessageProtocol>)message ;
- (id<ASMessageProtocol>)latestMessage ;
- (void)updateLatestMessage ;

@end

