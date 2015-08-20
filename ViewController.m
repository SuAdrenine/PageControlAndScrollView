//
//  ViewController.m
//  TestPageControl
//
//  Created by xby-mac on 15/8/15.
//  Copyright (c) 2015年 xby-mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*设置图片大小，根据具体图片尺寸自定义*/
    CGFloat imageWidth = 300;
    CGFloat imageHeight = 360;
    
    UIImageView* imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth,imageHeight)];
    [imageView1 setImage:[UIImage imageNamed:@"1.png"]];
    UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(1*imageWidth, 0, imageWidth,imageHeight)];
    [imageView2 setImage:[UIImage imageNamed:@"2.png"]];
    UIImageView* imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(2*imageWidth, 0, imageWidth,imageHeight)];
    [imageView3 setImage:[UIImage imageNamed:@"3.png"]];
    
    /*创建一个刚好能放下图片的scrollView*/
    scrollViews = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 60, imageWidth, imageHeight)];
    /*设置scrollView的尺寸，因为要存放三张图片*/
    [scrollViews setContentSize:CGSizeMake(imageWidth * 3, imageHeight)];
    scrollViews.pagingEnabled = YES;  //设为YES时，会按页滑动，否则就不是一页一页滑动，会出现两张图片各出现一部分的情况
    scrollViews.bounces = YES; //取消UIScrollView的弹性属性，这个可以按个人喜好来定
    [scrollViews setDelegate:self];//UIScrollView的delegate函数在本类中定义
    scrollViews.showsHorizontalScrollIndicator = NO;  //因为我们使用UIPageControl表示页面进度，所以取消UIScrollView自己的进度条。
    scrollViews.showsVerticalScrollIndicator = NO;   //隐藏
    [scrollViews addSubview:imageView3];
    [scrollViews addSubview:imageView2];
    [scrollViews addSubview:imageView1];//将UIImageView添加到UIScrollView中。
    
    [self.view addSubview:scrollViews]; //将UIScrollView添加到主界面上。
    
    //创建UIPageControl
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(150, 390, imageWidth, 20)];
    //pageControl.backgroundColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.numberOfPages = 3;//总的图片页数
    pageControl.currentPage = 0; //当前页
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];  //用户点击UIPageControl的响应函数
    [self.view addSubview:pageControl];  //将UIPageControl添加到主界面上。
   
}

//其次是UIScrollViewDelegate的scrollViewDidEndDecelerating函数，用户滑动页面停下后调用该函数。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageControl setCurrentPage:offset.x / bounds.size.width];  //设置当前页，通过长度来判断
    NSLog(@"%d",(int)(offset.x / bounds.size.width)+1);  //输出当前的是哪页,页数是从0开始
}

//然后是点击UIPageControl时的响应函数pageTurn
- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = scrollViews.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [scrollViews scrollRectToVisible:rect animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
