//
//  ELProposeConfirmManager.m
//  tcb
//
//  Created by Chuanxun on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ELProposeConfirmManager.h"


typedef void (^ElPropopseConfirmManagerActionBlock)();

@interface ELProposeConfirmManager () <UIActionSheetDelegate>

@property (weak, nonatomic) UIViewController *destVC;
@property (strong, nonatomic) NSArray *msgs;
@property (strong, nonatomic) NSArray *actionBlocks;
@property (copy, nonatomic) NSString *title;

@end

@implementation ELProposeConfirmManager

+ (instancetype)sharedManager
{
    static ELProposeConfirmManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [ELProposeConfirmManager new];
        }
    });
    
    return manager;
}

- (void)proposeWithControllser:(UIViewController *)vc title:(NSString *)title msg:(NSArray *)msgs blocks:(NSArray*)actionBlocks
{
    
    @synchronized([ELProposeConfirmManager sharedManager]) {
        self.destVC = vc;
        self.msgs = msgs;
        self.actionBlocks = actionBlocks;
        self.title = title;
        
        
        if (NSClassFromString(@"UIAlertController")) {
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:self.title message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            for (int i = 0; i < self.msgs.count; i ++) {
                
                NSString *msg = self.msgs[i];
                ElPropopseConfirmManagerActionBlock block = self.actionBlocks[i];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:msg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    block();
                }];
                [alertVC addAction:action];
                
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"cancel");
                }];
                [alertVC addAction:cancel];
                
                [self.destVC presentViewController:alertVC animated:YES completion:nil];
            }
            
        }else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            for (int i = 0; i < self.msgs.count; i ++) {
                [actionSheet addButtonWithTitle:self.msgs[i]];
            }
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }

    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    @synchronized([ELProposeConfirmManager sharedManager]) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            ElPropopseConfirmManagerActionBlock block = self.actionBlocks[buttonIndex - 1];
            block();
        }
    }
}

@end
