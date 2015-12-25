//
//  SelecteCostListView.m
//  tcb
//
//  Created by Jax on 15/11/28.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "SelecteCostListView.h"

@interface SelecteCostListView ()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *oKButton;
@property (nonatomic, strong) UIButton *coverButton;

@end

@implementation SelecteCostListView

- (instancetype)initWithTag:(NSInteger)tag {
    self = [super init];
    if (self) {
        self.tag = tag;
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.backgroundColor = kRGB(255, 255, 255);
    self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = kRGB(245, 245, 245);
    [self addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(40);
    }];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [topView addSubview:cancelButton];
    [cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(10);
        make.width.equalTo(80);
    }];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *oKButton = [[UIButton alloc] init];
    [topView addSubview:oKButton];
    [oKButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.right.equalTo(-10);
        make.width.equalTo(80);
    }];
    [oKButton setTitle:@"确认" forState:UIControlStateNormal];
    [oKButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [oKButton addTarget:self action:@selector(oKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    oKButton.tag = self.tag;
    if (self.tag == 1) {
//        oKButton.enabled = NO;
    }
    self.oKButton = oKButton;
    [self.oKButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    UIPickerView *pickView = [[UIPickerView alloc] init];
    [self addSubview:pickView];
    [pickView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(topView.bottom).offset(0);
    }];
    self.pickView = pickView;
    pickView.tag = self.tag;
    
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
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.7 options:0 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {

    }];
}

- (void)removeFromSuperview {
    [self.coverButton removeFromSuperview];
    self.coverButton = nil;
    CGRect afterFrame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)show {
    self.frame = CGRectMake(0, SCREEN_HEIGHT - 280, SCREEN_WIDTH, 280);
    [kLastWindow addSubview:self];
}

- (void)cancelButtonClicked:(UIButton *)sender {
    TCBLog(@"取消");
    [self removeFromSuperview];
}

- (void)oKButtonClicked:(UIButton *)sender {
    TCBLog(@"确认");
    self.pickView = nil;
    if ([self.selecteCostListViewDelegate respondsToSelector:@selector(selecteCostListViewOkButtonClicked:)]) {
        [self.selecteCostListViewDelegate selecteCostListViewOkButtonClicked:sender];
    }
    [self removeFromSuperview];
    
}

- (void)coverClicked:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
