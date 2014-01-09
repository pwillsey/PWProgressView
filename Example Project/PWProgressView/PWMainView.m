//
//  PWMainView.m
//  PWProgressView
//
//  Created by Peter Willsey on 1/8/14.
//  Copyright (c) 2014 Peter Willsey. All rights reserved.
//

#import "PWMainView.h"
#import "PWProgressView.h"

static const CGSize PWProgressViewSize      = {100.0f, 100.0f};
static const CGSize PWProgressSliderSize    = {300.0f, 34.0f};
static const CGFloat PWVerticalSpacing      = 20.0f;

@implementation PWMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progressView = [[PWProgressView alloc] init];
        [self addSubview:self.progressView];
        
        self.progressSlider = [[UISlider alloc] init];
        self.progressSlider.minimumValue = 0.0f;
        self.progressSlider.maximumValue = 1.0f;
        self.progressSlider.continuous = YES;
        [self addSubview:self.progressSlider];
    }
    return self;
}

- (void)layoutSubviews
{
    self.progressView.frame = CGRectMake(CGRectGetMidX(self.frame) - (PWProgressViewSize.width / 2.0f),
                                         CGRectGetMidY(self.frame) - (PWProgressViewSize.height / 2.0f),
                                         PWProgressViewSize.width,
                                         PWProgressViewSize.height);
    
    self.progressSlider.frame = CGRectMake(CGRectGetMidX(self.frame) - (PWProgressSliderSize.width / 2.0f),
                                           CGRectGetMaxY(self.progressView.frame) + PWVerticalSpacing,
                                           PWProgressSliderSize.width,
                                           PWProgressSliderSize.height);
}

@end
