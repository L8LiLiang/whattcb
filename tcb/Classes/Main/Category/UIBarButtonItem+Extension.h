

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)


/**
 *  返回barButtonItem(根据图片名字-自定义的一个Button作为customView)
 *
 *  @param imageName
 *  @param target
 *  @param action
 *
 *  @return
 */
+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

/**
 *  返回barButtonItem(根据图片名字-自定义的一个Button作为customView,title)
 *
 *  @param imageName
 *  @param target
 *  @param action
 *  @param title
 *
 *  @return 
 */
+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action title:(NSString *)title;


+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)color;








@end
