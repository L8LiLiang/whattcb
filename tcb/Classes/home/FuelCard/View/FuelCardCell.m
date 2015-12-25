//
//  FuelCardCell.m
//  tcb
//
//  Created by Jax on 15/12/14.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "FuelCardCell.h"
#import "CircleView.h"
#import "ImageRightButton.h"

@interface FuelCardCell()

@property (nonatomic, strong) UILabel *carNum;
@property (nonatomic, strong) UILabel *fuelCard;
@property (nonatomic, strong) UILabel *FuelCardNo;
@property (nonatomic, strong) UILabel *team;
@property (nonatomic, strong) UILabel *remainingFee;
@property (nonatomic, strong) UILabel *forSave;

@end

@implementation FuelCardCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FuelCardCell";
    FuelCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FuelCardCell alloc] init];
    }
    return cell;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setGasCardInfo:(GasCardInfo *)gasCardInfo {
    _gasCardInfo = gasCardInfo;
    self.carNum.text = gasCardInfo.CarNo;
    self.fuelCard.text = gasCardInfo.FuelCard;
    self.FuelCardNo.text = gasCardInfo.FuelCardNo;
    self.team.text = gasCardInfo.Team;
    self.remainingFee.text = gasCardInfo.InvalidMoney;
    self.forSave.text = [NSString stringWithFormat:@"带圈存 %0.2f", gasCardInfo.Balance];

}

- (void)setUpViews {
    UILabel *carNum = [[UILabel alloc] init];
    [self.contentView addSubview:carNum];
    [carNum makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        if (iPhone4 || iPhone5) {
            make.height.equalTo(40);
        } else if (iPhone6) {
            make.height.equalTo(50);
        } else if (iPhone6plus) {
            make.height.equalTo(60);
        }
        
    }];
    carNum.textAlignment = NSTextAlignmentCenter;
    carNum.backgroundColor = kRGB(83, 151, 88);
    carNum.textColor = [UIColor whiteColor];
    if (iPhone4) {
        carNum.font = [UIFont systemFontOfSize:14];
    } else if (iPhone5) {
        carNum.font = [UIFont systemFontOfSize:15];
    } else if (iPhone6) {
        carNum.font = [UIFont systemFontOfSize:17];
    } else if (iPhone6plus) {
        carNum.font = [UIFont systemFontOfSize:22];
    }
    
    UIView *bottomView = [[UIView alloc] init];
    [self.contentView addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carNum.bottom).offset(0);
        make.left.right.equalTo(0);
        make.bottom.equalTo(self.contentView.bottom).offset(0);
    }];
    bottomView.backgroundColor = kRGB(111, 182, 43);
    
    UILabel *fuelCard = [[UILabel alloc] init];
    [bottomView addSubview:fuelCard];
    [fuelCard makeConstraints:^(MASConstraintMaker *make) {
        if (iPhone4) {
            make.top.equalTo(5);
            make.height.equalTo(25);
        } else if (iPhone5) {
            make.top.equalTo(5);
            make.height.equalTo(35);
        } else if (iPhone6) {
            make.top.equalTo(10);
            make.height.equalTo(40);
        } else if (iPhone6plus) {
            make.top.equalTo(10);
            make.height.equalTo(50);
        }
        make.left.right.equalTo(0);
        
    }];
    fuelCard.textColor = [UIColor whiteColor];
    fuelCard.textAlignment = NSTextAlignmentCenter;
    if (iPhone4 || iPhone5) {
        fuelCard.font = [UIFont systemFontOfSize:17];
    } else if (iPhone6) {
        fuelCard.font = [UIFont systemFontOfSize:20];
    } else if (iPhone6plus) {
        fuelCard.font = [UIFont systemFontOfSize:25];
    }
    
    UILabel *FuelCardNo = [[UILabel alloc] init];
    [bottomView addSubview:FuelCardNo];
    [FuelCardNo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fuelCard.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(30);
    }];
    FuelCardNo.textAlignment = NSTextAlignmentCenter;
    FuelCardNo.textColor = [UIColor whiteColor];
    if (iPhone4) {
        FuelCardNo.font = [UIFont systemFontOfSize:13];
    } else if (iPhone5) {
        FuelCardNo.font = [UIFont systemFontOfSize:14];
    } else if (iPhone6) {
        FuelCardNo.font = [UIFont systemFontOfSize:15];
    } else if (iPhone6plus) {
        FuelCardNo.font = [UIFont systemFontOfSize:17];
    }
    
    UILabel *team = [[UILabel alloc] init];
    [bottomView addSubview:team];
    [team makeConstraints:^(MASConstraintMaker *make) {
        if (iPhone4) {
            make.top.equalTo(FuelCardNo.bottom).offset(0);
            make.height.equalTo(25);
        } else if (iPhone5) {
            make.top.equalTo(FuelCardNo.bottom).offset(0);
            make.height.equalTo(35);
        } else if (iPhone6) {
            make.top.equalTo(FuelCardNo.bottom).offset(10);
            make.height.equalTo(40);
        } else if (iPhone6plus) {
            make.top.equalTo(FuelCardNo.bottom).offset(10);
            make.height.equalTo(40);
        }
     
        make.left.right.equalTo(0);
        
    }];
    team.textAlignment = NSTextAlignmentCenter;
    team.textColor = [UIColor whiteColor];
    if (iPhone4 || iPhone5 || iPhone6) {
        team.font = [UIFont systemFontOfSize:17];
    } else if (iPhone6plus) {
        team.font = [UIFont systemFontOfSize:22];
    }
    
    CircleView *circleView = [[CircleView alloc] init];
    [bottomView addSubview:circleView];
    [circleView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(0);
        if (iPhone4) {
            make.height.equalTo(SCREEN_WIDTH - 145);
            make.top.equalTo(team.bottom).offset(0);
        } else if (iPhone5) {
            make.height.equalTo(SCREEN_WIDTH - 100);
            make.top.equalTo(team.bottom).offset(10);
        } else if (iPhone6) {
            make.height.equalTo(SCREEN_WIDTH - 90);
            make.top.equalTo(team.bottom).offset(7);
        } else if (iPhone6plus) {
            make.height.equalTo(SCREEN_WIDTH - 85);
            make.top.equalTo(team.bottom).offset(8);
        }
        
    }];
    
    UILabel *remaining = [[UILabel alloc] init];
    [circleView addSubview:remaining];
    [remaining makeConstraints:^(MASConstraintMaker *make) {
        if (iPhone4) {
            make.top.equalTo(25);
            make.height.equalTo(20);
        } else if (iPhone5) {
            make.top.equalTo(25);
            make.height.equalTo(35);
        } else if (iPhone6) {
            make.top.equalTo(35);
            make.height.equalTo(45);
        } else if (iPhone6plus) {
            make.top.equalTo(40);
            make.height.equalTo(50);
        }
        
        make.left.right.equalTo(0);
        
    }];
    remaining.text = @"剩余金额(元)";
    remaining.textAlignment = NSTextAlignmentCenter;
    remaining.textColor = [UIColor whiteColor];
    if (iPhone4) {
        remaining.font = [UIFont systemFontOfSize:14];
    } else if (iPhone5) {
        remaining.font = [UIFont systemFontOfSize:18];
    } else if (iPhone6) {
        remaining.font = [UIFont systemFontOfSize:20];
    } else if (iPhone6plus) {
        remaining.font = [UIFont systemFontOfSize:25];
    }
    
    UILabel *remainingFee = [[UILabel alloc] init];
    [circleView addSubview:remainingFee];
    [remainingFee makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remaining.bottom).offset(0);
        make.left.right.equalTo(0);
        if (iPhone4) {
            make.height.equalTo(55);
        } else if (iPhone5) {
            make.height.equalTo(60);
        } else if (iPhone6) {
            make.height.equalTo(75);
        } else if (iPhone6plus) {
            make.height.equalTo(85);
        }
    }];
    remainingFee.textAlignment = NSTextAlignmentCenter;
    remainingFee.textColor = [UIColor whiteColor];
    if (iPhone4) {
        remainingFee.font = [UIFont systemFontOfSize:40];
    } else if (iPhone5) {
        remainingFee.font = [UIFont systemFontOfSize:45];
    } else if (iPhone6) {
        remainingFee.font = [UIFont systemFontOfSize:55];
    } else if (iPhone6plus) {
        remainingFee.font = [UIFont systemFontOfSize:60];
    }
    self.remainingFee = remainingFee;
    
    UILabel *forSave = [[UILabel alloc] init];
    [circleView addSubview:forSave];
    [forSave makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remainingFee.bottom).offset(0);
        make.left.right.equalTo(0);
        if (iPhone4) {
            make.height.equalTo(25);
        } else if (iPhone5) {
            make.height.equalTo(35);
        } else if (iPhone6) {
            make.height.equalTo(48);
        } else if (iPhone6plus) {
            make.height.equalTo(55);
        }
        
    }];
    forSave.textAlignment = NSTextAlignmentCenter;
    forSave.textColor = [UIColor whiteColor];
    if (iPhone4) {
        forSave.font = [UIFont systemFontOfSize:14];
    } else if (iPhone5) {
        forSave.font = [UIFont systemFontOfSize:18];
    } else if (iPhone6) {
        forSave.font = [UIFont systemFontOfSize:22];
    } else if (iPhone6plus) {
        forSave.font = [UIFont systemFontOfSize:26];
    }


    ImageRightButton *detail = [[ImageRightButton alloc] init];
    [bottomView addSubview:detail];
    [detail setTitle:@"详情 >" forState:UIControlStateNormal];
    [detail makeConstraints:^(MASConstraintMaker *make) {
        if (iPhone4) {
            make.top.equalTo(forSave.bottom).offset(2.5);
        } else if (iPhone5) {
            make.top.equalTo(forSave.bottom).offset(5);
        } else if (iPhone6) {
            make.top.equalTo(forSave.bottom).offset(10);
        } else if (iPhone6plus) {
            make.top.equalTo(forSave.bottom).offset(15);
        }
        
        make.centerX.equalTo(bottomView.centerX);
        if (iPhone4 || iPhone5) {
            make.height.equalTo(30);
            make.width.equalTo(70);
        } else if (iPhone6) {
            make.height.equalTo(33);
            make.width.equalTo(88);
        } else if (iPhone6plus) {
            make.height.equalTo(35);
            make.width.equalTo(90);
        }
        
    }];
    if (iPhone4) {
        detail.titleLabel.font = [UIFont systemFontOfSize:12];
    } else if (iPhone5) {
        detail.titleLabel.font = [UIFont systemFontOfSize:14];
    } else if (iPhone6) {
        detail.titleLabel.font = [UIFont systemFontOfSize:14];
    } else if (iPhone6plus) {
        detail.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    detail.layer.borderWidth = 1;
    detail.layer.borderColor = [UIColor whiteColor].CGColor;
    detail.layer.cornerRadius = 8;
    detail.layer.masksToBounds = YES;
    [detail addTarget:self action:@selector(detailClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.carNum = carNum;
    self.fuelCard = fuelCard;
    self.FuelCardNo = FuelCardNo;
    self.team = team;
    self.remainingFee = remainingFee;
    self.forSave = forSave;
    
}

- (void)detailClicked:(UIButton *)sender {
    if ([self.fuelCardCellDelegate respondsToSelector:@selector(detailButtonClickedOnFuelCardCell:)]) {
        [self.fuelCardCellDelegate detailButtonClickedOnFuelCardCell:self];
    }
}

@end
