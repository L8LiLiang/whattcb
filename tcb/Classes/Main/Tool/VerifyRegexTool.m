//
//  VerifyRegexTool.m
//  DooLii
//  利用谓词（NSPredicate）创建正则表达式（最简单的判断方法）

#import "VerifyRegexTool.h"

@implementation VerifyRegexTool

// 手机号码验证
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    // 编写正则表达式：手机号以13，14，15，17，18开头，八个 \d 数字字符，手机号码正则表达式(服务器所用的正则表达式:^1[34578]\\d{9}$) 最全的正则：^(0|86|17951)?(13[0-9]|14[57])[0-9]{8}|15[012356789]|17[678]|18[0-9]$
    NSString *phoneRegex = @"^1[34578]\\d{9}$";
    
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [predicate evaluateWithObject:mobile];
}

// 短信验证码
+ (BOOL)isValidateVerifyCode:(NSString *)smsCode
{
    // 6位纯数字的格式
    NSString *codeRegex = @"^\\d{6}$";
    
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    
    return [predicate evaluateWithObject:smsCode];
}

// 身份证号
+ (BOOL)isValidateIdCard:(NSString *)idCard
{
    BOOL flag;
    if (idCard.length <= 0) { // 身份证号码不为空  通用15和18位均可：@"^(\\d{14}|\\d{17})(\\d|[xX])$";
        flag = NO;
        return flag;
    }
    
    NSString *IdRegex = nil;
    if (idCard.length == 15) { // 一代公民身份证15位
        IdRegex = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
    } else if (idCard.length == 18) { // 二代公民身份证18位
        IdRegex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])(\\d{3})(\\d|X){1}$";
    }
    
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IdRegex];
    
    return [predicate evaluateWithObject:idCard];
}

// 昵称
+ (BOOL)isValidateNickname:(NSString *)nickname
{
    // 昵称只能由中文、字母或数字组成
    NSString *nicknameRegex = @"^[A-Za-z0-9\u4e00-\u9fa5]{3,20}$";
    
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    
    return [predicate evaluateWithObject:nickname];
}

// 密码
+ (BOOL)isValidatePassword:(NSString *)password
{
    // 密码长度应为6-16个字符,密码必须包含字母和数字
    NSString *passwordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}";
    
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    
    return [predicate evaluateWithObject:password];
}

// 实名认证(汉字)
+ (BOOL)isValidateRealName:(NSString *)realName
{
    // 昵称只能由中文、字母或数字组成\u4e00-\u9fa5
    NSString *realNameRegex = @"^[\u4E00-\u9FA5]{2,4}$";
    
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",realNameRegex];
    
    return [predicate evaluateWithObject:realName];
}

+ (BOOL)isEmptyString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }

    return NO;
}

/**
 *  邮箱正则表达式
 */
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *  银行卡号判断
 */
+ (BOOL)checkCardNo:(NSString *)cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

@end
