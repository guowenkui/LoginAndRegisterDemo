//
//  SqliteManager.m
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/13.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import "SqliteManager.h"
#import "FMDatabase.h"

@implementation SqliteManager
{
    //数据库对象
    FMDatabase *_database;
}

+(SqliteManager *)shareManager
{
    static SqliteManager *manager =nil;
    @synchronized(self)
    {
        if (nil == manager) {
            manager = [[SqliteManager alloc] init];
        }
    }
    return manager;
    
}

-(instancetype)init
{
    self =[super init];
    if (self) {
        [self createDataBase];
    }
    return self;
    
}

-(void)createDataBase
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/user.db"];
    NSLog(@"%@",path);
    _database = [[FMDatabase alloc] initWithPath:path];
    
    BOOL flag = [_database open];
    if (flag == NO) {
        NSLog(@"打开失败");
    }else{
        //建表语句
        NSString *createSQL = @"create table userInfoTable(Account text primary key,Nickname text,FaceUrl text,Sex integer,OpenId text,UnionId text)";
        
        //执行建表语句
        BOOL result = [_database executeUpdate:createSQL];
        if (result) {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"_database.lastErrorMessage==%@",_database.lastErrorMessage);
        }
    }
}

-(void)addUser:(UserData *)userData
{
    NSString *sql = @"insert into userInfoTable (Account,FaceUrl,Sex,NickName) values (?,?,?,?)";
    
    BOOL result = [_database executeUpdate:sql,userData.account,userData.headImageUrl,userData.sex,userData.nicknime];
    if (result ==NO) {
        NSLog(@"%@",_database.lastErrorMessage);
    }
}

-(UserData *)searchAllUsers
{
    NSString *sql = @"select * from userInfoTable";
    
    FMResultSet *rs = [_database executeQuery:sql];
    UserData *data = [[UserData alloc] init];
    while ([rs next]) {
        
        data.nicknime = [rs stringForColumn:@"Nickname"];
        //data.
    }
    return data;
}

@end
