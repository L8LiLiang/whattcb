//
//  ChooseImageView.m
//  tcb
//
//  Created by Jax on 15/11/28.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ChooseImageView.h"

@interface ChooseImageView ()

@property (nonatomic, strong) UIButton *coverButton;

@end

@implementation ChooseImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.backgroundColor = kRGB(255, 255, 255);
    self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    
//    CGFloat bottonHeight =  (self.frame.size.height - 5) / 3.0;
    CGFloat bottonHeight =  60;
    //  拍照
    UIButton *button0 = [[UIButton alloc] init];
    [self addSubview:button0];
    [button0 makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.height.equalTo(bottonHeight);
    }];
    button0.tag = 0;
    [button0 setTitle:@"拍照" forState:UIControlStateNormal];
    [button0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button0 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView0 = [[UIView alloc] init];
    [self addSubview:lineView0];
    [lineView0 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(1);
        make.top.equalTo(button0.bottom).offset(0);
    }];
    lineView0.backgroundColor = kRGB(234, 235, 235);
    
    UIButton *button1 = [[UIButton alloc] init];
    [self addSubview:button1];
    [button1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView0.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(bottonHeight);
    }];
    button1.tag = 1;
    [button1 setTitle:@"从手机相册选择" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView1 = [[UIView alloc] init];
    [self addSubview:lineView1];
    [lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(5);
        make.top.equalTo(button1.bottom).offset(0);
    }];
    lineView1.backgroundColor = kRGB(234, 235, 235);
    
    UIButton *button2 = [[UIButton alloc] init];
    [self addSubview:button2];
    [button2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(bottonHeight);
    }];
    [button2 setTitle:@"取消" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 2;

    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview == nil) {
        return;
    }
    
    if (!self.coverButton) {
        CGRect bound = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.coverButton = [[UIButton alloc] initWithFrame:bound];
        self.coverButton.alpha = 0.5f;
        [self.coverButton addTarget:self action:@selector(coverClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.coverButton.backgroundColor = kRGB(83, 83, 83);
        self.coverButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [kLastWindow addSubview:self.coverButton];
    }
    
    [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.7 options:0 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeFromSuperview {
    [self.coverButton removeFromSuperview];
    
    CGRect afterFrame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)show {
    self.frame = CGRectMake(0, SCREEN_HEIGHT - 186, SCREEN_WIDTH, 186);
    [kLastWindow addSubview:self];
}

- (void)buttonClicked:(UIButton *)sender {
    if (sender.tag == 0) {
        [self removeFromSuperview];
        if ([self.chooseImageViewDelegate respondsToSelector:@selector(takePictureButtonClicked:)]) {
            [self.chooseImageViewDelegate takePictureButtonClicked:sender];
        }
    } else if (sender.tag == 1) {
        [self removeFromSuperview];
        if ([self.chooseImageViewDelegate respondsToSelector:@selector(selectedImageButtonClicked:)]) {
            [self.chooseImageViewDelegate selectedImageButtonClicked:sender];
        }
    } else if (sender.tag == 2) {
        [self removeFromSuperview];
    }
}

- (void)coverClicked:(UIButton *)sender {
    [self removeFromSuperview];
}


@end
