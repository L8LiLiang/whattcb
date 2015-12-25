
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "MacroDefine.h"

@implementation UIBarButtonItem (Extension)


+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action{
    //初始化一个自定义view(UIButton)
    UIButton *button = [[UIButton alloc] init];
    //设置不同状态显示的图片
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.size = button.currentImage.size;
    //添加点击事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action title:(NSString *)title{
    //初始化一个自定义view(UIButton)
    UIButton *button = [[UIButton alloc] init];
    
    //设置不同状态显示的图片
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    //设置button文字颜色
    UIColor *color = kRGB(68,68,68);
    [button setTitleColor:color forState:UIControlStateNormal];
    
    //设置button的文字
    [button setTitle:title forState:UIControlStateNormal];
     button.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [button sizeToFit];
    //添加点击事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)color{
    //初始化一个自定义view(UIButton)
    UIButton *button = [[UIButton alloc] init];
    
    //设置不同状态显示的图片
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    //设置button文字颜色
    [button setTitleColor:color forState:UIControlStateNormal];
    
    //设置button的文字
    [button setTitle:title forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [button sizeToFit];
    //添加点击事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}









@end
