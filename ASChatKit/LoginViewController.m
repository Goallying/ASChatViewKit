//
//  LoginViewController.m
//  ASChatKit
//
//  Created by Lifee on 2019/6/6.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "LoginViewController.h"
#import <JMessage/JMessage.h>
#import "ViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)login:(UIButton *)sender {
    [JMSGUser registerWithUsername:self.nameTF.text password:self.pswTF.text completionHandler:^(id resultObject, NSError *error) {
        [JMSGUser loginWithUsername:self.nameTF.text password:self.pswTF.text completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                ViewController * vc = [[ViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }];
}


@end
