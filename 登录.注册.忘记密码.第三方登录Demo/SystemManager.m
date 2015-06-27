//
//  SystemManager.m
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/6.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import "SystemManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "SqliteManager.h"
#import "KeyChainManager.h"
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
                  
                  //保存令牌
                  [[KeyChainManager sharedInstance] saveAccessToken:responseObject[@"access_token"]];
                  
                  self.loginState = LoginStateOnline;
                  
                  //记住登录状态
                  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLogin"];
                  
                  //获取用户信息
                  [self requestForUserInfo];
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

//登录成功后获取用户信息
-(void)requestForUserInfo
{
//    //模拟获取信息后放入数据库
//    UserData*data = [[UserData alloc] init];
//    
//    data.nicknime = @"郭文魁";
//    
//    [[SqliteManager shareManager] addUser:data];
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //添加请求头 否者解析不出来数据
    NSString *access_token = [[KeyChainManager sharedInstance] loadAccessToken];
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", access_token];
    
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];

    
    [manager GET:@"https://public.fdekyy.com.cn/api/app/Member/GetUserInfo"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             NSInteger messageType= [((NSDictionary *)responseObject)[@"MessageType"] integerValue];
             if (messageType ==0) {
                 NSLog(@"获取用户信息成功");
                 [self getUserInfoOk:responseObject[@"Result"]];
                 
                 
                 
             }
             else
             {
                 NSString *errorMessage = ((NSDictionary *)responseObject)[@"ErrorMessage"];
                 NSLog(@"获取用户信息失败,错误:%@",errorMessage);
             }
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             // 请求失败
             NSString *errorMessage = [error localizedDescription];
             NSLog(@"获取用户信息哦，错误：%@", errorMessage);
            // [self getUserInfoFailedWithError:errorMessage];
        
    }];
}

-(void)getUserInfoOk:(NSDictionary *)infoDic
{
    NSLog(@"%@",infoDic);
    
    UserData *data = [[UserData alloc] init];
    
    data.nicknime =infoDic[@"NickName"];
    [[SqliteManager shareManager] addUser:data];
    
}


-(BOOL)logout
{
    if (self.loginState == LoginStateLogining || self.loginState == LoginStateOnline) {
        self.loginState = LoginStateLogouting;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasLogin"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutOk" object:nil userInfo:nil];
    
    return YES;
}

-(NSData *)loadAPNSDeviceToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"APNSDevToken"];
}


@end
