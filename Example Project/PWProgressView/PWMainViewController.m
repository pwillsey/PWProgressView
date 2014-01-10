//
//  PWMainViewController.m
//  PWProgressView
//
//  Created by Peter Willsey on 12/29/2013.
//  Copyright (c) 2013 Peter Willsey. All rights reserved.
//

#import "PWMainViewController.h"
#import "PWMainView.h"
#import "PWProgressView.h"

@interface PWMainViewController ()
@property (nonatomic, strong) PWMainView *mainView;
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

@end
