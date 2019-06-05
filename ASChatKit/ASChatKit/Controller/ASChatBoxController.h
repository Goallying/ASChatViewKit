//
//  ASChatBoxController.h
//  NewAS
//
//  Created by Lifee on 2019/5/15.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASMoreView.h"

@class ASChatBoxController ;
@protocol ASChatBoxControllerDelegate <NSObject>

@optional
- (void)chatBox:(ASChatBoxController *)chatBox didChangeHeight:(CGFloat)height ;
- (void)chatBox:(ASChatBoxController *)chatBox sendText:(NSString *)text ;
- (void)chatBox:(ASChatBoxController *)chatBox onClickType:(ASMoreOption)option ;
//voice
- (void)chatBox:(ASChatBoxController *)chatBox didFinishRecordVoice:(NSString *)filePath duration:(CGFloat)duration ;

@end

@interface ASChatBoxController : UIViewController
@property (nonatomic ,weak) id <ASChatBoxControllerDelegate> delegate ;
@end


