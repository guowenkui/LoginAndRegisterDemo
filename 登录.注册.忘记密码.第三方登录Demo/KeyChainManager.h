//
//  KeyChainManager.h
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/13.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainManager : NSObject

+(KeyChainManager*)sharedInstance;

-(void)saveAccount:(NSString *)account;
-(NSString *)loadAccount;
-(void)resetAccount;

-(void)savePassword:(NSString *)password;
-(NSString *)loadPassword;
-(void)resetPassword;

-(void)saveAccessToken:(NSString *)accessToken;
-(NSString *)loadAccessToken;
-(void)resetAccessToken;


@end
