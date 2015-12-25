//
//  OrderProcessFlowNodeView.m
//  tcb
//
//  Created by Chuanxun on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "OrderProcessFlowNodeView.h"
#import "UIImage+JAX.h"
#import "UILabel+Extension.h"
#import "NSAttributedString+Emoji.h"

#define NODEVIEW_MARGIN_BENTWEEN_LABEL_SUPERVIEW 16
#define NODEVIEW_MARGIN_BETWEEN_LABEL1_LABEL2 4
#define NODEVIEW_MARGIN_BETWEEN_BUTTON_LABEL 8
#define NODEVIEW_BUTTON_WIDTH 32
#define NODEVIEW_MARGIN_BETWEEN_BUTTON_SUPERVIEW 8
#define NODEVIEW_MARGIN_BETWEEN_COLUMN 8
#define NODEVIEW_MARGIN_BETWEEN_LABEL_ICON 0
#define NODEVIEW_LOCATION_ICON_WIDTH 16

//static UIEdgeInsets const PADDING = {8,8,8,8};
//static UIEdgeInsets const PADDING_LARGE = {8,16,8,8};
//static UIEdgeInsets const PADDING_SMALL = {8,0,8,8};

@interface OrderProcessFlowNodeView ()
@property (weak, nonatomic) UIButton *btnContact;
@property (strong, nonatomic) NSMutableArray *arrayLabels;
@property (strong, nonatomic) UIFont *font;
@property (weak, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) NSMutableDictionary *indexToIconDict;


@property (strong, nonatomic) UIView *tmpViewForMakeConstraint;
@property (strong, nonatomic) NSMutableArray *arrayForLabelToLayout;

@end

@implementation OrderProcessFlowNodeView

+ (instancetype)nodeViewWithArray:(NSArray *)array  type:(NodeType)type
{
    OrderProcessFlowNodeView *nodeView = [[OrderProcessFlowNodeView alloc] init];
    nodeView.contents = array;
    nodeView.arrayLabels = [NSMutableArray new];
    nodeView.font = FONT_MIDDLE;
    nodeView.indexToIconDict = [NSMutableDictionary new];
    nodeView.arrayForLabelToLayout = [NSMutableArray new];
    nodeView.type = type;
    [nodeView makeContents];
    return nodeView;
}

- (void)makeContents
{
    UIImage *imageBackgroundForView;
    UIImage *resizeImage;
    if (self.type == NODE_TYPE_SHI_FENG) {
        imageBackgroundForView = [UIImage imageNamed:@"pop_green"];
        resizeImage = [imageBackgroundForView resizableImageWithCapInsets:UIEdgeInsetsMake(45, 40, 16, 16)];
    }else {
       imageBackgroundForView = [UIImage imageNamed:@"pop_gray"];
        resizeImage = [imageBackgroundForView resizableImageWithCapInsets:UIEdgeInsetsMake(45, 40, 16, 16)];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:resizeImage];
    [self addSubview:imageView];
    self.backgroundImageView = imageView;
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIButton *btnContact = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageBackForBtn;
    if (self.type == NODE_TYPE_SHI_FENG) {
        imageBackForBtn = [UIImage imageNamed:@"signIn_signIn"];
    }else {
        imageBackForBtn = [UIImage imageNamed:@"signIn_telephone"];
    }
    [btnContact setBackgroundImage:imageBackForBtn forState:UIControlStateNormal];
    [self addSubview:btnContact];
    self.btnContact = btnContact;
    [btnContact makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.right).offset(-NODEVIEW_MARGIN_BETWEEN_BUTTON_SUPERVIEW);
        make.width.equalTo(NODEVIEW_BUTTON_WIDTH);
        make.height.equalTo(NODEVIEW_BUTTON_WIDTH);
    }];
    [btnContact addTarget:self action:@selector(btnContactClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i < self.contents.count; i++) {
        NSDictionary *dictContentItem = self.contents[i];
        NSString *strTitle1 = [dictContentItem objectForKey:K_NODEVIEW_LABEL1];
        NSString *strTitle2 = [dictContentItem objectForKey:K_NODEVIEW_LABEL2];
        NSString *strIconName = [dictContentItem objectForKey:K_NODEVIEW_ICON];
        
        UILabel *label1 = [UILabel new];
        label1.font = self.font;
        label1.text = [NSString stringWithFormat:@"%@ ：",strTitle1];
        label1.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label1];
        
        
        /**  使用NSAttributedString的两个关键点：
         1、把attributedString赋值给label.attributedText之后，如果修改label的textAlignment，会影响attributedString的boundingRect计算。
         2、如果attributedString带attachment，那么要给包括attachment在内的整个attributedString都设置font和color两个属性，才能保证boundingRect计算正确。
         */
        UILabel *label2 = [[UILabel alloc] init];
        if (strIconName.length > 0) {
            NSString *emojiStr = [NSString stringWithFormat:@"%@%@%@.png",strTitle2,EMOJI_REGULAR_PERFIX,strIconName];
            NSMutableAttributedString *attributeStr = [NSAttributedString emojiStringWithString:emojiStr];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.alignment = NSTextAlignmentLeft;
            
            [attributeStr addAttributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attributeStr.length)];
            label2.attributedText = attributeStr;
            label2.numberOfLines = 0;
        }else {
            label2.font = self.font;
            label2.text = strTitle2;
            label2.textAlignment = NSTextAlignmentLeft;
            label2.numberOfLines = 0;
        }
        [self addSubview:label2];
        
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label2.top);
            make.left.equalTo(self.left).offset(NODEVIEW_MARGIN_BENTWEEN_LABEL_SUPERVIEW);
        }];
        
        [label2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1.right).offset(NODEVIEW_MARGIN_BETWEEN_LABEL1_LABEL2).priority(1000);
            if (!self.tmpViewForMakeConstraint) {
                
                make.top.equalTo(self.top).offset(NODEVIEW_MARGIN_BETWEEN_COLUMN);
            }else {
                make.top.equalTo(self.tmpViewForMakeConstraint.bottom).offset(NODEVIEW_MARGIN_BETWEEN_COLUMN);
            }
            make.right.lessThanOrEqualTo(btnContact.left).offset(-NODEVIEW_MARGIN_BETWEEN_BUTTON_LABEL);
        }];
        
        self.tmpViewForMakeConstraint = label2;
        
        [self.arrayForLabelToLayout addObject:label1];
        [self.arrayForLabelToLayout addObject:label2];
    };
    
}


-(CGFloat)estimatedHeightWithWidth:(CGFloat)width
{
    CGFloat estimatedHeight = 0;
    for (int i = 0; i < self.arrayForLabelToLayout.count; i = i + 2) {
        UILabel *label1 = self.arrayForLabelToLayout[i];
        UILabel *label2 = self.arrayForLabelToLayout[i+1];
        
        CGFloat estimatedWidthForLabel1 = [label1.text boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width;
        CGFloat labelMaxWidth = width - NODEVIEW_MARGIN_BENTWEEN_LABEL_SUPERVIEW - estimatedWidthForLabel1 - NODEVIEW_MARGIN_BETWEEN_LABEL1_LABEL2 - NODEVIEW_MARGIN_BETWEEN_BUTTON_LABEL - NODEVIEW_BUTTON_WIDTH - NODEVIEW_MARGIN_BETWEEN_BUTTON_SUPERVIEW;
        
        estimatedHeight += NODEVIEW_MARGIN_BETWEEN_COLUMN;
        
        NSDictionary *dictContentItem = self.contents[i/2];
        NSString *strIconName = [dictContentItem objectForKey:K_NODEVIEW_ICON];
        CGFloat height;
        if (strIconName.length > 0) {
            height = [label2.attributedText boundingRectWithSize:CGSizeMake(labelMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
        }else {
            height = [label2.text boundingRectWithSize:CGSizeMake(labelMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil].size.height;
        }
        
        
        //        UITextView *view=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, labelMaxWidth, 10)];
        //        [view setAttributedText:label2.attributedText];
        //        CGSize size=[view sizeThatFits:CGSizeMake(labelMaxWidth, CGFLOAT_MAX)];
        //        CGFloat height=size.height;
        
        estimatedHeight += height;
//        NSLog(@"%f",height);
    }
    estimatedHeight += NODEVIEW_MARGIN_BETWEEN_COLUMN;
    
    return estimatedHeight;
}


- (void)btnContactClicked:(UIButton *)sender
{
    if (self.type == NODE_TYPE_SHI_FENG) {
        NSLog(@"shifeng");
    }else {
        NSLog(@"telephone");
    }
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    for (int i = 0; i < self.arrayForLabelToLayout.count; i = i + 2) {
//        UILabel *label = self.arrayForLabelToLayout[i+1];
//
//    }
//}

/*
 - (void)makeContents
 {
 UIImage *imageBackgroundForView = [UIImage imageNamed:@"signIn_btn_back_gray"];
 UIImage *resizeImage = [imageBackgroundForView resizableImageWithCapInsets:UIEdgeInsetsMake(55, 40, 30, 30)];
 UIImageView *imageView = [[UIImageView alloc] init];
 imageView.image = resizeImage;
 imageView.backgroundColor = [UIColor greenColor];
 [self addSubview:imageView];
 self.backgroundImageView = imageView;
 //    [imageView makeConstraints:^(MASConstraintMaker *make) {
 //        make.edges.equalTo(self);
 //    }];
 
 UIButton *btnContact = [UIButton buttonWithType:UIButtonTypeCustom];
 UIImage *imageBackForBtn = [UIImage imageNamed:@"signIn_telephone"];
 [btnContact setBackgroundImage:imageBackForBtn forState:UIControlStateNormal];
 [self addSubview:btnContact];
 self.btnContact = btnContact;
 
 for (int i = 0; i < self.contents.count; i++) {
 NSDictionary *dictContentItem = self.contents[i];
 NSString *strTitle1 = [dictContentItem objectForKey:K_NODEVIEW_LABEL1];
 NSString *strTitle2 = [dictContentItem objectForKey:K_NODEVIEW_LABEL2];
 NSString *strIconName = [dictContentItem objectForKey:K_NODEVIEW_ICON];
 
 UILabel *label1 = [UILabel new];
 label1.font = self.font;
 label1.text = [NSString stringWithFormat:@"%@ ：",strTitle1];
 label1.textAlignment = NSTextAlignmentLeft;
 label1.numberOfLines = 1;
 [self addSubview:label1];
 [self.arrayLabels addObject:label1];
 
 UILabel *label2 = [UILabel new];
 label2.font = self.font;
 label2.text = strTitle2;
 label2.textAlignment = NSTextAlignmentLeft;
 label2.numberOfLines = 0;
 label2.lineBreakMode = NSLineBreakByTruncatingTail;
 [self addSubview:label2];
 [self.arrayLabels addObject:label2];
 
 if (strIconName && strIconName.length > 0) {
 UIImage *image = [UIImage imageNamed:strIconName];
 if (image) {
 UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
 [self addSubview:imageView];
 [self.indexToIconDict setObject:imageView forKey:[NSNumber numberWithInt:i*2]];
 }
 }
 }
 
 }
 
 -(void)layoutSubviews
 {
 [super layoutSubviews];
 
 self.backgroundImageView.frame = self.bounds;
 
 CGSize size = [self estimatedSizeWithWidth:self.frame.size.width];
 
 //    CGRect frame = self.frame;
 //    frame.size.height = size.height;
 //    self.frame = frame;
 //
 //    [super layoutSubviews];
 }
 
 
 -(CGSize)estimatedSizeWithWidth:(CGFloat)width
 {
 for (int i = 0; i < self.arrayLabels.count; i = i + 2) {
 
 CGFloat label1X,label1Y,label1W,label1H;
 
 label1X = NODEVIEW_MARGIN_BENTWEEN_LABEL_SUPERVIEW;
 if (i / 2 > 0) {
 UILabel *upLabel = self.arrayLabels[i - 1];
 label1Y = CGRectGetMaxY(upLabel.frame) + NODEVIEW_MARGIN_BETWEEN_COLUMN;
 }else {
 label1Y = NODEVIEW_MARGIN_BETWEEN_COLUMN;
 }
 UILabel *label1 = self.arrayLabels[i];
 CGSize label1Size = [label1 boundingRectWithSize:CGSizeMake(width, 0)];
 label1W = label1Size.width;
 label1H = label1Size.height;
 label1.frame = CGRectMake(label1X, label1Y, label1W, label1H);
 
 UILabel *label2 = self.arrayLabels[i+1];
 CGFloat label2X,label2Y,label2W,label2H;
 label2X = CGRectGetMaxX(label1.frame) + NODEVIEW_MARGIN_BETWEEN_LABEL1_LABEL2;
 label2Y = label1Y;
 
 CGFloat iconW = NODEVIEW_LOCATION_ICON_WIDTH;
 CGFloat widthOfSizeToMakeBounding = self.frame.size.width - label2X - NODEVIEW_MARGIN_BETWEEN_LABEL_ICON  - NODEVIEW_MARGIN_BETWEEN_BUTTON_LABEL - NODEVIEW_BUTTON_WIDTH - NODEVIEW_MARGIN_BETWEEN_BUTTON_SUPERVIEW;
 CGSize sizeToMakeBounding = CGSizeMake(widthOfSizeToMakeBounding, 0);
 CGSize label2Size = [label2 boundingRectWithSize:sizeToMakeBounding];
 label2W = label2Size.width;
 label2H = label2Size.height;
 label2.frame = CGRectMake(label2X, label2Y, label2W, label2H);
 
 //location icon frame setting
 UIImageView *imageView = [self.indexToIconDict objectForKey:[NSNumber numberWithInt:i]];
 if (imageView) {
 CGFloat iconX,iconY,iconH;
 CGFloat widthWhenDisplayInOneLine = [label2 boundingRectWithSize:CGSizeMake(0, label1H)].width;
 int lineNumbers = (int)(widthWhenDisplayInOneLine / label2W);
 CGFloat lastLineTextWidth = widthWhenDisplayInOneLine - lineNumbers * label2W;
 iconX = label2X + lastLineTextWidth + NODEVIEW_MARGIN_BETWEEN_LABEL_ICON;
 if (lastLineTextWidth > 0) {
 iconX = label2X + lastLineTextWidth + NODEVIEW_MARGIN_BETWEEN_LABEL_ICON;
 }else {
 iconX = label2X + label2W + NODEVIEW_MARGIN_BETWEEN_LABEL_ICON;
 }
 
 iconH = NODEVIEW_LOCATION_ICON_WIDTH;
 iconY = CGRectGetMaxY(label2.frame) - label1H - (iconH - label1H)/2.0;
 iconY += 2;
 CGRect iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
 imageView.frame = iconFrame;
 }
 }
 
 //return size
 CGFloat height = CGRectGetMaxY([self.arrayLabels.lastObject frame]);
 height += NODEVIEW_MARGIN_BETWEEN_COLUMN;
 CGSize size = CGSizeMake(width, height);
 
 //contact button frame setting
 CGFloat btnX,btnY;
 UIButton *btn = self.btnContact;
 btnX = self.frame.size.width - NODEVIEW_MARGIN_BETWEEN_BUTTON_SUPERVIEW - NODEVIEW_BUTTON_WIDTH;
 btnY = (height - NODEVIEW_BUTTON_WIDTH) / 2.0;
 btn.frame = CGRectMake(btnX, btnY, NODEVIEW_BUTTON_WIDTH, NODEVIEW_BUTTON_WIDTH);
 
 
 return size;
 }
 */



@end
