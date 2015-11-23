//
//  NJ_BrowserCollectionViewCell.h
//  NJPhotoBrowser
//
//  Created by Apple on 15/11/20.
//  Copyright (c) 2015年 WeiKeTimes. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NJ_PhotoBrowserVc;
@interface NJ_BrowserCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) NJ_PhotoBrowserVc *photoBrowser;

@property (nonatomic, strong) UIImage *photo;

@end
