//
//  ASVideoMessageCell.m
//  ASChatKit
//
//  Created by Lifee on 2019/6/3.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASVideoMessageCell.h"
#import "UIView+ASAddition.h"
#import <AVFoundation/AVFoundation.h>
@interface ASVideoMessageCell()
@property (nonatomic ,strong) UIImageView * playImageIcon ;
@property (nonatomic ,strong) UIImageView * thumbImageView ;

@end

@implementation ASVideoMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.thumbImageView];
        [self.contentView addSubview:self.playImageIcon];
    }
    return self ;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.thumbImageView.size = CGSizeMake(160, 190);
    if (self.message.isOutGoing) {
        [self.thumbImageView setOrigin:CGPointMake(self.avatar.left - 5 - self.thumbImageView.width, self.avatar.top)];
    }else{
        [self.thumbImageView setOrigin:CGPointMake(self.avatar.right + 5, self.avatar.top)];
    }
    self.playImageIcon.size = CGSizeMake(44, 44);
    self.playImageIcon.center = self.thumbImageView.center ;
}
- (void)setMessage:(id<ASMessageProtocol>)message {
    [super setMessage:message];
    
    [self getVideoThumbImageAsynchronously:message.media_file_path
                                completion:^(UIImage *image) {
                                    self.thumbImageView.image = image ;
    }];
}
- (void)getVideoThumbImageAsynchronously:(NSString *)filePath completion:(void(^)(UIImage * image))completion{
    if (!filePath) return ;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset * asset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:filePath] options:nil];
        // get video shoot
        AVAssetImageGenerator *imgGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        NSError *error = nil;
        imgGenerator.appliesPreferredTrackTransform = YES;
        CGImageRef cgImg = [imgGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error: &error];
        if (!error) {
            UIImage *img = [UIImage imageWithCGImage:cgImg];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(img);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
        }
    });
}

- (UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc]init];
    }
    return _thumbImageView ;
}
- (UIImageView *)playImageIcon {
    if (!_playImageIcon) {
        _playImageIcon = [[UIImageView alloc]init];
        _playImageIcon.image = [UIImage imageNamed:@"video_icon_play"];
    }
    return _playImageIcon ;
}
@end
