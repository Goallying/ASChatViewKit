//
//  ASChatToolBar.m
//  NewAS
//
//  Created by Lifee on 2019/5/15.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASChatToolBar.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+ASAddition.h"

#define ASTextViewHeight 34
#define ASMaxTextViewHeight 88

@interface ASChatToolBar()<UITextViewDelegate>
@property (nonatomic ,strong) UIButton * addBtn ;
@property (nonatomic ,strong) UIButton * emojiBtn ;
@property (nonatomic ,strong) UITextView * textView ;
@property (nonatomic ,strong) UIButton * voiceBtn ;
@property (nonatomic ,strong) UIButton * talkButton ;
@property (nonatomic ,assign) CGRect rct  ;

@property (nonatomic ,strong) AVAudioRecorder * recorder ;
@property (nonatomic ,copy) NSString * voiceFilePath ;
@end

@implementation ASChatToolBar


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        _barHeight = frame.size.height ;
        _rct = frame ;
        _status = ASChatToolBarStatusNone ;
        [self as_initView];
    }
    return self ;
}

- (void)as_initView {
    
    UIView * topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.rct.size.width, 0.5)];
    [topline setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
    [self addSubview:topline];
    
    [self addSubview:self.voiceBtn];
    [self addSubview:self.textView];
    [self addSubview:self.emojiBtn];
    [self addSubview:self.addBtn];
    [self addSubview:self.talkButton];
}
- (void)voiceClick:(UIButton *)btn {
    btn.selected = !btn.selected ;
    ASChatToolBarStatus last = _status ;
    if (last == ASChatToolBarStatusVoice) {
        _status = ASChatToolBarStatusKeyboard ;
        [self.talkButton setHidden:YES];
        [self.textView setHidden:NO];
        [self.textView becomeFirstResponder];
    }else {
        _barHeight = 49;
        self.height = _barHeight ;
        _status = ASChatToolBarStatusVoice ;
        [self.textView resignFirstResponder];
        [self.textView setHidden:YES];
        [self.talkButton setHidden:NO];
        [self.voiceBtn setSelected:YES];
        if (last == ASChatToolBarStatusEmoji) {
            [self.emojiBtn setSelected:NO];
        }else if (last == ASChatToolBarStatusMore){
            [self.addBtn setSelected:NO];
        }
    }
    if ([self.delegate respondsToSelector:@selector(chatToolBar:fromStatus:toStatus:)]) {
        [self.delegate chatToolBar:self fromStatus:last toStatus:_status];
    }
}
- (void)additionalClick:(UIButton *)btn {
    
    btn.selected = !btn.selected ;
    ASChatToolBarStatus last = _status ;
    if (last == ASChatToolBarStatusMore) {
        _status = ASChatToolBarStatusKeyboard ;
        [_textView becomeFirstResponder];
    }else{
        _status = ASChatToolBarStatusMore ;
        if (last == ASChatToolBarStatusEmoji) {
            [self.emojiBtn setSelected:NO];
        }else if (last == ASChatToolBarStatusVoice){
            [self.voiceBtn setSelected:NO];
            [self.talkButton setHidden:YES];
            [self.textView setHidden:NO];
        }else if (last == ASChatToolBarStatusKeyboard){
            [self.textView resignFirstResponder];
        }
    }
    if ([self.delegate respondsToSelector:@selector(chatToolBar:fromStatus:toStatus:)]) {
        [self.delegate chatToolBar:self fromStatus:last toStatus:_status];
    }
}
- (void)emojiClick:(UIButton *)btn {
    btn.selected = !btn.selected ;
    ASChatToolBarStatus last = _status ;
    if (last == ASChatToolBarStatusEmoji) {
        _status = ASChatToolBarStatusKeyboard ;
        [_textView becomeFirstResponder];
    }else{
        _status = ASChatToolBarStatusEmoji ;
        if (last == ASChatToolBarStatusMore) {
            [self.addBtn setSelected:NO];
        }else if (last == ASChatToolBarStatusVoice){
            [self.voiceBtn setSelected:NO];
            [self.talkButton setHidden:YES];
            [self.textView setHidden:NO];
        }else if (last == ASChatToolBarStatusKeyboard){
            [self.textView resignFirstResponder];
        }
    }
    if ([self.delegate respondsToSelector:@selector(chatToolBar:fromStatus:toStatus:)]) {
        [self.delegate chatToolBar:self fromStatus:last toStatus:_status];
    }
}
- (void)recordStart:(UIButton *)btn {
    if (_recorder) {
        if ([_recorder isRecording]) {
            [_recorder stop];
        }
        _recorder = nil ;
    }
    if (![self.recorder isRecording]) {
        [self.recorder record];
    }
    
}
- (void)recordCancel:(UIButton *)btn {
    [self.recorder stop];
    //need to delete local file.
    if ([self.delegate respondsToSelector:@selector(chatToolBarDidCancelRecordVoice:)]) {
        [self.delegate chatToolBarDidCancelRecordVoice:self];
    }
}
- (void)recordFinish:(UIButton *)btn {
    [self.recorder stop];
    
    NSURL * url = [NSURL URLWithString:[@"file://" stringByAppendingString:self.recorder.url.absoluteString]];
    AVURLAsset * audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    float audioDurationSeconds = CMTimeGetSeconds(audioAsset.duration);
    if ([self.delegate respondsToSelector:@selector(chatToolBarDidFinishRecordVoice:filePath: duration:)]  && audioDurationSeconds > 0) {
        [self.delegate chatToolBarDidFinishRecordVoice:self filePath:self.recorder.url.absoluteString duration:audioDurationSeconds];
    }
}
- (BOOL)resignFirstResponder {
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    ASChatToolBarStatus last = _status ;
    _status = ASChatToolBarStatusKeyboard ;
    if (last == ASChatToolBarStatusEmoji) {
        [self.emojiBtn setSelected:NO];
    }else if (last == ASChatToolBarStatusMore){
        [self.addBtn setSelected:NO];
    }
    if ([self.delegate respondsToSelector:@selector(chatToolBar:fromStatus:toStatus:)]) {
        [self.delegate chatToolBar:self fromStatus:last toStatus:_status];
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat height = [textView sizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)].height;
    height = height > ASTextViewHeight ? height : ASTextViewHeight;
    height = height < ASMaxTextViewHeight ? height : textView.height;
    _barHeight = height + 49 - ASTextViewHeight;
    if (_barHeight != self.height) {
        [UIView animateWithDuration:0.05 animations:^{
            [self setHeight:self.barHeight];
            if ([self.delegate respondsToSelector:@selector(chatToolBar:didChangeChatToolBarHeight:)]) {
                [self.delegate chatToolBar:self didChangeChatToolBarHeight:self.barHeight];
            }
        }];
    }
    if (height != textView.height) {
        [UIView animateWithDuration:0.05 animations:^{
            [textView setHeight:height];
        }];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(chatToolBar:sendText:)]) {
            [self.delegate chatToolBar:self sendText:textView.text];
        }
        return NO ;
    }
    return YES;
}
- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        NSString * timeString = [NSString stringWithFormat:@"%.f", interval];

        NSString * path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * filePath = [path stringByAppendingFormat:@"/%@.caf",timeString];
        
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        //录音格式 无法使用
        [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        //采样率
        [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
        //通道数
        [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
        //线性采样位数
        //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
        //音频质量,采样质量
        [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
        NSError * error = nil ;
        _recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:filePath] settings:recordSettings error:&error];
        [_recorder prepareToRecord];
        if (error) {
            NSLog(@"AVAudioRecorder init error");
        }
    }
    return _recorder ;
}
- (UIButton *)talkButton {
    if (!_talkButton) {
        _talkButton = [[UIButton alloc]initWithFrame:CGRectMake(self.voiceBtn.right + 5, self.centerY - ASTextViewHeight / 2, self.emojiBtn.left - 5 - self.voiceBtn.right - 5, ASTextViewHeight)];
        [_talkButton setHidden:YES];
        [_talkButton.layer setCornerRadius:5];
        [_talkButton.layer setMasksToBounds:YES];
        [_talkButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_talkButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        
        [_talkButton setBackgroundImage:[self as_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_talkButton setBackgroundImage:[self as_imageWithColor:[UIColor colorWithWhite:0.6 alpha:1]] forState:UIControlStateHighlighted];
        
        [_talkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_talkButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        [_talkButton.layer setCornerRadius:5];
        [_talkButton addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchDown];
        [_talkButton addTarget:self action:@selector(recordCancel:) forControlEvents: UIControlEventTouchDragExit | UIControlEventTouchUpOutside];
        [_talkButton addTarget:self action:@selector(recordFinish:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _talkButton ;
}
- (UIImage *)as_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;

}

- (UIButton *)addBtn {
    if (!_addBtn) {
        UIImage * addImage = [UIImage imageNamed:@"ToolViewAdd"];
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 10 - addImage.size.width, self.centerY - addImage.size.height / 2, addImage.size.width, addImage.size.height)];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewAdd"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(additionalClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn ;
}
-(UIButton *)emojiBtn {
    if (!_emojiBtn) {
        UIImage * emojiImage = [UIImage imageNamed:@"ToolViewEmotion"] ;
        _emojiBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.addBtn.left - 5 - emojiImage.size.width, self.centerY - emojiImage.size.height / 2, emojiImage.size.width, emojiImage.size.height)];
        [_emojiBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_emojiBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
        [_emojiBtn addTarget:self action:@selector(emojiClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiBtn ;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(self.voiceBtn.right + 5, self.centerY - ASTextViewHeight / 2, self.emojiBtn.left - 5 - self.voiceBtn.right - 5, ASTextViewHeight)];
        [_textView.layer setCornerRadius:5];
        [_textView.layer setMasksToBounds:YES];
        _textView.delegate = self ;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeySend ;
        _textView.font = [UIFont systemFontOfSize:14];
    }
    return _textView ;
}
- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        UIImage * voiceImage = [UIImage imageNamed:@"ToolViewInputVoice"] ;
        _voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, self.centerY - voiceImage.size.height/2 , voiceImage.size.width, voiceImage.size.height)];
        [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(voiceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn ;
}
@end
