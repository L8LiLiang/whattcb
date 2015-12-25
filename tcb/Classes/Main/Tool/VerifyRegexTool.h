//
//  VerifyRegexTool.h
//  正则表达式工具类

#import <Foundation/Foundation.h>

@interface VerifyRegexTool : NSObject

/**
 *  手机号码正则表达式验证
 */
+ (BOOL)isValidateMobile:(NSString *)mobile;

/**
 *  短信验证码正则表达式验证
 */
+ (BOOL)isValidateVerifyCode:(NSString *)smsCode;

/**
 *  身份证号码正则表达式验证
 */
+ (BOOL)isValidateIdCard: (NSString *)idCard;

/**
 *  昵称正则表达式验证
 */
+ (BOOL)isValidateNickname:(NSString *)nickname;

/**
 *  密码正则表达式验证
 */
+ (BOOL)isValidatePassword:(NSString *)passWord;

/**
 *  实名认证(只能输入汉字)
 */
+ (BOOL)isValidateRealName:(NSString *)realName;

/**
 *  判断字符串是否为空
 */
+ (BOOL)isEmptyString:(NSString *)string;

/**
 *  邮箱正则表达式
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 *  银行卡号判断
 */
+ (BOOL)checkCardNo:(NSString *)cardNo;
@end
