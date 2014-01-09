//
//  PWMainView.m
//  PWProgressView
//
//  Created by Peter Willsey on 1/8/14.
//  Copyright (c) 2014 Peter Willsey. All rights reserved.
//

#import "PWMainView.h"
#import "PWProgressView.h"

@implementation PWMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
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
    self.progressView.frame = CGRectMake(50.0f,
                                         100.0f,
                                         50.0f,
                                         50.0f);
    
    self.progressSlider.frame = CGRectMake(15.0f,
                                           300.0f,
                                           200.0f,
                                           25.0f);
}

@end
