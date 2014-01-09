//
//  TestView.m
//  PWProgressView
//
//  Created by Peter Willsey on 12/17/13.
//  Copyright (c) 2013 Peter Willsey, Inc. All rights reserved.
//

#import "PWProgressView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat PWCenterHoleInset = 10.0f;
static const CGFloat PWProgressShapeInset = 2.0f;


@interface PWProgressView ()

@property (nonatomic, strong) CAShapeLayer *boxShape;
@property (nonatomic, strong) CAShapeLayer *progressShape;

@end

@implementation PWProgressView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        self.alpha = 0.45f;
        
        self.boxShape = [CAShapeLayer layer];
        
        self.boxShape.fillColor         = [UIColor blackColor].CGColor;
        self.boxShape.anchorPoint       = CGPointZero;
        self.boxShape.contentsGravity   = kCAGravityCenter;
        self.boxShape.fillRule          = kCAFillRuleEvenOdd;

        self.progressShape = [CAShapeLayer layer];
        
        self.progressShape.fillColor   = [UIColor clearColor].CGColor;
        self.progressShape.strokeColor = [UIColor blackColor].CGColor;

        [self.layer addSublayer:self.boxShape];
        [self.layer addSublayer:self.progressShape];
    }
    
    return self;
}

- (void)layoutSubviews
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-0.5f * CGRectGetWidth(self.bounds),
                                                                     -0.5f * CGRectGetHeight(self.bounds),
                                                                     CGRectGetWidth(self.bounds),
                                                                     CGRectGetHeight(self.bounds))];
    
    self.boxShape.frame = self.frame;
    
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(-0.5f * CGRectGetWidth(self.bounds) + PWCenterHoleInset,
                                                                        -0.5f * CGRectGetHeight(self.bounds) + PWCenterHoleInset,
                                                                        CGRectGetWidth(self.bounds) - PWCenterHoleInset * 2,
                                                                        CGRectGetHeight(self.bounds) - PWCenterHoleInset * 2)
                                                cornerRadius:(CGRectGetWidth(self.bounds) - PWCenterHoleInset * 2) / 2.0f]];
    
    [path setUsesEvenOddFillRule:YES];
    
    self.boxShape.path = path.CGPath;
    
    CGFloat diameter = CGRectGetWidth(self.bounds) - (2 * PWCenterHoleInset) - (2 * PWProgressShapeInset);
    CGFloat radius = diameter / 2.0f;
    
    self.progressShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((CGRectGetWidth(self.bounds) / 2.0f) - (radius / 2.0f),
                                                                                 (CGRectGetHeight(self.bounds) / 2.0f) - (radius / 2.0f),
                                                                                 radius,
                                                                                 radius)
                                                         cornerRadius:radius].CGPath;
    
    self.progressShape.lineWidth = radius;
}

- (void)setProgress:(float)progress
{
    self.progressShape.strokeStart = progress;

    if (_progress == 1.0f && progress < 1.0f) {
        [self.boxShape removeAllAnimations];
    }

    _progress = [self pinnedProgress:progress];

    if (_progress == 1.0f) {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.toValue = @2.0f;
        scaleAnimation.duration = 0.5f;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        [self.boxShape addAnimation:scaleAnimation forKey:@"transform.scale"];
    }
}

- (float)pinnedProgress:(float)progress
{
    float pinnedProgress = MAX(0.0f, progress);
    pinnedProgress = MIN(1.0f, progress);
    
    return pinnedProgress;
}

@end
