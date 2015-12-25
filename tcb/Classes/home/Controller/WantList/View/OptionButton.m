//
//  OptionButton.m
//  iosapp
//
//  Created by ChanAetern on 12/17/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "OptionButton.h"


@interface OptionButton ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *image;

@end

@implementation OptionButton

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    if (self = [super init]) {
        _button = [UIImageView new];
        _button.backgroundColor = [UIColor whiteColor];
        
        _image = [UIImageView new];
        _image.image = [UIImage imageNamed:imageName];
        _image.translatesAutoresizingMaskIntoConstraints = NO;
        [_button addSubview:_image];
        
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_button];
        [self addSubview:_titleLabel];
        
        [self setLayout];
    }
    
    return self;
}

- (void)setLayout
{
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.bottom.equalTo(self.bottom).offset(-8);
    }];
    
    [_button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.bottom.equalTo(_titleLabel.top).offset(-15);
    }];
    
    [_image makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(50);
        make.width.equalTo(50);
        make.centerX.equalTo(self.centerX);
        make.bottom.equalTo(_button.bottom).offset(8);
    }];
}

@end
