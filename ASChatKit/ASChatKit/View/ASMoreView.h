//
//  ASMoreView.h
//  ASChatViewKit
//
//  Created by Lifee on 2019/5/13.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASMoreView ;
typedef NS_ENUM(NSInteger , ASMoreOption) {
    ASMoreOptionPicture = 0 ,
    ASMoreOptionVideo ,
    ASMoreOptionVideoVoip ,
    ASMoreOptionLocation ,
    ASMoreOptionRedPacket ,
    ASMoreOptionTransferFee ,
    ASMoreOptionVoice ,
    ASMoreOptionCollection,
    ASMoreOptionPersonalCard ,
    ASMoreOptionFile ,
    ASMoreOptionCard
};

@protocol ASMoreViewDelegate <NSObject>
@optional
- (void)asMoreView:(ASMoreView *)moreView onClickType:(ASMoreOption)option ;
@end

@interface ASMoreView : UIView
@property (nonatomic ,weak) id <ASMoreViewDelegate> delegate ;
@end

