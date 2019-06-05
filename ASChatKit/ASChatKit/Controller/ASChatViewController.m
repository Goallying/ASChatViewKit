//
//  ASChatViewController.m
//  NewAS
//
//  Created by Lifee on 2019/5/15.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASChatViewController.h"
#import "UIView+ASAddition.h"
#import "ASChatMessageController.h"
#import "ASChatBoxController.h"

//Test
#import "TestMessageModel.h"

@interface ASChatViewController ()
<ASChatMessageControllerDelegate,
ASChatBoxControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic ,strong) ASChatMessageController * messageVC ;
@property (nonatomic ,strong) ASChatBoxController *chatBoxVC ;
@end

@implementation ASChatViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self as_initView];
}
- (void)as_initView {
    [self.view addSubview:self.messageVC.view];
    [self addChildViewController:self.messageVC];
    
    [self.view addSubview:self.chatBoxVC.view];
    [self addChildViewController:self.chatBoxVC];
    
    //
}
#pragma mark --
#pragma mark -- ASChatBoxDelegate --
- (void)chatBox:(ASChatBoxController *)chatBox onClickType:(ASMoreOption)option {
    switch (option) {
        case ASMoreOptionPicture:
        {
            [self openAlbum];
        }
            break;
        case ASMoreOptionVideo:
        {
            [self openCamera];
        }
            break ;
        default:
            break;
    }
}
- (void)chatBox:(ASChatBoxController *)chatBox sendText:(NSString *)text {
    TestMessageModel * message = [[TestMessageModel alloc]initWithText:text];
    [self.messageVC appendMessage:message];
}
- (void)chatBox:(ASChatBoxController *)chatBox didFinishRecordVoice:(NSString *)filePath duration:(CGFloat)duration {
    TestMessageModel * message = [[TestMessageModel alloc]initWithVoicePath:filePath duration:duration];
    [self.messageVC appendMessage:message];
}
- (void)chatBox:(ASChatBoxController *)chatBox didChangeHeight:(CGFloat)height {
    self.messageVC.view.height = self.view.height - height - self.view.safeAreaInsets.bottom ;
    self.chatBoxVC.view.top = self.messageVC.view.height ;
    self.chatBoxVC.view.height = self.messageVC.view.height ;
    [self.messageVC scrollToBottom];
}

- (void)openAlbum {
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
    picker.delegate = self ;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)openCamera {
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera ;
    picker.delegate = self ;
    picker.mediaTypes =  @[@"public.movie"] ;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.movie"]) {
        NSURL * videoURL = info[UIImagePickerControllerMediaURL];
        TestMessageModel * message = [[TestMessageModel alloc]initWithVideoPath:videoURL.absoluteString];
        [self.messageVC appendMessage:message];
        
    }else if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"]){
//        UIImage * image = info[UIImagePickerControllerOriginalImage];
        NSURL * imageURL = info[UIImagePickerControllerImageURL];
        TestMessageModel * message = [[TestMessageModel alloc]initWithImagePath:imageURL.absoluteString];
        [self.messageVC appendMessage:message];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)didTapOnChatMessageController:(ASChatMessageController *)chatMessageController {
    [self.chatBoxVC resignFirstResponder];
    
}
- (ASChatBoxController *)chatBoxVC {
    if (!_chatBoxVC) {
        _chatBoxVC = [[ASChatBoxController alloc]init];
        _chatBoxVC.view.frame = CGRectMake(0, self.view.height - 54 - self.view.safeAreaInsets.bottom, self.view.width, 54 + self.view.safeAreaInsets.bottom);
        _chatBoxVC.delegate = self ;
    }
    return _chatBoxVC ;
}
- (ASChatMessageController *)messageVC {
    if (!_messageVC) {
        _messageVC = [[ASChatMessageController alloc]init];
        _messageVC.view.frame = CGRectMake(0, 0,self.view.width, self.view.height - 54 - self.view.safeAreaInsets.bottom);
        _messageVC.delegate = self ;
    }
    return _messageVC ;
}
@end
