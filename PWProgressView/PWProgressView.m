//
//  TestView.m
//  PWProgressView
//
//  Created by Peter Willsey on 12/17/13.
//  Copyright (c) 2013 Peter Willsey, Inc. All rights reserved.
//

#import "PWProgressView.h"
#import <QuartzCore/QuartzCore.h>

static const NSTimeInterval PWProgressViewAnimationDuration = 0.25f;

@interface PWProgressView ()

@property (nonatomic, strong) CAShapeLayer *boxShape;
@property (nonatomic, strong) CAShapeLayer *progressShape;
@property (nonatomic, strong) NSMutableArray *animationQueue;
@property (assign) NSInteger activeAnimations;

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

        self.animationQueue = [[NSMutableArray alloc] init];
        self.activeAnimations = 0;
        
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
    
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(-0.5f * CGRectGetWidth(self.bounds) + 10.0f,
                                                                        -0.5f * CGRectGetHeight(self.bounds) + 10.0f,
                                                                        CGRectGetWidth(self.bounds) - 20.0f,
                                                                        CGRectGetHeight(self.bounds) - 20.0f)
                                                cornerRadius:(CGRectGetWidth(self.bounds) - 20.0f) / 2.0f]];
    
    [path setUsesEvenOddFillRule:YES];
    
    self.boxShape.path = path.CGPath;
    
    self.progressShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(32.5f,
                                                                                 32.5f,
                                                                                 CGRectGetWidth(self.bounds) - 65.0f,
                                                                                 CGRectGetHeight(self.bounds) - 65.0f)
                                                         cornerRadius:(CGRectGetWidth(self.bounds) - 65.0f) / 2.0f].CGPath;
    
    self.progressShape.lineWidth = CGRectGetWidth(self.bounds) - 65.0f;
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if (animated) {
        [self animateProgress:progress];
    } else {
        self.progressShape.strokeStart = progress;
    }
    
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

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (float)pinnedProgress:(float)progress
{
    float pinnedProgress = MAX(0.0f, progress);
    pinnedProgress = MIN(1.0f, progress);
    
    return pinnedProgress;
}

- (void)animateProgress:(float)progress
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    pathAnimation.duration = PWProgressViewAnimationDuration;
    
    pathAnimation.fromValue = [NSNumber numberWithFloat:self.progress];
    pathAnimation.toValue = [NSNumber numberWithFloat:progress];
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.repeatCount = 0;
    pathAnimation.autoreverses = NO;
    pathAnimation.delegate = self;
    
    if (self.activeAnimations > 0) {
        [self.animationQueue addObject:pathAnimation];
    } else {
        [self.progressShape addAnimation:pathAnimation forKey:@"strokeStart"];
    }
    self.activeAnimations++;
}

- (void)applyNextAnimation
{
    if ([self.animationQueue count] > 0) {
        CABasicAnimation *nextAnimation = self.animationQueue[0];
        [self.animationQueue removeObject:nextAnimation];
        
        [self.progressShape removeAllAnimations];
        [self.progressShape addAnimation:nextAnimation forKey:@"strokeStart"];
    }
}

#pragma mark - Basic animation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self applyNextAnimation];
    self.activeAnimations--;
}

@end
