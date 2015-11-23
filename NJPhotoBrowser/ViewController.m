//
//  ViewController.m
//  NJPhotoBrowser
//
//  Created by Apple on 15/11/20.
//  Copyright (c) 2015年 WeiKeTimes. All rights reserved.
//

#import "ViewController.h"
#import "NJ_PhotoBrowserVc.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)browserPhoto:(id)sender {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i<9; i++) {
        NSString *imgName = [NSString stringWithFormat:@"thumb_IMG_00%zd_1024.jpg",i+46];
        UIImage *img = [UIImage imageNamed:imgName];
        [imageArray addObject:img];
    }
    NJ_PhotoBrowserVc *browser = [NJ_PhotoBrowserVc browserWithImages:imageArray curIndex:3];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
