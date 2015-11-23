//
//  SY_CustomActionSheet.m
//  StudyAbroad
//
//  Created by Apple on 15/11/19.
//  Copyright (c) 2015年 WeiKeTimes. All rights reserved.
//

#import "NJ_CustomActionSheet.h"

#define CommonPading 1
#define LastPading 3
#define RowHeight 44
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SCREEN_W [UIScreen mainScreen].bounds.size.width

@interface NJ_CustomActionSheet()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) Action action;
@property (nonatomic, strong) UIView *cover;
@end


@implementation NJ_CustomActionSheet
- (instancetype)initWithTitles:(NSArray *)titles actionBlock:(Action) action{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        self.titles = titles;
        self.action = action;
        self.titleBtns = [NSMutableArray arrayWithCapacity:4];
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews{

    //根据title个数计算高度
    //每行44，基本间距1    与最后一行间距3
    NSInteger count = self.titles.count;

    CGFloat height = RowHeight*count+(count-2)*CommonPading+LastPading;
    CGFloat width = SCREEN_H;
    //最初在屏幕下方
    CGFloat x = 0;
    CGFloat y = SCREEN_H;
    self.frame = CGRectMake(x, y, width, height);
 
    //根据title个数添加相应个数子视图
    //下面循环添加中，没有添加最后一行，需要特别处理
    CGFloat lastY = 0; //用于记录倒数第二个的y值来计算最后一个
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];

    for(int i = 0; i<count-1; i++){
        CGFloat x = 0;
        CGFloat y = i*(RowHeight+CommonPading);
        CGFloat w = SCREEN_W;
        CGFloat h = RowHeight;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, y, w, h);
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        [btn.titleLabel setFont:font];
        btn.tag = i;
        [btn addTarget:self action:@selector(rowTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.titleBtns addObject:btn];
        if (i == count-2) {
            lastY = btn.frame.origin.y+RowHeight+LastPading;
        }
    }
    UIButton *lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lastBtn.frame = CGRectMake(0, lastY, SCREEN_W, RowHeight);
    [lastBtn setTitle:self.titles[count-1] forState:UIControlStateNormal];
    lastBtn.tag = count-1;
    lastBtn.backgroundColor = [UIColor whiteColor];
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lastBtn.titleLabel setFont:font];
    [lastBtn addTarget:self action:@selector(rowTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lastBtn];
    [self.titleBtns addObject:lastBtn];
}

- (void)rowTapped:(UIButton *) btn{
    if (self.action) {
        self.action(btn.tag);
        [self dismiss];
    }
}



- (void)show{
    //1.给整个窗口添加一个遮盖，并将其透明度动画改变
    
    //2.同时添加actionSheet 并从底部动画弹出
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.cover = cover;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [cover addGestureRecognizer:tapRecognizer];
    [window addSubview:cover];
    
    [window addSubview:self];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        cover.alpha = 0.3;
        CGRect frame = self.frame;
        frame.origin.y = SCREEN_H-frame.size.height;
        self.frame = frame;
    }];
}
- (void)dismiss{
    //动画消失，并且移除
    
    [UIView animateWithDuration:0.25 animations:^{
        self.cover.alpha = 0;
        CGRect frame = self.frame;
        frame.origin.y = SCREEN_H;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self.cover removeFromSuperview];
        [self removeFromSuperview];
    }];
}
@end
