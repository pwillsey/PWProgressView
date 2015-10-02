//
//  PWProgressViewSpec.m
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

#import "Kiwi.h"
#import "PWProgressView.h"

SPEC_BEGIN(PWProgressViewSpec)

describe(@"PWProgressView", ^{
    
    __block PWProgressView *progressView;
    
    beforeEach(^{
        progressView = [[PWProgressView alloc] init];
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