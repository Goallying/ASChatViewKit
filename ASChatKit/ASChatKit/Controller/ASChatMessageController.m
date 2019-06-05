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
@interface ASChatMessageController ()
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic ,strong) NSMutableArray * dataSource  ;
@end

@implementation ASChatMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self as_initView];
    
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
    NSLog(@"p  ==== %@" ,path);
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
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
- (void)didTapView:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didTapOnChatMessageController:)]) {
            [self.delegate didTapOnChatMessageController:self];
        }
    }
}
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
    }
    return _tapGesture ;
}
@end
