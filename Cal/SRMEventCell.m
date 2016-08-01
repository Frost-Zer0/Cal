//
//  SRMEventCell.m
//  Cal
//
//  Created by Sorumi on 16/7/31.
//  Copyright © 2016年 Sorumi. All rights reserved.
//

#import "SRMEventCell.h"
#import "SRMCalendarConstance.h"

@interface SRMEventCell ()

@property (nonatomic) IBOutlet UIView *blockView;
@property (nonatomic) IBOutlet UIView *categoryColorView;
@property (nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation SRMEventCell

- (void)awakeFromNib {
    // Initialization code

    // shadow
    CALayer *layer = self.blockView.layer;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowRadius = 0.5;
    layer.shadowColor = [UIColor darkGrayColor].CGColor;
    layer.shadowOpacity = 0.3;
    
//    layer.cornerRadius = 2;
//    
//    // category
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.categoryColorView.bounds
//                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
//                                           cornerRadii:CGSizeMake(2, 2)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.categoryColorView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.categoryColorView.layer.mask = maskLayer;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public

- (void)setEvent:(NSString *)title
{
    self.titleLable.text = title;
}

@end
