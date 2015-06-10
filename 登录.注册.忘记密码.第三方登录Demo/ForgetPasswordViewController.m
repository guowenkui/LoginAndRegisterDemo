//
//  ForgetPasswordViewController.m
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/6.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "AFHTTPRequestOperationManager.h"
@interface ForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword2;


@property (nonatomic,strong) NSString *genedVerifyCode;//保存本地生成的验证码
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)smsCodeBtnPressed:(id)sender {
    
    NSString *str = [NSString stringWithFormat:@"我们将发送验证码短信到这个号码:\n%@ %@",@"+86",self.tfAccount.text];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认手机号码"
                                                    message:str
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"好", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1== buttonIndex) {
        //本地生成验证码
        self.genedVerifyCode = [self getVerifyCode];
        
        if (self.genedVerifyCode != nil && ![self.genedVerifyCode isEqualToString:@""]) {
            //向服务器请求验证码
            [self requestForSmsCode];
        }
    }
}

//产生随机六位验证码
-(NSString *)getVerifyCode
{
    NSInteger code = arc4random()%999999+1;
    NSString *verifyStr = [NSString stringWithFormat:@"%06ld",(long)code];
    
    NSLog(@"验证码:%@",verifyStr);
    
    return verifyStr;
}

//获取短信验证码
-(void)requestForSmsCode
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *curDate = [NSDate date];
    
    NSString *dateStr = [dateFormatter stringFromDate:curDate];
    
    NSDictionary *parameters = @{@"Phone":@"15215015572",
                                 @"Type":@"0",
                                 @"Content":self.genedVerifyCode,
                                 @"Code":self.genedVerifyCode,
                                 @"CreateDate":dateStr
                                 };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://public.fdekyy.com.cn/api/app/sms/send"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject){
              NSLog(@"获取验证码请求成功.");
              
              NSDictionary *responseDict = responseObject;
              
              NSLog(@"responseDict==%@",responseDict);
              NSLog(@"===%@",responseDict[@"LogMessage"]);
              NSInteger responseCode = [responseDict[@"MessageType"] integerValue];
              
              if (responseCode==0) {
                  
              }
              else{
                  if(responseCode ==-1){
                      NSString *errorMsg = responseDict[@"ErrorMessage"];
                      NSLog(@"--%@",errorMsg);
                  }
                  else{
                      NSLog(@"无法获取验证码");
                  }
              }
              
              
              
          }
          failure:^(AFHTTPRequestOperation *operation,NSError *error){
              
              NSString *errorMessage = [error localizedDescription];
              
              //NSString *info = [NSString stringWithFormat:@"%@",errorMessage];
              
              NSLog(@"获取验证码请求失败,错误:%@(%ld)",errorMessage,(long)error.code);
              
          }];
    
    
}

- (IBAction)requestForResetPassword:(id)sender {
    
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"phone":self.tfAccount.text,
                                 @"password":self.tfPassword.text,
                                 @"verifyCode":self.tfCode.text,
                                 @"devtype":@(1),
                                 @"pushtoken":@"",
                                 @"type":@(3)
                                 };
    [manager POST:@"https://public.fdekyy.com.cn/api/app/Member/RegisterUser"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject){
              
              NSDictionary *responseDict = responseObject;
              NSInteger responseCode = [responseDict[@"MessageType"] integerValue];
              
              if (responseCode ==0) {
                  NSLog(@"密码已重置");
                  
              }
              else{
                  NSString *errorMessage = responseDict[@"ErrorMessage"];
                  if (errorMessage==nil||[errorMessage isEqualToString:@""]) {
                      NSLog(@"重置密码失败");
                  }
                  else{
                      NSLog(@"重置密码失败,错误:%@",errorMessage);
                  }
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation,NSError *error){
              NSString *errorMessage = error.localizedDescription;
              NSLog(@"注册请求发送失败,错误:%@(%ld)",errorMessage,(long)error.code);
              
          }];
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
