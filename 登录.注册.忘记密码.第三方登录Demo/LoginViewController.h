//
//  LoginViewController.h
//  登录.注册.忘记密码.第三方登录Demo
//
//  Created by 郭文魁 on 15/6/6.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, LoginTypeEnum) {
    LoginTypeUnknown,
    LoginTypeAccount,
    LoginTypeWeixin
};

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@end
