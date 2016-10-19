//
//  ViewController.m
//  TestPageControl
//
//  Created by xby-mac on 15/8/15.
//  Copyright (c) 2015年 xby-mac. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController (){
    UIButton *_button;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadScrollVew];
    [self loadPageControl];
    [self showButton];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    //根据scrollView 的位置对page 的当前页赋值
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    page.currentPage = current;
    
    //当显示到最后一页时，让滑动图消失
//    if (page.currentPage == 0 || page.currentPage ==1) {
//        [self disappearButton];
//    }
//    if (page.currentPage == 2) {
//        
//        //调用方法，使滑动图消失
//        [self showButton];
//    }
}

- (void)pageTurn:(UIPageControl*)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
-(void)loadScrollVew {
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_scrollView];
    
    //设置UIScrollView 的显示内容的尺寸，有n张图要显示，就设置 屏幕宽度*n ，这里假设要显示3张图
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, [UIScreen mainScreen].bounds.size.height);
    
    _scrollView.tag = 101;
    
    //设置翻页效果，不允许反弹，不显示水平滑动条，设置代理为自己
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    //在UIScrollView 上加入 UIImageView
    for (int i = 0 ; i < 3; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i , 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        //将要加载的图片放入imageView 中
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",i+1]];
        imageView.image = image;
        
        [_scrollView addSubview:imageView];
    }
}

-(void)loadPageControl {
    //初始化 UIPageControl 和 _scrollView 显示在 同一个页面中
    _pageControl = [UIPageControl new];
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = 3;//设置pageConteol 的page 和 _scrollView 上的图片一样多
    _pageControl.tag = 201;
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-5);
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.centerX.equalTo(self.view);
    }];

}

-(void)showButton {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scrollView addSubview:_button];
    
    _button.tag = 101;
    [_button setTitle:@"立即体验" forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor clearColor];
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    [_button.layer setBorderWidth:1];//设置边界的宽度
    [_button.layer setBorderColor:color];//设置边界的颜色
    
    /*可以这样直接计算
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width, screenHeight = [UIScreen mainScreen].bounds.size.height;
    _button.frame = CGRectMake(screenWidth * 2.5 - 50, screenHeight - 70, 100, 40);
    */
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.centerX.equalTo(_scrollView).offset([UIScreen mainScreen].bounds.size.width*2);    //这里如果是相对于self.view会有问题
        make.bottom.equalTo(self.view).offset(-30); //这里如果是相对于_scrollView的底部会有问题
    }];
}

-(void)scrollViewDisappear{
    
    //拿到 view 中的 UIScrollView 和 UIPageControl
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:101];
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    
    //设置滑动图消失的动画效果图
    [UIView animateWithDuration:3.0f animations:^{
        
        scrollView.center = CGPointMake(self.view.frame.size.width/2, 1.5 * self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [scrollView removeFromSuperview];
        [page removeFromSuperview];
    }];
    
    //将滑动图启动过的信息保存到 NSUserDefaults 中，使得第二次不运行滑动图
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"isScrollViewAppear"];
}

-(void)disappearButton {
    if (_button) {
        [_button removeFromSuperview];
    }
}
@end
