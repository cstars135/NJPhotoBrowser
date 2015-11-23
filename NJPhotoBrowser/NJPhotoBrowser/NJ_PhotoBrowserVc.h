//
//  NJ_PhotoBrowserVc.h
//  StudyAbroad
//
//  Created by Apple on 15/11/20.
//  Copyright (c) 2015年 WeiKeTimes. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NJ_PhotoBrowserVc;
@protocol PhotoBrowserDelegate <NSObject>
@optional
- (void)photoBrowser:(NJ_PhotoBrowserVc *) browser didDeleteImagesAtIndexSet:(NSArray *) deleteImageIndexSet;

@end

@interface NJ_PhotoBrowserVc : UIViewController

@property (nonatomic, weak) id<PhotoBrowserDelegate> delegate;

+ (instancetype)browserWithImages:(NSArray *) images curIndex:(NSInteger) curIndex;
-(void)toggleNavBar;

@end
