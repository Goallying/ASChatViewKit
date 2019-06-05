//
//  ASEmojiView.h
//  ASChatViewKit
//
//  Created by Lifee on 2019/5/8.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASEmojiView ;

@protocol ASEmojiViewDelegate <NSObject>

@optional
- (void)asEmojiInput:(ASEmojiView *)emojiView emoji:(NSString *)emoji ;
- (void)asEmojiDelete:(ASEmojiView *)emojiView ;

@end

@interface ASEmojiView : UIView
@property (nonatomic ,weak) id <ASEmojiViewDelegate> delegate ;
@end


