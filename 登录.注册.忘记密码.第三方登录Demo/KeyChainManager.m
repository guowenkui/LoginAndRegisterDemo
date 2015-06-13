//
//  KeyChainManager.m
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/13.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import "KeyChainManager.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
@interface KeyChainManager()

@property (nonatomic,strong) KeychainItemWrapper * passwordWrapper;

@end

@implementation KeyChainManager


+(KeyChainManager *)sharedInstance
{
    static KeyChainManager *keyChainManager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        keyChainManager =  [[super allocWithZone:NULL] init];
    });
    return keyChainManager;
}

-(id)init
{
    self = [super init];
    if (self !=nil) {
        /** 初始化一个保存用户帐号的KeychainItemWrapper对象   必须的*/
        self.passwordWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"pass" accessGroup:nil serviceName:@"sev"];
    }
    return self;
}

-(void)saveAccount:(NSString *)account
{
    NSString * lastAccount = [self loadAccount];
    if (lastAccount == nil) {
        [self.passwordWrapper setObject:account forKey:(__bridge id)(kSecAttrAccount)];
    }
    else if (![lastAccount isEqualToString:account]){
        [self resetAccount];
        [self.passwordWrapper setObject:account forKey:(__bridge id)(kSecAttrAccount)];
    }
}

-(NSString * )loadAccount
{
    return [self.passwordWrapper objectForKey:(__bridge id)(kSecAttrAccount)];
}

-(void)resetAccount
{
    [self.passwordWrapper resetKeychainItem];
}


-(void)savePassword:(NSString *)password
{
    [self.passwordWrapper setObject:password forKey:(__bridge id)(kSecValueData)];
}

-(NSString *)loadPassword
{
    return [self.passwordWrapper objectForKey:(__bridge id)(kSecValueData)];
}

-(void)resetPassword
{
    [self.passwordWrapper resetKeychainItem];
}

@end
