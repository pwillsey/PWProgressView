//
//  PWMainViewController.m
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

#import "PWMainViewController.h"
#import "PWMainView.h"
#import "PWProgressView.h"

@interface PWMainViewController ()
@property (nonatomic, strong) PWMainView *mainView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation PWMainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mainView.imageView.image = [UIImage imageNamed:@"dog"];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(progressViewTapped:)];
    [self.mainView.progressView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)loadView
{
    self.mainView = [[PWMainView alloc] init];
    [self.mainView.progressSlider addTarget:self
                                     action:@selector(setProgress:)
                           forControlEvents:UIControlEventValueChanged];
    
    self.view = self.mainView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProgress:(id)sender
{
    float progress = self.mainView.progressSlider.value;
    
    [self.mainView.progressView setProgress:progress];
}

- (void)progressViewTapped:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.mainView.progressView.paused = !self.mainView.progressView.paused;
    }
}

@end
