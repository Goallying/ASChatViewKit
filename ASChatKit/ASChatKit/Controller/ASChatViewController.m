//
//  ASChatViewController.m
//  NewAS
//
//  Created by Lifee on 2019/5/15.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASChatViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+ASAddition.h"
#import "ASChatMessageController.h"
#import "ASChatBoxController.h"

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
}
- (void)appendMessage:(id<ASMessageProtocol>)message{
    [self.messageVC appendMessage:message];
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
    if ([self.delegate respondsToSelector:@selector(willSendText:)]) {
        [self.delegate willSendText:text];
    }
}
- (void)chatBox:(ASChatBoxController *)chatBox didFinishRecordVoice:(NSString *)filePath duration:(CGFloat)duration {
    if ([self.delegate respondsToSelector:@selector(willSendVoice:duration:)]) {
        [self.delegate willSendVoice:filePath duration:duration];
    }
}
- (void)chatBox:(ASChatBoxController *)chatBox didChangeHeight:(CGFloat)height {
    self.messageVC.view.height = self.view.height - height - self.view.safeAreaInsets.bottom ;
    self.chatBoxVC.view.top = self.messageVC.view.height ;
    self.chatBoxVC.view.height = self.messageVC.view.height ;
    [self.messageVC scrollToBottom];
}

- (void)openAlbum {
    if ([self.delegate respondsToSelector:@selector(willOpenAlbum)]) {
        [self.delegate willOpenAlbum];
    }else {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum ;
        picker.delegate = self ;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (void)openCamera {
    if ([self.delegate respondsToSelector:@selector(willOpenCamera)]) {
        [self.delegate willOpenCamera];
    }else{
        
        UIAlertController * sheet = [UIAlertController alertControllerWithTitle:@"来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera ;
        picker.delegate = self ;
        picker.allowsEditing = NO;

        UIAlertAction * album = [UIAlertAction actionWithTitle:@"拍摄照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        UIAlertAction * camera = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [sheet addAction:album];
        [sheet addAction:camera];
        [sheet addAction:cancel];
        [self presentViewController:sheet animated:YES completion:nil];

    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.movie"]) {
        NSURL * videoURL = info[UIImagePickerControllerMediaURL];
        
        AVURLAsset * videoAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        float videoDurationSeconds = CMTimeGetSeconds(videoAsset.duration);
        if ([self.delegate respondsToSelector:@selector(willSendVideo:duration:)]) {
            [self.delegate willSendVideo:videoURL.absoluteString duration:videoDurationSeconds];
        }
    }else if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"]){
        if ([self.delegate respondsToSelector:@selector(willSendImage:)]) {
            UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [self.delegate willSendImage:image];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}
- (void)didTapOnChatMessageController:(ASChatMessageController *)chatMessageController {
    [self.chatBoxVC resignFirstResponder];
    
}
- (void)didTapOnMessage:(id<ASMessageProtocol>)message {
    
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
