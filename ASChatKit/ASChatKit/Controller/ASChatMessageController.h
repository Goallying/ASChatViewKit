//
//  ASChatMessageViewController.h
//  NewAS
//
//  Created by Lifee on 2019/5/15.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASMessageProtocol.h"

@class ASChatMessageController ;
@protocol ASChatMessageControllerDelegate <NSObject>

@optional
- (void)didTapOnChatMessageController:(ASChatMessageController *)chatMessageController ;
- (void)didTapOnMessage:(id<ASMessageProtocol>)message ;

@end

@interface ASChatMessageController : UITableViewController
@property (nonatomic ,weak) id <ASChatMessageControllerDelegate> delegate ;

- (void)appendMessage:(id<ASMessageProtocol>)message ;
- (void)scrollToBottom ;

@end


