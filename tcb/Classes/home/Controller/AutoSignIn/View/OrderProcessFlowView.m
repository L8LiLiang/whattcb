//
//  OrderProcessFlowView.m
//  tcb
//
//  Created by Chuanxun on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

/*
 UILabel UIButton 有intrinsicContentSize，自动布局的相关约束可以省略，否则必须指定约束，否则会导致约束不完整。
 自定义View，如果在为他添加约束时，他的宽或者高不能确定（不能指定宽或者高的约束），那么就需要在intrinsicContentSize方法中指定view的本质大小，这样的话，自动布局系统就会使用该View的本质大小进行布局。但是有一点要注意，调用intrinsicContentSize时，并不能确定View自身的frame。
 
 layoutSubViews之前，会调用updateConstraint，这是一个修改约束的好时机。（但是屏幕旋转时不会掉用，有问题）
 
 可以在layoutSubViews方法中，修改子view的约束（比如高度约束），然后在调用一次[super layoutSubviews]
 
 这个例子的实现思路：
 
 父view使用约束对子view进行布局，其中，只有nodeView的高度约束不能确定，目前是通过在layoutSubviews方法中，通过nodeView的estimatedHeightWithWidth方法获得nodeView的高度，然后修改高度约束，然后再调用一次［super layoutSubviews］方法做一次布局。
 
 只有父View的layoutSubviews方法退出之后，才会递归调用子view的layoutSubviews方法。
 
 nodeViw也是完全使用约束进行布局的，虽然因为他包含多个label，并且label的文字是动态的，导致label的高度是动态的，进而导致nodeView自身的高度是动态的。但是我们可以另开一个方法，在确定nodeView自身width的情况下，计算出nodeView的合适高度。
 
 Masonry的lessOrEqualThen方法起到了关键作用，使用它做到了｀左边界估定，右边界动态调整，并且最大不能超过某个值｀的效果。
 
 ScrollView中的subView使用自动布局时，只要他们的width和height不依赖于scrollView，那么scrollView就可以自动设置contentSize，布局就会一起正常。你可以像本例一样分别为每个subView确定宽高，也可以在scrollView添加一个contentView，把subViews添加到contentView中，然后根据contentView确定contentSize。
 */

#import "OrderProcessFlowView.h"
#import "UILabel+Extension.h"

#define FLOWVIEW_MARGIN_BETWEEN_TITLE_ICON 8
#define FLOWVIEW_FONT FONT_MIDDLE
#define FLOWVIEW_LABEL_WIDTH 60
#define FLOWVIEW_IMAGE_WIDTH 12
#define FLOWVIEW_MARGIN_BETWEEN_TITLE_SUPERVIEW 0
#define FLOWVIEW_MARGIN_BETWEEN_COLUMN 16
#define FLOWVIEW_MARGIN_BETWEEN_NODE_SUPERVIEW 8
#define FLOWVIEW_MARGIN_BETWEEN_ICON_NODE 4
#define FLOWVIEW_LINE_WIDTH 2
//static UIEdgeInsets const FLOWVIEW_PADDING = {16,16,16,4};

@implementation Order



@end



@interface UIView ()

- (CGFloat)estimatedHeightWithWidth:(CGFloat)width;

@end


@interface OrderProcessFlowView ()

@property (strong ,nonatomic) NSMutableArray *nodeViews;
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) MASConstraint *bottomConstraint;
@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) NSMutableArray *lines;
@end

@implementation OrderProcessFlowView

+(instancetype)flowViewWithOrder:(Order *)order  width:(CGFloat)widthForLayoutSubViews delegate:(id<OrderProcessFlowViewDelegate>)delegate
{
    OrderProcessFlowView *flowView = [[OrderProcessFlowView alloc] init];
    flowView.order = order;
    flowView.widthForLayoutSubViews = widthForLayoutSubViews;
    flowView.nodeViews = [NSMutableArray new];
    flowView.imageViews = [NSMutableArray new];
    flowView.labels = [NSMutableArray new];
    flowView.lines = [NSMutableArray new];
    flowView.flowViewDelegate = delegate;
    for (NSString *title in order.titles) {
        [flowView addNode];
    }
    UIColor *color = [UIColor colorWithRed:236/255.0 green:241/255.0 blue:245/255.0 alpha:1.0];
    flowView.backgroundColor = color;
    
    return flowView;
}

static int toogle = 0;

- (void)addNode
{
    OrderProcessFlowNodeView *lastNodeView = self.nodeViews.lastObject;
    UIView *nodeView;
    int type = toogle % 3;
    if (type == 0) {
        OrderProcessFlowInputBoxNoView *boxNoInputView = [OrderProcessFlowInputBoxNoView boxNoView];
        [self addSubview:boxNoInputView];
        [self.nodeViews addObject:boxNoInputView];
        boxNoInputView.delegate = self.flowViewDelegate;
        nodeView = boxNoInputView;
    }else if(type == 1){
        
        NSDictionary *dict1 = @{K_NODEVIEW_LABEL1:@"地点",K_NODEVIEW_LABEL2:@"基隆场地",K_NODEVIEW_ICON:@"signIn_location"};
        NSDictionary *dict2 = @{K_NODEVIEW_LABEL1:@"提柜时间",K_NODEVIEW_LABEL2:@"08-24 8:00",K_NODEVIEW_ICON:@""};
        NSArray *arr = @[dict1,dict2];
        OrderProcessFlowNodeView *flowNodeView = [OrderProcessFlowNodeView nodeViewWithArray:arr type:NODE_TYPE_COMMON];
        [self addSubview:flowNodeView];
        [self.nodeViews addObject:flowNodeView];
        flowNodeView.delegate = self.flowViewDelegate;
        nodeView = flowNodeView;
    }else {
        NSDictionary *dict1 = @{K_NODEVIEW_LABEL1:@"地点",K_NODEVIEW_LABEL2:@"施封地点是天安门",K_NODEVIEW_ICON:@"signIn_location"};
        NSDictionary *dict2 = @{K_NODEVIEW_LABEL1:@"提柜时间",K_NODEVIEW_LABEL2:@"08-24 8:00",K_NODEVIEW_ICON:@""};
        NSArray *arr = @[dict1,dict2];
        OrderProcessFlowNodeView *flowNodeView = [OrderProcessFlowNodeView nodeViewWithArray:arr type:NODE_TYPE_SHI_FENG];
        [self addSubview:flowNodeView];
        [self.nodeViews addObject:flowNodeView];
        flowNodeView.delegate = self.flowViewDelegate;
        nodeView = flowNodeView;
    }
    
    ++toogle;
    
    
    if (self.bottomConstraint) {
        [self.bottomConstraint uninstall];
    }
    
    UILabel *label = UILabel.new;
    label.text = @"提空踢空";
    label.font = FLOWVIEW_FONT;
    label.textAlignment = NSTextAlignmentRight;
    [self addSubview:label];
    [self.labels addObject:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[self class] imageForInPorgressingNode]];
    [self addSubview:imageView];
    [self.imageViews addObject:imageView];
    
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(FLOWVIEW_MARGIN_BETWEEN_TITLE_SUPERVIEW);
        make.width.equalTo(FLOWVIEW_LABEL_WIDTH);
    }];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.right).offset(FLOWVIEW_MARGIN_BETWEEN_TITLE_ICON);
        make.size.equalTo(CGSizeMake(FLOWVIEW_IMAGE_WIDTH, FLOWVIEW_IMAGE_WIDTH));
        make.right.equalTo(nodeView.left).offset(-FLOWVIEW_MARGIN_BETWEEN_ICON_NODE);
        make.top.equalTo(nodeView).offset(32);
        make.centerY.equalTo(label);
    }];
    
    [nodeView makeConstraints:^(MASConstraintMaker *make) {
        if (!lastNodeView) {
            make.top.equalTo(self.top).offset(FLOWVIEW_MARGIN_BETWEEN_COLUMN);
        }else {
            make.top.equalTo(lastNodeView.bottom).offset(FLOWVIEW_MARGIN_BETWEEN_COLUMN);
        }
        self.bottomConstraint = make.bottom.equalTo(self.bottom).offset(-FLOWVIEW_MARGIN_BETWEEN_COLUMN);
//        make.width.equalTo(@100);
//        make.height.equalTo(@100);
        
        NSNumber *width = [self widthForNode];
        make.width.equalTo(width);
        CGFloat height = [nodeView estimatedHeightWithWidth:width.floatValue];
        NSNumber *numHeight = [NSNumber numberWithFloat:height];
        make.height.equalTo(numHeight);
    }];
    
    
    if (self.imageViews.count > 1) {
        
        UIImageView *upperView = self.imageViews[self.imageViews.count - 2];
        UIImageView *lowerView = self.imageViews[self.imageViews.count - 1];
        UIView *line = [UIView new];
        [self insertSubview:line atIndex:1];
        [self.lines addObject:line];
        line.backgroundColor = [UIColor colorWithRed:109/255.0 green:179/255.0 blue:41/255.0 alpha:1.0];
        
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView.centerX);
            make.top.equalTo(upperView.centerY);
            make.bottom.equalTo(lowerView.centerY);
            make.width.equalTo(@2);
        }];
    }
}

+ (UIImage *)imageForFinishedNode
{
    return [UIImage imageNamed:@"signIn_node_finish"];
}

+ (UIImage *)imageForInPorgressingNode
{
    return [UIImage imageNamed:@"signIn_node_processing"];
}

+ (UIImage *)imageForNotProcessNode
{
    return [UIImage imageNamed:@"signIn_node_readyToDo"];
}


-(void)layoutSubviews
{
//    NSLog(@"%@",NSStringFromCGRect(self.frame));
    [super layoutSubviews];
    
    /** 因为性能原因，不在这里计算nodeView的高度了，在创建nodeView时计算 */
    /*
    for (OrderProcessFlowNodeView *view in self.nodeViews) {
        [view updateConstraints:^(MASConstraintMaker *make) {
            NSNumber *width = [self widthForNode];
            make.width.equalTo(width);
            CGFloat height = [view estimatedHeightWithWidth:width.floatValue];
            NSNumber *numHeight = [NSNumber numberWithFloat:height];
            make.height.equalTo(numHeight);
        }];
    }
    [super layoutSubviews];
     */
}

- (NSNumber*)widthForNode
{
    
    CGFloat imageX = FLOWVIEW_MARGIN_BETWEEN_TITLE_SUPERVIEW + FLOWVIEW_LABEL_WIDTH + FLOWVIEW_MARGIN_BETWEEN_TITLE_ICON + FLOWVIEW_IMAGE_WIDTH;
//    CGFloat width = self.frame.size.width - imageX - FLOWVIEW_MARGIN_BETWEEN_ICON_NODE - FLOWVIEW_MARGIN_BETWEEN_NODE_SUPERVIEW;
    CGFloat width = self.widthForLayoutSubViews - imageX - FLOWVIEW_MARGIN_BETWEEN_ICON_NODE - FLOWVIEW_MARGIN_BETWEEN_NODE_SUPERVIEW;
    
    return [NSNumber numberWithFloat:width];
}

/*
 -(void)updateConstraints
 {
 NSLog(@"updateConstraints");
 
 for (OrderProcessFlowNodeView *view in self.nodeViews) {
 [view updateConstraints:^(MASConstraintMaker *make) {
 NSNumber *width = [self widthForNode];
 make.width.equalTo(width);
 }];
 }
 
 //    for (int i = 0; i < self.labels.count; i++) {
 //        UILabel *label = self.labels[i];
 //        OrderProcessFlowNodeView *nodeView = self.nodeViews[i];
 //        CGFloat estimatedHeight = [nodeView estimatedHeightWithWidth:self.frame.size.width];
 //        [label updateConstraints:^(MASConstraintMaker *make) {
 //            if (estimatedHeight < 96) {
 //                make.centerY.equalTo(nodeView.top).offset(40);
 //            }else {
 //                make.centerY.equalTo(nodeView.top).offset(48);
 //            }
 //        }];
 //    }
 
 [super updateConstraints];
 }
 
 */

/*
 -(void)layoutSubviews
 {
 [super layoutSubviews];
 
 for (int i = 0; i < self.nodeViews.count; i++) {
 
 UIView *nodeView = self.nodeViews[i];
 UILabel *label = self.labels[i];
 UIImageView *imageView = self.imageViews[i];
 
 CGFloat labelX,labelY,labelW,labelH;
 CGFloat imageX,imageY,imageW,imageH;
 
 labelX = FLOWVIEW_MARGIN_BETWEEN_TITLE_SUPERVIEW;
 labelW = FLOWVIEW_LABEL_WIDTH;
 labelH = [label boundingRectWithSize:CGSizeMake(0, 0)].height;
 
 imageX = labelX + labelW + FLOWVIEW_MARGIN_BETWEEN_TITLE_ICON;
 imageH = FLOWVIEW_IMAGE_WIDTH;
 imageW = FLOWVIEW_IMAGE_WIDTH;
 
 CGFloat nodeX,nodeY,nodeW,nodeH;
 nodeX = imageX + imageW + FLOWVIEW_MARGIN_BETWEEN_ICON_NODE;
 if (i > 0) {
 nodeY = CGRectGetMaxY([self.nodeViews[i-1] frame]) + FLOWVIEW_MARGIN_BETWEEN_COLUMN;
 }else {
 nodeY = FLOWVIEW_MARGIN_BETWEEN_COLUMN;
 }
 nodeW = self.frame.size.width - nodeX - FLOWVIEW_MARGIN_BETWEEN_NODE_SUPERVIEW;
 CGSize nodeSize = [nodeView estimatedSizeWithWidth:nodeW];
 nodeH = nodeSize.height;
 nodeView.frame = CGRectMake(nodeX, nodeY, nodeW, nodeH);
 
 imageY = nodeY + 48 - FLOWVIEW_IMAGE_WIDTH / 2.0;
 imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
 
 labelY = imageY - (labelH - imageH)/2.0;
 label.frame = CGRectMake(labelX, labelY, labelW, labelH);
 }
 
 
 for (int i = 0; i < self.lines.count; i++) {
 UIView *line = self.lines[i];
 
 UIImageView *upperView = self.imageViews[i];
 UIImageView *lowerView = self.imageViews[i+1];
 
 CGFloat lineX,lineY,lineW,lineH;
 //        lineX = upperView.center.x - (FLOWVIEW_LINE_WIDTH / 2.0);
 //        lineY = upperView.center.y;
 //        lineW = FLOWVIEW_LINE_WIDTH;
 //        lineH = lowerView.center.y - upperView.center.x;
 //        line.frame = CGRectMake(lineX, lineY, lineW, lineH);
 lineX = upperView.frame.origin.x - (FLOWVIEW_LINE_WIDTH - upperView.frame.size.width)/2.0;
 lineY = upperView.frame.origin.y - (FLOWVIEW_LINE_WIDTH - upperView.frame.size.width)/2.0;
 lineW = FLOWVIEW_LINE_WIDTH;
 lineH = lowerView.frame.origin.y - upperView.frame.origin.y;
 line.frame = CGRectMake(lineX, lineY, lineW, lineH);
 }
 
 
 CGSize contentSize = self.contentSize;
 contentSize.height = CGRectGetMaxY([self.nodeViews.lastObject frame]) + FLOWVIEW_MARGIN_BETWEEN_COLUMN;
 self.contentSize = contentSize;
 }
 */

- (void)printFrame
{
    NSLog(@"%@",NSStringFromCGRect([self.nodeViews.firstObject frame]));
}

@end
