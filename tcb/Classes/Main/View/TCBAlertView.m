//
//  TCBAlertView.m
//  tcb
//
//  Created by Jax on 15/11/12.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "TCBAlertView.h"
#import "UIImage+JAX.h"

#define AlertWidth  (iPhone6plus ? 280.0f : 240.0f)
#define AlertHeight (iPhone6plus ? 150.0f : 135.0f)
#define ButtonHeight 40
#define TCBTopMagin  10
#define TCBMargin    15

@interface TCBAlertView () {
    BOOL _leftLeave;
}

@property (nonatomic, strong) UILabel *alertTitle;
@property (nonatomic, strong) UILabel *alertContent;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *coverBtn;

@end

@implementation TCBAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |                                            UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                  contentText:(NSString *)content
              leftButtonTitle:(NSString *)leftTitle
             rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
        //  添加标题
        _alertTitle = [[UILabel alloc] init];
        [self addSubview:_alertTitle];
        _alertTitle.text = title;
        _alertTitle.textColor = kRGB(56, 64, 71);
        _alertTitle.textAlignment = NSTextAlignmentCenter;
        _alertTitle.font = [UIFont boldSystemFontOfSize:18.0f];
        [_alertTitle makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(10);
            make.centerX.equalTo(self.centerX);
        }];
        
        //  添加提示内容
        _alertContent = [[UILabel alloc] init];
        [self addSubview:_alertContent];
        _alertContent.text = content;
        _alertContent.textAlignment = NSTextAlignmentCenter;
        _alertContent.numberOfLines = 2;
        _alertContent.textColor = kRGB(127, 127, 127);
        [_alertContent makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(5);
            make.right.equalTo(-5);
            make.top.equalTo(_alertTitle.bottom).offset(12);
        }];
        
        if (!leftTitle) {
            // 只有右按钮时
            _rightBtn = [UIButton alloc].init;
            [self addSubview:_rightBtn];
            [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(ButtonHeight);
                make.bottom.mas_equalTo(-TCBTopMagin);
                make.left.mas_equalTo(TCBTopMagin * 4);
                make.right.mas_equalTo(-TCBTopMagin * 4);
            }];

        } else if (!rigthTitle) {
            // 只有左按钮时
            _leftBtn = [UIButton alloc].init;
            [self addSubview:_leftBtn];
            [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(ButtonHeight);
                make.bottom.mas_equalTo(-TCBTopMagin);
                make.left.mas_equalTo(TCBTopMagin * 4);
                make.right.mas_equalTo(-TCBTopMagin * 4);
            }];
        } else {
            // 两个按钮都在时
            _leftBtn = [UIButton alloc].init;
            [self addSubview:_leftBtn];
            [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-TCBTopMagin);
                make.left.mas_equalTo(10);
                make.height.mas_equalTo(ButtonHeight);
                make.right.equalTo(self.mas_centerX).offset(-3);
            }];
            
            _rightBtn = [UIButton alloc].init;
            [self addSubview:_rightBtn];
            [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.height.mas_equalTo(ButtonHeight);
                make.bottom.mas_equalTo(-TCBTopMagin);
                make.left.equalTo(self.mas_centerX).offset(3);
            }];
        }
        
        _leftBtn.layer.cornerRadius = _rightBtn.layer.cornerRadius = 3.0;
        _leftBtn.layer.masksToBounds = _rightBtn.layer.masksToBounds = YES;
        
        [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setBackgroundImage:[UIImage imageWithColor:kRGB(237, 100, 83)] forState:UIControlStateNormal];
        
        [_rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setBackgroundImage:[UIImage imageWithColor:kRGB(237, 100, 83)] forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:[UIImage imageWithColor:kRGB(1, 186, 243)] forState:UIControlStateNormal];


        
    }
    return self;
}

- (void)coverClicked
{
//    [self removeFromSuperview];
}

- (void)leftBtnClicked {
    _leftLeave = YES;
    [self removeFromSuperview];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked {
    _leftLeave = NO;
    [self removeFromSuperview];
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (void)show {
    self.frame = CGRectMake((SCREEN_WIDTH - AlertWidth) * 0.5, - AlertHeight - TCBMargin, AlertWidth, AlertHeight);
    [kLastWindow addSubview:self];
}

- (void)removeFromSuperview {
    [self.coverBtn removeFromSuperview];
    self.coverBtn = nil;
    CGRect afterFrame = CGRectMake((SCREEN_WIDTH - AlertWidth) * 0.5, SCREEN_HEIGHT, AlertWidth, AlertHeight);
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        if (_leftLeave) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        } else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) {
        return;
    }
    
    if (!self.coverBtn) {
        self.coverBtn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.coverBtn.alpha = 0.6f;
        [self.coverBtn addTarget:self action:@selector(coverClicked) forControlEvents:UIControlEventTouchUpInside];
        self.coverBtn.backgroundColor = [UIColor blackColor];
        self.coverBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    [kLastWindow addSubview:self.coverBtn];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((SCREEN_WIDTH - AlertWidth) * 0.5, (SCREEN_HEIGHT - AlertHeight) * 0.5, AlertWidth, AlertHeight);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:NULL];
    
    [super willMoveToSuperview:newSuperview];
}


@end
