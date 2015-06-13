//
//  ThirdViewController.m
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/10.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import "ThirdViewController.h"
#import "SystemManager.h"
#import "LoginViewController.h"
@interface ThirdViewController ()<UIAlertViewDelegate>

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutOkEnventHandler) name:@"logoutOk" object:nil];
}

- (IBAction)logoutBtn:(id)sender {
    
    if ([[SystemManager sharedInstance] curLoginState]== LoginStateOnline) {
        UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"注销"
                                                        message:@"注销后可能会无法获取最新的通知消息,确定要注销吗?"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"注销",nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未能登录,不能取消"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if ([alertView.title isEqualToString:@"注销"]) {
        if (buttonIndex ==1) {
            [[SystemManager sharedInstance] logout ];
        }
    }
    
}

-(void)logoutOkEnventHandler
{
    NSLog(@"lllllll");
    
    UIStoryboard *str = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
    UINavigationController *login = [str instantiateInitialViewController];
    
    self.view.window.rootViewController = login;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
