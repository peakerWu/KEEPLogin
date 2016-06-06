//
//  ViewController.m
//  LunBo
//
//  Created by dev on 16/6/3.
//  Copyright © 2016年 donglian@eastunion.net. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#define width [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) MPMoviePlayerController *mediaPlayer;
@property (weak, nonatomic) IBOutlet UIView *alphaView;


@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FourLabelWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLabelLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdLabelLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FourLabelLeading;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger curent;

@end

@implementation ViewController

- (MPMoviePlayerController *)mediaPlayer
{
    if (!_mediaPlayer) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1.mp4" ofType:nil];
        
        NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
        _mediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        _mediaPlayer.controlStyle = MPMovieControlStyleNone;
        _mediaPlayer.shouldAutoplay = YES;
        _mediaPlayer.repeatMode = MPMovieRepeatModeOne;
        _mediaPlayer.view.frame = self.view.bounds;
        [self.view addSubview:_mediaPlayer.view];
    }
    return _mediaPlayer;

}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    
    self.viewWidth.constant = width * 4;
    self.firstLabelWidth.constant = width;
    self.secondLabelWidth.constant = width;
    self.secondLabelWidth.constant = width;
    self.FourLabelWidth.constant = width;
    
    self.secondLabelLeading.constant = width;
    self.thirdLabelLeading.constant = width * 2;
    self.FourLabelLeading.constant = width * 3;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mediaPlayer play];
    
    
    // 设置alphaView的背景色为clearColor，并添加在mediaPlayerView上面
    self.alphaView.backgroundColor = [UIColor clearColor];
    [self.mediaPlayer.view addSubview:self.alphaView];
    
    
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 添加pageControl的监听方法
    [self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.curent = -1;
    // 添加计时器
    [self setupTimer];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = floor(scrollView.contentOffset.x / width + 0.5);
    
    self.pageControl.currentPage = page;
    
//    NSLog(@"scrollViewDidEndDecelerating=%ld", page);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}

- (void)pageChanged:(UIPageControl *)sender
{
    // scrollView的偏移量
    CGFloat x = width * sender.currentPage;
    
    
//    NSLog(@"%ld, %f", sender.currentPage, x);
    
    self.scrollView.contentOffset = CGPointMake(x, 0);
    
}
- (void)setupTimer
{
    // 添加timer
    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
    
//    [self.timer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
- (void)timerChanged
{
    // timer改变的时候，当前页也发生改变
    int page  = (self.pageControl.currentPage + 1) %4;
    
    self.pageControl.currentPage = page;
    
    [self pageChanged:self.pageControl];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
