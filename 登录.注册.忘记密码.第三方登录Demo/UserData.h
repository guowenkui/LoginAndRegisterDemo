//
//  UserData.h
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/14.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property(nonatomic,strong) NSString *account;
@property(nonatomic,strong) NSString *nicknime;
@property(nonatomic,strong) NSString *headImageUrl;
@property(nonatomic,strong) NSString *sex;
@property(nonatomic,strong) NSString *openId;
@property(nonatomic,strong) NSString *unionId;

@end
