//
//  ASChatMessageViewController.m
//  NewAS
//
//  Created by Lifee on 2019/5/15.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASChatMessageController.h"
#import "ASTextMessageCell.h"
#import "ASImageMessageCell.h"
#import "ASVideoMessageCell.h"
#import "ASVoiceMessageCell.h"

#import <AVFoundation/AVFoundation.h>

@interface ASChatMessageController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic ,strong) NSMutableArray * dataSource  ;
@property (nonatomic ,strong) AVAudioPlayer *player ;
@end

@implementation ASChatMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self as_initView];
}
- (void)as_initView {
    [self.view addGestureRecognizer:self.tapGesture];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[ASTextMessageCell class] forCellReuseIdentifier:@"Text"];
    [self.tableView registerClass:[ASImageMessageCell class] forCellReuseIdentifier:@"Image"];
    [self.tableView registerClass:[ASVideoMessageCell class] forCellReuseIdentifier:@"Video"];
    [self.tableView registerClass:[ASVoiceMessageCell class] forCellReuseIdentifier:@"Voice"];
}
- (void)appendMessage:(id<ASMessageProtocol>)message {
    [self.dataSource addObject:message];

    [UIView performWithoutAnimation:^{
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
}
- (id<ASMessageProtocol>)latestMessage {
    if (self.dataSource.count == 0) {
        return  nil;
    }
    return self.dataSource[self.dataSource.count - 1];
}
- (void)updateLatestMessage {
    
    if (self.dataSource.count == 0) return ;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <ASMessageProtocol> message = self.dataSource [indexPath.row];
    return message.contentSize.height + 20 + 20 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <ASMessageProtocol> message = self.dataSource [indexPath.row];
    if (message.msgType == ASMessageTypeText) {
        ASTextMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Text" forIndexPath:indexPath];
        cell.message = message;
        return cell ;
    }else if (message.msgType == ASMessageTypeImage){
        ASImageMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Image" forIndexPath:indexPath];
        cell.message = message;
        return cell ;
    }else if (message.msgType == ASMessageTypeVideo){
        ASVideoMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Video" forIndexPath:indexPath];
        cell.message = message;
        return cell ;
    }else if (message.msgType == ASMessageTypeVoice){
        ASVoiceMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Voice" forIndexPath:indexPath];
        cell.message = message;
        return cell ;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id <ASMessageProtocol> message = self.dataSource [indexPath.row];

    if ([self.delegate respondsToSelector:@selector(didTapOnMessage:)]) {
        [self.delegate didTapOnMessage:message];
    }
    if (message.msgType == ASMessageTypeVoice) {
        [self playVoice:message.media_file_path];
    }
}
- (void)playVoice:(NSString *)p {
    
    NSURL *url = [NSURL URLWithString:p] ;
    //    初始化播放器
    NSError * error = nil ;
    //一定要是全局变量
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) {
        NSLog(@"error----------%@",error.localizedDescription);
    }
    //    设置播放器声音
        _player.volume = 1;
    //    设置代理
//        player.delegate = self;
    //    设置播放速率
        _player.rate = 1.0;
    //    设置播放次数 负数代表无限循环
//        player.numberOfLoops = -1;
    //    准备播放
    [_player prepareToPlay] ;
    [_player play];
    
}
- (void)didTapView:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didTapOnChatMessageController:)]) {
            [self.delegate didTapOnChatMessageController:self];
        }
    }
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//           return NO;
//       }
//    return  YES;
//}
- (void)scrollToBottom {
    if (self.dataSource.count < 1) return ;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource ;
}
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
        _tapGesture.cancelsTouchesInView = NO ;
        _tapGesture.delegate = self ;
    }
    return _tapGesture ;
}
@end
