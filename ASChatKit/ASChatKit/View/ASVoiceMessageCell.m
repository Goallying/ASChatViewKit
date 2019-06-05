//
//  ASVioceMessageCell.m
//  ASChatKit
//
//  Created by Lifee on 2019/6/5.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASVoiceMessageCell.h"
#import "UIView+ASAddition.h"

@interface ASVoiceMessageCell()

@property (nonatomic ,strong) UIImageView * voiceIcon ;
@property (nonatomic ,strong) UILabel * durationlb ;
@end

@implementation ASVoiceMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.voiceIcon];
        [self.contentView addSubview:self.durationlb];
    }
    return self ;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.message.isOutGoing) {
        [self.bubble setOrigin:CGPointMake(self.avatar.left - 5 - self.bubble.width, self.avatar.top)];
        [self.voiceIcon setCenter:CGPointMake(self.bubble.centerX + 5, self.bubble.centerY)];
        [self.durationlb setRight:self.voiceIcon.left];
        [self.durationlb setCenterY:self.voiceIcon.centerY];
    }else{
        [self.bubble setOrigin:CGPointMake(self.avatar.right + 5, self.avatar.top)];
        [self.voiceIcon setCenter:CGPointMake(self.bubble.centerX - 5, self.bubble.centerY)];
        [self.durationlb setLeft:self.voiceIcon.right];
        [self.durationlb setCenterY:self.voiceIcon.centerY];
    }
}
- (void)setMessage:(id<ASMessageProtocol>)message {
    [super setMessage:message];
    
    UIImage * voiceImage = nil ;
    if (message.isOutGoing) {
        voiceImage = [UIImage imageNamed:@"ChatRoom_Bubble_Voice_Sender"];
    }else {
        voiceImage = [UIImage imageNamed:@"ChatRoom_Bubble_Voice_Receiver"];
    }
    self.voiceIcon.image = voiceImage ;
    self.voiceIcon.size = voiceImage.size ;
    self.durationlb.text = [NSString stringWithFormat:@"%.f\"" ,message.msgDuration];
    [self.durationlb sizeToFit];
    self.bubble.size = CGSizeMake(message.contentSize.width + 20, self.avatar.height);
}
- (UILabel *)durationlb {
    if (!_durationlb) {
        _durationlb = [[UILabel alloc]init];
        _durationlb.textColor = [UIColor blackColor];
        _durationlb.font = [UIFont systemFontOfSize:14];
        _durationlb.textAlignment = NSTextAlignmentCenter ;
    }
    return _durationlb ;
}
- (UIImageView *)voiceIcon {
    if (!_voiceIcon) {
        _voiceIcon = [[UIImageView alloc]init];
    }
    return _voiceIcon ;
}

@end
