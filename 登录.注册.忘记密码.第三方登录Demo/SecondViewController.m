//
//  SecondViewController.m
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/10.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import "SecondViewController.h"
#import "LoginViewController.h"
#import "SystemManager.h"
@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[SystemManager sharedInstance] curLoginState]== LoginStateOnline) {
        
        self.loginBtn.hidden=YES;
        
    }
    else{
        self.userNickName.hidden=YES;
    }
    
}
- (IBAction)loginAndRegist:(id)sender {
    UIStoryboard *str = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
    LoginViewController *login= [str instantiateInitialViewController];
    
    //[self.navigationController pushViewController:login animated:YES];
    
    [self presentViewController:login animated:YES completion:nil];
    
    
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
