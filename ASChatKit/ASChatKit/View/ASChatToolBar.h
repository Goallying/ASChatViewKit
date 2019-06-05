//
//  ASChatToolBar.h
//  NewAS
//
//  Created by Lifee on 2019/5/15.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASChatToolBar ;

typedef NS_ENUM(NSInteger, ASChatToolBarStatus) {
    /**
     *  无状态
     */
    ASChatToolBarStatusNone,
    /**
     *  声音
     */
    ASChatToolBarStatusVoice,
    /**
     *  表情
     */
    ASChatToolBarStatusEmoji,
    /**
     *  更多
     */
    ASChatToolBarStatusMore,
    /**
     *  键盘
     */
    ASChatToolBarStatusKeyboard,
    
};
@protocol ASChatToolBarDelegate <NSObject>

@optional
- (void)chatToolBar:(ASChatToolBar *)toolBar didChangeChatToolBarHeight:(CGFloat)height ;
- (void)chatToolBar:(ASChatToolBar *)toolBar fromStatus:(ASChatToolBarStatus)s toStatus:(ASChatToolBarStatus)t ;
- (void)chatToolBar:(ASChatToolBar *)toolBar sendText:(NSString *)text ;

@end

@interface ASChatToolBar : UIView
@property (nonatomic ,weak) id <ASChatToolBarDelegate> delegate ;
@property (nonatomic ,assign) ASChatToolBarStatus status ;
@property (nonatomic ,assign) CGFloat barHeight ;
@end

