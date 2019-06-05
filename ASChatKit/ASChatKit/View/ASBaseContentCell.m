//
//  ASBaseContentCell.m
//  NewAS
//
//  Created by Lifee on 2019/5/16.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASBaseContentCell.h"
#import "UIView+ASAddition.h"

@interface ASBaseContentCell()

@end

@implementation ASBaseContentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.avatar];
        if (self.message.msgType != ASMessageTypeImage &&
            self.message.msgType != ASMessageTypeVideo) {
            [self.contentView addSubview:self.bubble];
        }
    }
    return self ;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.avatar setImage:[UIImage imageNamed:_message.target.avatar]];
    if (self.message.isOutGoing) {
        [self.avatar setOrigin:CGPointMake(self.contentView.width - 10 - self.avatar.width, 10)];
    }else{
        [self.avatar setOrigin:CGPointMake(10, 10)];
    }
}
- (void)setMessage:(id<ASMessageProtocol>)message {
    _message = message ;
    if (_message.msgType == ASMessageTypeImage || _message.msgType == ASMessageTypeVideo) {
        return ;
    }
    if (_message.isOutGoing) {
        self.bubble.image = [[UIImage imageNamed:@"ChatRoom_Bubble_Text_Sender_Green"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
    }else{
        [self.bubble setImage:[[UIImage imageNamed:@"ChatRoom_Bubble_Text_Receiver_White"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
    }
}
- (UIImageView *)bubble {
    if (!_bubble) {
        _bubble = [[UIImageView alloc]init];
    }
    return _bubble ;
}
- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        
    }
    return _avatar ;
}
@end
