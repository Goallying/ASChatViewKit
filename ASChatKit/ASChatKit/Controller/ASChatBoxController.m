//
//  ASChatBoxController.m
//  NewAS
//
//  Created by Lifee on 2019/5/15.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASChatBoxController.h"
#import "UIView+ASAddition.h"
#import "ASChatToolBar.h"
#import "ASEmojiView.h"

@interface ASChatBoxController ()
<ASChatToolBarDelegate ,
ASMoreViewDelegate ,
ASEmojiViewDelegate>
@property (nonatomic ,strong) ASChatToolBar * toolBar ;
@property (nonatomic ,strong) ASMoreView * moreView ;
@property (nonatomic ,strong) ASEmojiView * emojiView ;
@property (nonatomic ,assign) CGRect keyBoardRect ;
@property (nonatomic ,assign) CGFloat duration ;
@end

@implementation ASChatBoxController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.view addSubview:self.toolBar];
}
#pragma mark --
#pragma mark -- ASMoreViewDelegate --
- (void)asMoreView:(ASMoreView *)moreView onClickType:(ASMoreOption)option {
    if ([self.delegate respondsToSelector:@selector(chatBox:onClickType:)]) {
        [self.delegate chatBox:self onClickType:option];
    }
}
#pragma mark --
#pragma mark -- ASChatToolBarDelegate --
- (void)chatToolBarDidBeginRecordVoice:(ASChatToolBar *)toolBar {
    
}
- (void)chatToolBarDidFinishRecordVoice:(ASChatToolBar *)toolBar filePath:(NSString *)filePath duration:(CGFloat)duration{
    if ([self.delegate respondsToSelector:@selector(chatBox:didFinishRecordVoice:duration:)]) {
        [self.delegate chatBox:self didFinishRecordVoice:filePath duration:duration];
    }
}
- (void)chatToolBarDidCancelRecordVoice:(ASChatToolBar *)toolBar {
    
}
- (void)chatToolBar:(ASChatToolBar *)toolBar sendText:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(chatBox:sendText:)]) {
        [self.delegate chatBox:self sendText:text];
    }
}
- (void)chatToolBar:(ASChatToolBar *)toolBar didChangeChatToolBarHeight:(CGFloat)height {
    self.emojiView.top = height;
    self.moreView.top = height;
    if ([self.delegate respondsToSelector:@selector(chatBox:didChangeHeight:)])
    {
        float h = (self.toolBar.status == ASChatToolBarStatusEmoji ? 215 : self.keyBoardRect.size.height ) + height;
        [_delegate chatBox:self didChangeHeight:h];
    }
}
- (void)chatToolBar:(ASChatToolBar *)toolBar fromStatus:(ASChatToolBarStatus)s toStatus:(ASChatToolBarStatus)t {
    if (t == ASChatToolBarStatusKeyboard) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.emojiView removeFromSuperview];
            [self.moreView removeFromSuperview];
        });
        return ;
    }else if (t == ASChatToolBarStatusVoice){
        if (s == ASChatToolBarStatusMore || s == ASChatToolBarStatusEmoji) {
            [UIView animateWithDuration:0.3 animations:^{
                if ([self.delegate respondsToSelector:@selector(chatBox:didChangeHeight:)]) {
                    [self.delegate chatBox:self didChangeHeight:49];
                }
            } completion:^(BOOL finished) {
                [self.emojiView removeFromSuperview];
                [self.moreView removeFromSuperview];
            }];
        }else {
            [UIView animateWithDuration:0.3 animations:^{
                if ([self.delegate respondsToSelector:@selector(chatBox:didChangeHeight:)]) {
                    [self.delegate chatBox:self didChangeHeight:49];
                }
            }];
        }
    }else if (t == ASChatToolBarStatusEmoji){
        if (s == ASChatToolBarStatusVoice || s == ASChatToolBarStatusNone) {
            [self.emojiView setTop:self.toolBar.barHeight];
            // 添加表情View
            [self.view addSubview:self.emojiView];
            [UIView animateWithDuration:0.3 animations:^{
                if ([self.delegate respondsToSelector:@selector(chatBox:didChangeHeight:)]) {
                    [self.delegate chatBox:self didChangeHeight:self.toolBar.barHeight + 215];
                }
            }];
        }else {
            [self.emojiView setTop:self.toolBar.barHeight + 215];
            [self.view addSubview:self.emojiView];
            [UIView animateWithDuration:0.3 animations:^{
                self.emojiView.top = self.toolBar.barHeight ;
            } completion:^(BOOL finished) {
                [self.moreView removeFromSuperview];
            }];
            // 整个界面高度变化
            if (s != ASChatToolBarStatusMore) {
                [UIView animateWithDuration:0.2 animations:^{
                    if ([self.delegate respondsToSelector:@selector(chatBox:didChangeHeight:)]) {
                        [self.delegate chatBox:self didChangeHeight:self.toolBar.barHeight + 215];
                    }
                }];
            }
        }
    } else if (t == ASChatToolBarStatusMore)
    {
        // 显示更多面板
        if (s == ASChatToolBarStatusVoice || s == ASChatToolBarStatusNone) {
            [self.moreView setTop:self.toolBar.barHeight];
            [self.view addSubview:self.moreView];
            [UIView animateWithDuration:0.3 animations:^{
                if ([self.delegate respondsToSelector:@selector(chatBox:didChangeHeight:)]) {
                    [self.delegate chatBox:self didChangeHeight:self.toolBar.barHeight + 215];
                }
            }];
        }
        else {
            self.moreView.top = self.toolBar.barHeight + 215;
            [self.view addSubview:self.moreView];
            [UIView animateWithDuration:0.3 animations:^{
                self.moreView.top = self.toolBar.barHeight;
            } completion:^(BOOL finished) {
                [self.emojiView removeFromSuperview];
            }];
            
            if (s != ASChatToolBarStatusEmoji) {
                [UIView animateWithDuration:0.2 animations:^{
                    if ([self.delegate respondsToSelector:@selector(chatBox:didChangeHeight:)]) {
                        [self.delegate chatBox:self didChangeHeight:self.toolBar.barHeight + 215];
                    }
                }];
            }
        }
    }
}
#pragma mark --
#pragma mark -- UIKeyboardNotification --
- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyBoardRect = CGRectZero;
    if (_toolBar.status == ASChatToolBarStatusEmoji || _toolBar.status == ASChatToolBarStatusMore) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(chatBox:didChangeHeight:)]) {
        [self.delegate chatBox:self didChangeHeight:_toolBar.height];
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    self.keyBoardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (_toolBar.status == ASChatToolBarStatusKeyboard && self.keyBoardRect.size.height <= 215) {
        return;
    }
    else if ((_toolBar.status == ASChatToolBarStatusEmoji || _toolBar.status == ASChatToolBarStatusMore) && self.keyBoardRect.size.height <= 215) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBox:didChangeHeight:)]) {
        [self.delegate chatBox:self didChangeHeight:self.keyBoardRect.size.height + _toolBar.barHeight];
    }
}
- (BOOL)resignFirstResponder {
    if (_toolBar.status != ASChatToolBarStatusNone && _toolBar.status != ASChatToolBarStatusVoice)
    {
        // 回收键盘
        [_toolBar resignFirstResponder];
        _toolBar.status = (_toolBar.status == ASChatToolBarStatusVoice ? _toolBar.status : ASChatToolBarStatusNone);
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:didChangeHeight:)])
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.delegate chatBox:self didChangeHeight:self.toolBar.barHeight];
            } completion:^(BOOL finished) {
                [self.emojiView removeFromSuperview];
                [self.moreView removeFromSuperview];
            }];
        }
    }
    
    return [super resignFirstResponder];
}
- (ASMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[ASMoreView alloc]initWithFrame:CGRectMake(0, 49, self.view.width, 215)];
        _moreView.delegate = self ;
    }
    return _moreView ;
}
- (ASEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[ASEmojiView alloc]initWithFrame:CGRectMake(0, 49, self.view.width, 215)];
        _emojiView.delegate = self ;
    }
    return _emojiView ;
}
- (ASChatToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[ASChatToolBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 49)];
        _toolBar.delegate = self ;
    }
    return _toolBar ;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
