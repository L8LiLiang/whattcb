//
//  SelecteCostListView.h
//  tcb
//
//  Created by Jax on 15/11/28.
//  Copyright © 2015年 Jax. All rights reserved.

//  选择费目视图

#import <UIKit/UIKit.h>

@protocol SelecteCostListViewDelegate <NSObject>

@optional
- (void)selecteCostListViewOkButtonClicked:(UIButton *)sender;

@end

@interface SelecteCostListView : UIView

@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) UIButton *okButton;

@property (nonatomic, weak) id<SelecteCostListViewDelegate> selecteCostListViewDelegate;

- (instancetype)initWithTag:(NSInteger)tag;
- (void)show;

@end
