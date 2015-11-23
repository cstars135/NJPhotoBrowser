//
//  NJ_DetectTapImageView.m
//  StudyAbroad
//
//  Created by Cstars on 15/11/23.
//  Copyright (c) 2015年 WeiKeTimes. All rights reserved.
//

#import "NJ_DetectTapImageView.h"
@interface NJ_DetectTapImageView()
@property (nonatomic, strong) UITapGestureRecognizer *singleTapRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapRecognizer;

@end

@implementation NJ_DetectTapImageView
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.singleTapRecognizer];
        [self addGestureRecognizer:self.doubleTapRecognizer];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image])) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.singleTapRecognizer];
        [self addGestureRecognizer:self.doubleTapRecognizer];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.singleTapRecognizer];
        [self addGestureRecognizer:self.doubleTapRecognizer];
    }
    return self;
}

-(UITapGestureRecognizer *)singleTapRecognizer{
    if (_singleTapRecognizer == nil) {
        _singleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTapRecognizer.numberOfTapsRequired = 1;
        [_singleTapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];
    }
    return _singleTapRecognizer;
}

-(UITapGestureRecognizer *)doubleTapRecognizer{
    if (_doubleTapRecognizer == nil) {
        _doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTapRecognizer.numberOfTapsRequired = 2;
    }
    return _doubleTapRecognizer;
}


- (void)handleSingleTap:(UITapGestureRecognizer *) recognizer {
    CGPoint location = [recognizer locationInView:self];
    if ([_tapDelegate respondsToSelector:@selector(imageView:singleTapDetected:)])
        [_tapDelegate imageView:self singleTapDetected:location];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *) recognizer {
    CGPoint location = [recognizer locationInView:self];
    if ([_tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)])
        [_tapDelegate imageView:self doubleTapDetected:location];
}



@end
