//
//  LoginViewController.m
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/6.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import "LoginViewController.h"
#import "SystemManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "UMSocialAccountManager.h"
#import "UMSocialSnsPlatformManager.h"
#import "MainTabBarViewController.h"
#import "KeyChainManager.h"
#import "MainTabBarViewController.h"
@interface LoginViewController ()



@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textPhone.text = [[KeyChainManager sharedInstance] loadAccount];
    NSLog(@"---%@",[[KeyChainManager sharedInstance] loadAccount]);
}




- (IBAction)LoginButtonPressed:(id)sender {
    
    [self loginWithType:LoginTypeAccount];
}


-(void)loginWithType:(LoginTypeEnum)type
{
    if (type == LoginTypeAccount) {
        //检查参数
        if([self.textPhone.text isEqualToString:@""]||[self.textPassword.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"用户名和密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
            
        }
        
    };
    
    
    //记住用户名
    [[KeyChainManager sharedInstance] saveAccount:self.textPhone.text];
    
    BOOL ret = [[SystemManager sharedInstance] loginAccount:self.textPhone.text withPassword:self.textPassword.text];
    if (ret ){
        UIStoryboard *str =[ UIStoryboard storyboardWithName:@"AppMain" bundle:nil];
        
        MainTabBarViewController *app = [str instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
        
        self.view.window.rootViewController = app;
        NSLog(@"00000");
    }


    if (!ret) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求错误" message:@"请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
     }

}

//微信登录
- (IBAction)weixinLogin:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }
        
    });
    
    //得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
    }];
    
    
}
//qq登录
- (IBAction)qqLogin:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
    
    
}

//新浪登录
- (IBAction)sinaLogin:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
    
   // 在授权完成后调用获取用户信息的方法
    //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
    }];
    
    
    //获取好友列表调用下面的方法,由于新浪官方限制，获取好友列表只能获取到30%好友
    [[UMSocialDataService defaultDataService] requestSnsFriends:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsFriends is %@",response.data);
    }];
    
    //删除授权调用下面的方法
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
    }];
}

- (IBAction)cancel:(id)sender {
    
    if ([self isRootView]) {
        UIStoryboard *str =[ UIStoryboard storyboardWithName:@"AppMain" bundle:nil];
        MainTabBarViewController *main = [str instantiateInitialViewController];
        
        self.view.window.rootViewController = main;
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    
}

-(BOOL)isRootView
{
    if (self.navigationController == self.view.window.rootViewController) {
        return YES;
    }
    else{
        return NO;
    }
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
