//
//  ASChatViewController.h
//  NewAS
//
//  Created by Lifee on 2019/5/15.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASMessageProtocol.h"

@protocol ASChatViewControllerDelegate <NSObject>

@optional
- (void)willSendText:(NSString *)txt ;
- (void)willSendImage:(NSString *)imagePath ;
- (void)willSendVideo:(NSString *)videoPath duration:(CGFloat)duration ;
- (void)willSendVoice:(NSString *)voicePath duration:(CGFloat)duration ;
@end

@interface ASChatViewController : UIViewController

@property (nonatomic ,assign) id <ASChatViewControllerDelegate> delegate ;
- (void)appendMessage:(id<ASMessageProtocol>)message ;
@end

