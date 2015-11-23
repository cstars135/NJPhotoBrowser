//
//  NJ_PhotoBrowserVc.m
//  StudyAbroad
//
//  Created by Apple on 15/11/20.
//  Copyright (c) 2015年 WeiKeTimes. All rights reserved.
//

#import "NJ_PhotoBrowserVc.h"
#import "NJ_BrowserCollectionViewCell.h"
#import "NJ_CustomActionSheet.h"
#import "MBProgressHUD.h"
#define HeiTi_Light(fontSize) [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize];

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface NJ_PhotoBrowserVc ()<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong) UICollectionView *browserCollectionView;
@property (nonatomic, assign) BOOL statusBarHiden;

//表示当前滚动到的图片的位置索引
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *deleteImageIndexSet;

@end

@implementation NJ_PhotoBrowserVc
+(instancetype)browserWithImages:(NSArray *)images curIndex:(NSInteger)curIndex{
    return [[self alloc]initWithImages:images curIndex:curIndex];
}

- (instancetype)initWithImages:(NSArray *)images curIndex:(NSInteger)curIndex{
    if (self = [super init]) {
        [self.imageArray addObjectsFromArray:images];
        self.curIndex = curIndex;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor blackColor];
    [self configNav];
    [self browserCollectionView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //将初始位置设置到对应的图片
    CGFloat offsetX = self.curIndex*self.browserCollectionView.bounds.size.width;
    self.browserCollectionView.contentOffset = CGPointMake(offsetX, 0);
    
    //开始时显示导航栏与状态栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.statusBarHiden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:didDeleteImagesAtIndexSet:)]) {
            [self.delegate photoBrowser:self didDeleteImagesAtIndexSet:self.deleteImageIndexSet];
        }
    }
}


-(NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray arrayWithCapacity:9];
    }
    return _imageArray;
}

- (NSMutableArray *)deleteImageIndexSet{
    if (_deleteImageIndexSet == nil) {
        _deleteImageIndexSet = [NSMutableArray arrayWithCapacity:9];
    }
    return _deleteImageIndexSet;
}

- (void)configNav{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x222222);
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = HeiTi_Light(15);
    [leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn sizeToFit];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = HeiTi_Light(15);
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];


}

- (void)leftBtnClicked:(UIButton *) leftBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBtnClicked:(UIButton *) rightBtn{
    //弹actionSheet让用户确认删除操作
    NJ_CustomActionSheet *actionSheet = [[NJ_CustomActionSheet alloc]initWithTitles:@[@"要删除这张照片吗?",@"删除",@"取消"] actionBlock:^(NSInteger selectedIndex) {
        if (selectedIndex == 0) {
            
        }else if(selectedIndex == 1){
            //确认删除
            //延迟删除，等待actionSheet消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //弹删除成功toast
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                
                // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
                // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                
                // Set custom view mode
                HUD.mode = MBProgressHUDModeCustomView;
                
                HUD.delegate = self;
                HUD.labelText = @"已删除";
                
                [HUD show:YES];
                [HUD hide:YES afterDelay:0.2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self deleteImage];
                });
            });
        }else{
           //取消
            [actionSheet dismiss];
        }
    }];

    //设置actionSheet内部按钮
    UIButton *firstBtn = actionSheet.titleBtns[0];
    firstBtn.enabled = NO;
    [firstBtn.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:12]];
    [firstBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    UIButton *secondBtn = actionSheet.titleBtns[1];
    [secondBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [actionSheet show];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
}


#pragma mark - 删除图片
- (void)deleteImage{
    //若是删除最后一张，则删除数组中图片，并且返回
    if(self.imageArray.count == 1){
        [self.imageArray removeLastObject];
        [self.deleteImageIndexSet addObject:@0];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    
    [self.imageArray removeObjectAtIndex:self.curIndex];
    [self.deleteImageIndexSet addObject:@(self.curIndex)];
    NSIndexPath *willDeletedItemIndex = [NSIndexPath indexPathForItem:self.curIndex inSection:0];
    if(self.curIndex == 0){
        [self.browserCollectionView deleteItemsAtIndexPaths:@[willDeletedItemIndex]];
        self.curIndex = 0;
    }else{
        [self.browserCollectionView performBatchUpdates:^{
            [self.browserCollectionView deleteItemsAtIndexPaths:@[willDeletedItemIndex]];
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:--self.curIndex inSection:0];
            [self.browserCollectionView scrollToItemAtIndexPath:toIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        } completion:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter
- (UICollectionView *)browserCollectionView
{
    if (nil == _browserCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _browserCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.bounds.size.width+20, self.view.bounds.size.height) collectionViewLayout:layout];
        _browserCollectionView.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectionViewTapped:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [_browserCollectionView addGestureRecognizer:tapRecognizer];
        
        [_browserCollectionView registerClass:[NJ_BrowserCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([NJ_BrowserCollectionViewCell class])];
        
        _browserCollectionView.delegate = self;
        _browserCollectionView.dataSource = self;
        _browserCollectionView.pagingEnabled = YES;
        _browserCollectionView.showsHorizontalScrollIndicator = NO;
        _browserCollectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_browserCollectionView];
    }
    return _browserCollectionView;
}

- (void)collectionViewTapped:(UITapGestureRecognizer *) tapRecognizer{
    [self performSelector:@selector(toggleNavBar) withObject:nil afterDelay:0.25];
//    [self toggleNavBar];
}

#pragma mark - setter
-(void)setCurIndex:(NSInteger)curIndex{
    //注意index都以0开始，但是现实的序号从1开始，所以需要加1
    _curIndex = curIndex;
    NSString *title = [NSString stringWithFormat:@"%zd/%zd",curIndex+1,self.imageArray.count];
    self.title = title;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"count:%zd",self.imageArray.count);
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NJ_BrowserCollectionViewCell *cell = (NJ_BrowserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NJ_BrowserCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.photoBrowser = self;
    NSLog(@"%@",self.imageArray[indexPath.item]);
    NSLog(@"%@",self.imageArray);
    cell.photo =self.imageArray[indexPath.item];
    return cell;
}

#pragma mark - scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //只要滚动就隐藏导航栏与状态栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.statusBarHiden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //在滚动减速结束后更新索引
    NSInteger curIndex = scrollView.contentOffset.x/scrollView.bounds.size.width;
    self.curIndex = curIndex;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width+20, self.view.bounds.size.height);
}

#pragma mark - 隐藏导航栏与状态栏
-(void)toggleNavBar{
    if (self.navigationController.navigationBarHidden == YES) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.statusBarHiden = NO;
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.statusBarHiden = YES;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

-(BOOL)prefersStatusBarHidden{
    return self.statusBarHiden;
}


@end
