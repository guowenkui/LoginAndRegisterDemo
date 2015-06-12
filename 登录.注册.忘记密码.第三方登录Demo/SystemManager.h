//
//  SystemManager.h
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/6.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LoginStateOffline,    //离线
    LoginStateLogouting,  //注销中
    LoginStateOnline,     //在线
    LoginStateLogining    //登录中
}LoginState;

@interface SystemManager : NSObject

+(SystemManager *) sharedInstance;


//初始化系统状态
-(void)systemStatusInit;



//获取当前登录状态
-(LoginState)curLoginState;


/**
 *  用户名密码登录
 */

-(BOOL)loginAccount:(NSString *)account withPassword:(NSString *)password;

@end
