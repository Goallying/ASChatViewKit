//
//  ASImageMessageCell.m
//  NewAS
//
//  Created by Lifee on 2019/5/17.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASImageMessageCell.h"
#import "UIView+ASAddition.h"

@interface ASImageMessageCell()
@property (nonatomic ,strong) UIImageView * contentImageView ;
@end

@implementation ASImageMessageCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.contentImageView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.message.isOutGoing) {
        [self.contentImageView setOrigin:CGPointMake(self.avatar.left - 5 - self.contentImageView.width, self.avatar.top)];
    }else{
        [self.contentImageView setOrigin:CGPointMake(self.avatar.right + 5, self.avatar.top)];
    }
}
- (void)setMessage:(id<ASMessageProtocol>)message {
    [super setMessage:message];
    
//    NSURL * url = [NSURL URLWithString:message.media_file_path];
//    NSData * data = [NSData dataWithContentsOfURL:url];
//    UIImage * contentImage = [UIImage imageWithData:data];
    self.contentImageView.image = message.image ;
    if (message.image.size.width > 160) {
        self.contentImageView.size = CGSizeMake(160, message.image.size.height * 160 / message.image.size.width) ;
    }else{
        self.contentImageView.size = message.image.size ;
    }
}
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc]init];
        _contentImageView.layer.cornerRadius = 4 ;
        _contentImageView.layer.masksToBounds = YES ;
    }
    return _contentImageView ;
}
@end
