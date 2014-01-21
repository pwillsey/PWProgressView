//
//  TestView.m
//  PWProgressView
//
//  Created by Peter Willsey on 12/17/13.
//  Copyright (c) 2013 Peter Willsey, Inc. All rights reserved.
//

#import "PWProgressView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat PWCenterHoleInsetRatio             = 0.2f;
static const CGFloat PWProgressShapeInsetRatio          = 0.03f;
static const CGFloat PWDefaultAlpha                     = 0.45f;
static const CGFloat PWScaleAnimationScaleFactor        = 2.3f;
static const CFTimeInterval PWScaleAnimationDuration    = 0.5;

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
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame),
                                           CGRectGetMinY(frame),
                                           CGRectGetWidth(frame),
                                           CGRectGetWidth(frame))];
    
    if (self) {
        self.alpha = PWDefaultAlpha;
        
        self.boxShape = [CAShapeLayer layer];
        
        self.boxShape.fillColor         = [UIColor blackColor].CGColor;
        self.boxShape.anchorPoint       = CGPointMake(0.5f, 0.5f);
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
    CGFloat centerHoleInset     = PWCenterHoleInsetRatio * CGRectGetWidth(self.bounds);
    CGFloat progressShapeInset  = PWProgressShapeInsetRatio * CGRectGetWidth(self.bounds);
    
    CGRect pathRect = CGRectMake(CGPointZero.x,
                                 CGPointZero.y,
                                 CGRectGetWidth(self.bounds),
                                 CGRectGetHeight(self.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:pathRect];
    
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(centerHoleInset,
                                                                        centerHoleInset,
                                                                        CGRectGetWidth(self.bounds) - centerHoleInset * 2,
                                                                        CGRectGetHeight(self.bounds) - centerHoleInset * 2)
                                                cornerRadius:(CGRectGetWidth(self.bounds) - centerHoleInset * 2) / 2.0f]];
    
    [path setUsesEvenOddFillRule:YES];
    
    self.boxShape.path = path.CGPath;
    self.boxShape.bounds = pathRect;
    self.boxShape.position = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));

    CGFloat diameter = CGRectGetWidth(self.bounds) - (2 * centerHoleInset) - (2 * progressShapeInset);
    CGFloat radius = diameter / 2.0f;
    
    self.progressShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((CGRectGetWidth(self.bounds) / 2.0f) - (radius / 2.0f),
                                                                                 (CGRectGetHeight(self.bounds) / 2.0f) - (radius / 2.0f),
                                                                                 radius,
                                                                                 radius)
                                                         cornerRadius:radius].CGPath;
    
    self.progressShape.lineWidth = radius;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:CGRectMake(CGRectGetMinX(frame),
                               CGRectGetMinY(frame),
                               CGRectGetWidth(frame),
                               CGRectGetWidth(frame))];
}

- (void)setProgress:(float)progress
{
    if ([self pinnedProgress:progress] != _progress) {
        self.progressShape.strokeStart = progress;

        if (_progress == 1.0f && progress < 1.0f) {
            [self.boxShape removeAllAnimations];
        }

        _progress = [self pinnedProgress:progress];

        if (_progress == 1.0f) {
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.toValue = @(PWScaleAnimationScaleFactor);
            scaleAnimation.duration = PWScaleAnimationDuration;
            scaleAnimation.removedOnCompletion = NO;
            scaleAnimation.autoreverses = NO;
            scaleAnimation.fillMode = kCAFillModeForwards;
            [self.boxShape addAnimation:scaleAnimation forKey:@"transform.scale"];
        }
    }
}

- (float)pinnedProgress:(float)progress
{
    float pinnedProgress = MAX(0.0f, progress);
    pinnedProgress = MIN(1.0f, pinnedProgress);
    
    return pinnedProgress;
}

@end
