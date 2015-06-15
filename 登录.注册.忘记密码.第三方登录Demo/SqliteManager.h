//
//  SqliteManager.h
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/13.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserData.h"
@interface SqliteManager : NSObject

//用单例的方式来操作
+(SqliteManager *)shareManager;

//添加的方法
-(void)addUser:(UserData *)userData;

//查询的方法
-(UserData *)searchAllUsers;

//修改的方法
//userData修改后的信息
-(void)updateUser:(UserData *)userData withUserId:(int)userId;

//删除一条记录
-(void)deleteUserWithId:(int)userID;

@end
