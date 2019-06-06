//
//  ViewController.m
//  ASChatKit
//
//  Created by Lifee on 2019/6/5.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ViewController.h"
#import "ASChatViewController.h"
#import "TestMessageModel.h"
#import <JMessage/JMessage.h>

@interface ViewController ()<ASChatViewControllerDelegate ,JMessageDelegate>

@property (nonatomic ,strong) ASChatViewController * chatVC ;
@property (nonatomic ,strong) JMSGConversation *conversation  ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addChildViewController:self.chatVC];
    [self.view addSubview:self.chatVC.view];
    
    //
    NSString * uname = [JMSGUser myInfo].username;    
    NSString * chatUname = [uname isEqualToString:@"ASJMSGUser1"]?@"ASJMSGUser2":@"ASJMSGUser1" ;
    _conversation = [JMSGConversation singleConversationWithUsername:chatUname];
    if (!_conversation) {
        [JMSGConversation createSingleConversationWithUsername:chatUname completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                self.conversation = (JMSGConversation *)resultObject ;
                [JMessage addDelegate:self withConversation:self.conversation];
            }
        }];
    }else{
        [JMessage addDelegate:self withConversation:self.conversation];
    }
}
- (void)willSendText:(NSString *)txt {
    
    JMSGTextContent *content = [[JMSGTextContent alloc] initWithText: txt];
    JMSGMessage * jm =  [_conversation createMessageWithContent:content];
    [_conversation sendMessage:jm];
    
    TestMessageModel * msg = [[TestMessageModel alloc]initWithText:txt];
    [self.chatVC appendMessage:msg];
}
- (void)willSendImage:(NSString *)imagePath {
    
    NSURL * url = [NSURL URLWithString:imagePath];
    NSData * data = [NSData dataWithContentsOfURL:url];
    JMSGImageContent * content = [[JMSGImageContent alloc]initWithImageData:data];
    JMSGMessage * jm =  [_conversation createMessageWithContent:content];
    [_conversation sendMessage:jm];
    //
    TestMessageModel  * msg = [[TestMessageModel alloc]initWithImagePath:imagePath];
    [self.chatVC appendMessage:msg];
}
- (void)willSendVideo:(NSString *)videoPath duration:(CGFloat)duration{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoPath]];
    JMSGVideoContent * content = [[JMSGVideoContent alloc]initWithVideoData:data thumbData:nil duration:@(duration)];
    content.format = @"mov";
    JMSGMessage * jm =  [_conversation createMessageWithContent:content];
    [_conversation sendMessage:jm];
    //
    TestMessageModel * msg = [[TestMessageModel alloc]initWithVideoPath:videoPath duration:duration];
    [self.chatVC appendMessage:msg];
}
- (void)willSendVoice:(NSString *)voicePath duration:(CGFloat)duration {
    
    NSData *data = [NSData dataWithContentsOfFile:voicePath];
    JMSGVoiceContent * content = [[JMSGVoiceContent alloc]initWithVoiceData:data voiceDuration:@(duration)];
    JMSGMessage * jm =  [_conversation createMessageWithContent:content];
    [_conversation sendMessage:jm];
    //
    TestMessageModel * msg = [[TestMessageModel alloc]initWithVoicePath:voicePath duration:duration];
    [self.chatVC appendMessage:msg];
}

- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
    if (error) {
        NSLog(@"%@" ,error);
    }
}
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    if (error) return ;
    
    [TestMessageModel messageContentDownloadWithJMSGMessage:message completion:^(TestMessageModel *model) {
        [self.chatVC appendMessage:model];
    }];
    
}







- (ASChatViewController *)chatVC {
    if (!_chatVC) {
        _chatVC = [[ASChatViewController alloc]init];
        _chatVC.view.frame = self.view.bounds ;
        _chatVC.delegate = self ;
    }
    return _chatVC ;
}

@end
