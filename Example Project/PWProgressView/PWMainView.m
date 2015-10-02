//
//  PWMainView.m
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
        self.imageView = [[UIImageView alloc] init];
        self.imageView.layer.cornerRadius = 5.0f;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        self.progressView = [[PWProgressView alloc] init];
        self.progressView.layer.cornerRadius = 5.0f;
        self.progressView.clipsToBounds = YES;
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
    self.imageView.frame = CGRectMake(CGRectGetMidX(self.frame) - (PWProgressViewSize.width / 2.0f),
                                      CGRectGetMidY(self.frame) - (PWProgressViewSize.height / 2.0f),
                                      PWProgressViewSize.width,
                                      PWProgressViewSize.height);
    
    self.progressView.frame = self.imageView.frame;
    
    self.progressSlider.frame = CGRectMake(CGRectGetMidX(self.frame) - (PWProgressSliderSize.width / 2.0f),
                                           CGRectGetMaxY(self.progressView.frame) + PWVerticalSpacing,
                                           PWProgressSliderSize.width,
                                           PWProgressSliderSize.height);
}

@end
