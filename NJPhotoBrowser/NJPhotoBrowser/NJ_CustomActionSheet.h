//
//  SY_CustomActionSheet.h
//  StudyAbroad
//
//  Created by Apple on 15/11/19.
//  Copyright (c) 2015年 WeiKeTimes. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Action)(NSInteger selectedIndex);


@interface NJ_CustomActionSheet : UIView

//提供内部的UIButton 引用，一边修改字体颜色及大小
@property (nonatomic, strong) NSMutableArray *titleBtns;

- (instancetype)initWithTitles:(NSArray *)titles actionBlock:(Action) action;
- (void)show;
- (void)dismiss;
@end
