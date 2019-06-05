//
//  ASTextMessageCell.m
//  NewAS
//
//  Created by Lifee on 2019/5/16.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASTextMessageCell.h"
#import "UIView+ASAddition.h"

@interface ASTextMessageCell()
@property (nonatomic ,strong) UILabel * contentlb ;
@end

@implementation ASTextMessageCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.contentlb];
    }
    return self ;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.message.isOutGoing) {
        [self.bubble setOrigin:CGPointMake(self.avatar.left - 5 - self.bubble.width, self.avatar.top)];
        [self.contentlb setCenter:CGPointMake(self.bubble.centerX - 3, self.bubble.centerY)];
    }else{
        [self.bubble setOrigin:CGPointMake(self.avatar.right + 5, self.avatar.top)];
        [self.contentlb setCenter:CGPointMake(self.bubble.centerX + 3, self.bubble.centerY)];
    }

}
- (void)setMessage:(id<ASMessageProtocol>)message {
    [super setMessage:message];
    _contentlb.text = message.text ;
    _contentlb.size = message.contentSize;
    self.bubble.size = CGSizeMake(_contentlb.size.width + 20, _contentlb.size.height + 20);
}
- (UILabel *)contentlb {
    if (!_contentlb) {
        _contentlb = [[UILabel alloc]init];
        _contentlb.font = [UIFont systemFontOfSize:15];
        _contentlb.numberOfLines = 0 ;
    }
    return _contentlb ;
}
@end
