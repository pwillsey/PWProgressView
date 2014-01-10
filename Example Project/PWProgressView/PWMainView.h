//
//  PWMainView.h
//  PWProgressView
//
//  Created by Peter Willsey on 1/8/14.
//  Copyright (c) 2014 Peter Willsey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWProgressView;

@interface PWMainView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PWProgressView *progressView;
@property (nonatomic, strong) UISlider *progressSlider;

@end
