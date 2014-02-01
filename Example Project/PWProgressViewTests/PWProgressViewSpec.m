//
//  PWProgressViewSpec.m
//  PWProgressView
//
//  Created by Peter Willsey on 2/1/14.
//  Copyright (c) 2014 Peter Willsey. All rights reserved.
//

#import "Kiwi.h"
#import "PWProgressView.h"

SPEC_BEGIN(PWProgressViewSpec)

describe(@"PWProgressView", ^{
    
    __block PWProgressView *progressView;
    
    beforeEach(^{
        progressView = [[PWProgressView alloc] init];
    });
    
    it(@"Is always square", ^{
        progressView.frame = (CGRect) {
            .origin         = CGPointZero,
            .size.width     = 50.0f,
            .size.height    = 100.0f
        };
        
        [[theValue(CGRectGetWidth(progressView.frame)) should] equal:theValue(CGRectGetHeight(progressView.frame))];
    });
    
    it(@"Pins progress values below 0 to 0", ^{
        progressView.progress = -1.0f;
        
        [[theValue(progressView.progress) should] equal:theValue(0.0f)];
    });
    
    it(@"Pins progress values above 1 to 1", ^{
        progressView.progress = 10.0f;
        
        [[theValue(progressView.progress) should] equal:theValue(1.0f)];
    });
    
    it(@"Sets progress values >= 0 and <= 1 appropriately", ^{
        CGFloat progress = 0.5f;
        
        progressView.progress = progress;
        [[theValue(progressView.progress) should] equal:theValue(progress)];
    });
    
});

SPEC_END