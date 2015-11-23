//
//  NJ_DetectTapImageView.h
//  StudyAbroad
//
//  Created by Cstars on 15/11/23.
//  Copyright (c) 2015年 WeiKeTimes. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DetectTapImageVeiwDelegate;

@interface NJ_DetectTapImageView : UIImageView

@property (nonatomic, weak) id <DetectTapImageVeiwDelegate> tapDelegate;

@end


@protocol DetectTapImageVeiwDelegate <NSObject>

@optional

- (void)imageView:(UIImageView *)imageView singleTapDetected:(CGPoint)location;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(CGPoint)location;

@end

