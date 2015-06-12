//
//  SystemManager.m
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/6.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import "SystemManager.h"
#import "AFHTTPRequestOperationManager.h"
@interface SystemManager()

@property (nonatomic,assign) LoginState loginState;//登录状态

@end


@implementation SystemManager

+(SystemManager *)sharedInstance
{
    static SystemManager *systemManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        systemManager = [[super allocWithZone:NULL] init];
    });
    return systemManager;
}


-(void)systemStatusInit
{
    BOOL hasLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"];
    if (hasLogin) {
        self.loginState = LoginStateOnline;
    }
    else{
        self.loginState = LoginStateOffline;
    }
}

//获取当前登录状态
-(LoginState)curLoginState
{
    return self.loginState;
}


-(BOOL)loginAccount:(NSString *)account withPassword:(NSString *)password
{
    [self requestForLoginWithAccount:account andPassword:password];
    
    self.loginState = LoginStateLogining;
    
    return YES;
}

-(void)requestForLoginWithAccount:(NSString *)account andPassword:(NSString *)password
{
    
    NSData *pushToken = [[SystemManager sharedInstance] loadAPNSDeviceToken];
    NSString *pushTokenStr = @"";
    NSLog(@"pushTokenStr==%@",pushTokenStr);
    NSDictionary *parameters = @{@"grant_type":@"password",
                                 @"username":account,
                                 @"password":password,
                                 @"devtype":@(1),
                                 @"pushtoken":pushTokenStr
                                 };
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:@"https://public.fdekyy.com.cn/oauth20/token"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject){
              
              if (((NSDictionary *)responseObject)[@"error"] ==nil) {
                  NSLog(@"登陆成功");
                  NSLog(@"responseObject==%@",responseObject);
                  
                  self.loginState = LoginStateOnline;
                  
                  //记住登录状态
                  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLogin"];
                  
              }
              else{
                  NSString *errorMessage = ((NSDictionary *)responseObject)[@"error"];
                  NSLog(@"登录失败,错误:%@",errorMessage);
              }
        
    }
          failure:^(AFHTTPRequestOperation *operation,NSError *error){
 
              UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                              message:@"ll"
                                                             delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
              [alter show];
    }];
    
   
    
    
}

-(NSData *)loadAPNSDeviceToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"APNSDevToken"];
}


@end
