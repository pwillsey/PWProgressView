//
//  PWProgressView.m
//  PWProgressView
//
//  Copyright (c) 2015 Peter Willsey
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "PWProgressView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat PWCenterHoleInsetRatio                     = 0.2f;
static const CGFloat PWProgressShapeInsetRatio                  = 0.03f;
static const CGFloat PWProgressPauseDiameterRatio               = 0.8f;
static const CGFloat PWProgressPauseCircleDiameterHeightRatio   = 0.5f;
static const CGFloat PWProgressPauseRectHeightWidthRatio        = 0.3f;
static const CGFloat PWProgressDefaultAlpha                     = 0.45f;
static const CFTimeInterval PWProgressScaleAnimationDuration    = 0.5;

@interface PWProgressView ()

@property (nonatomic, strong) CAShapeLayer *boxShape;
@property (nonatomic, strong) CAShapeLayer *progressShape;
@property (nonatomic, strong) CAShapeLayer *pausedShape;

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
        self.alpha = PWProgressDefaultAlpha;
        
        self.boxShape = [CAShapeLayer layer];
        
        self.boxShape.fillColor         = [UIColor blackColor].CGColor;
        self.boxShape.anchorPoint       = CGPointMake(0.5f, 0.5f);
        self.boxShape.contentsGravity   = kCAGravityCenter;
        self.boxShape.fillRule          = kCAFillRuleEvenOdd;

        self.progressShape = [CAShapeLayer layer];
        
        self.progressShape.fillColor    = [UIColor clearColor].CGColor;
        self.progressShape.strokeColor  = [UIColor blackColor].CGColor;
        
        self.pausedShape = [CAShapeLayer layer];
        
        self.pausedShape.fillColor      = [UIColor blackColor].CGColor;
        self.pausedShape.fillRule       = kCAFillRuleEvenOdd;
        self.pausedShape.hidden         = YES;
        
        [self.layer addSublayer:self.boxShape];
        [self.layer addSublayer:self.progressShape];
        [self.layer addSublayer:self.pausedShape];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat minSide = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    CGFloat centerHoleInset     = PWCenterHoleInsetRatio * minSide;
    CGFloat progressShapeInset  = PWProgressShapeInsetRatio * minSide;
    
    CGRect pathRect = CGRectMake(CGPointZero.x,
                                 CGPointZero.y,
                                 CGRectGetWidth(self.bounds),
                                 CGRectGetHeight(self.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:pathRect];
    
    CGFloat width = minSide - (centerHoleInset * 2);
    CGFloat height = width;
    
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake((CGRectGetWidth(self.bounds) - width) / 2.0f,
                                                                        (CGRectGetHeight(self.bounds) - height) / 2.0f,
                                                                        width,
                                                                        height)
                                                cornerRadius:(width / 2.0f)]];
    
    [path setUsesEvenOddFillRule:YES];
    
    self.boxShape.path = path.CGPath;
    self.boxShape.bounds = pathRect;
    self.boxShape.position = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));

    CGFloat diameter = minSide - (2 * centerHoleInset) - (2 * progressShapeInset);
    CGFloat pauseCircleDiameter = diameter * PWProgressPauseDiameterRatio;
    CGFloat radius = diameter / 2.0f;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.progressShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((CGRectGetWidth(self.bounds) / 2.0f) - (radius / 2.0f) - ((self.paused) ? (pauseCircleDiameter / 4.0f) : 0.0f),
                                                                                 (CGRectGetHeight(self.bounds) / 2.0f) - (radius / 2.0f) - ((self.paused) ? (pauseCircleDiameter / 4.0f) : 0.0f),
                                                                                 radius + ((self.paused) ? (pauseCircleDiameter / 2.0f) : 0.0f),
                                                                                 radius + ((self.paused) ? (pauseCircleDiameter / 2.0f) : 0.0f))
                                                         cornerRadius:radius].CGPath;
    
    self.progressShape.lineWidth = radius - ((self.paused) ? (pauseCircleDiameter / 2.0f) : 0.0f);
    [CATransaction commit];
    
    
    UIBezierPath *pausePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((CGRectGetWidth(self.bounds) / 2.0f) - (ceilf(pauseCircleDiameter + 1) / 2.0f),
                                                                                 (CGRectGetHeight(self.bounds) / 2.0f) - (ceilf(pauseCircleDiameter + 1) / 2.0f),
                                                                                 ceilf(pauseCircleDiameter + 1),
                                                                                 ceilf(pauseCircleDiameter + 1))
                                                         cornerRadius:ceilf(pauseCircleDiameter + 1)];
    
    CGFloat pauseRectHeight = pauseCircleDiameter * PWProgressPauseCircleDiameterHeightRatio;
    CGFloat pauseRectWidth = pauseRectHeight * PWProgressPauseRectHeightWidthRatio;
    CGFloat pauseRectPadding = pauseRectWidth;
    
    [pausePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(roundf((CGRectGetWidth(self.bounds) - ((pauseRectWidth * 2) + pauseRectPadding)) / 2.0f),
                                                                      roundf((CGRectGetHeight(self.bounds) - pauseRectHeight) / 2.0f),
                                                                      roundf(pauseRectWidth),
                                                                      roundf(pauseRectHeight))]];
    
    [pausePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(roundf(((CGRectGetWidth(self.bounds) - ((pauseRectWidth * 2) + pauseRectPadding)) / 2.0f) + pauseRectWidth + pauseRectPadding),
                                                                      roundf((CGRectGetHeight(self.bounds) - pauseRectHeight) / 2.0f),
                                                                      roundf(pauseRectWidth),
                                                                      roundf(pauseRectHeight))]];
    self.pausedShape.path = pausePath.CGPath;
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
            CGFloat minSide = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            
            CGFloat centerHoleDiameter =  minSide - (PWCenterHoleInsetRatio * minSide * 2);
            CGFloat desiredDiameter = 2 * sqrt((powf((CGRectGetWidth(self.bounds) / 2.0f), 2) + powf((CGRectGetHeight(self.bounds) / 2.0f), 2)));
            CGFloat scaleFactor = desiredDiameter / centerHoleDiameter;
            
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.toValue = @(scaleFactor);
            scaleAnimation.duration = PWProgressScaleAnimationDuration;
            scaleAnimation.removedOnCompletion = NO;
            scaleAnimation.autoreverses = NO;
            scaleAnimation.fillMode = kCAFillModeForwards;
            [self.boxShape addAnimation:scaleAnimation forKey:@"transform.scale"];
        }
    }
}

- (void)setPaused:(BOOL)paused
{
    if (paused != _paused) {
        _paused = paused;
        
        if (!_paused) {
            [self setNeedsLayout];
        }
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.pausedShape.hidden = !_paused;
        [CATransaction commit];
        
        if (_paused) {
            [self setNeedsLayout];
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
