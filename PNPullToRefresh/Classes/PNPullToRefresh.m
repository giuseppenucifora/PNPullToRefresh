//
//  PNPullToRefresh.m
//
//  Created by Giuseppe Nucifora on 04/27/2016.
//  Copyright (c) 2016 Giuseppe Nucifora. All rights reserved.
//

#import "PNPullToRefresh.h"
#import <UIDevice-Utils/UIDevice-Hardware.h>

@interface PNPullToRefresh ()
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) id<UITableViewDelegate> tableViewProxyDelegate;

@property (nonatomic, strong) PNPullToRefreshView *refreshView;

@property (nonatomic, assign) BOOL isScrollTopPosition;
@property (nonatomic, assign) BOOL isScrollDragging;
@property (nonatomic, assign) CGFloat scrollingMax;

@property (nonatomic, assign) CGFloat kPregoressWeight;

@end

@implementation PNPullToRefresh

- (id)initWithTableView:(UITableView *)tableView refreshView:(PNPullToRefreshView *)refreshView
{
    return [self initWithTableView:tableView refreshView:refreshView tableViewDelegate:nil];
}

- (id)initWithTableView:(UITableView *)tableView refreshView:(PNPullToRefreshView *)refreshView tableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate
{
    self = [super init];
    if (self) {
        
        
        switch ([[UIDevice currentDevice] deviceFamily]) {
            case UIDeviceFamilyiPhone:
            case UIDeviceFamilyiPod: {
                switch ([[UIDevice currentDevice] orientation]) {
                    case UIDeviceOrientationPortrait:
                    case UIDeviceOrientationPortraitUpsideDown: {
                        
                        _kPregoressWeight =  1.2;
                        
                        break;
                    }
                    case UIDeviceOrientationLandscapeLeft:
                    case UIDeviceOrientationLandscapeRight: {
                        
                        _kPregoressWeight =  1.5;
                        
                        break;
                    }
                    default: {
                        _kPregoressWeight =  1.5;
                        break;
                    }
                }
                break;
            }
            case UIDeviceFamilyiPad: {
                switch ([[UIDevice currentDevice] orientation]) {
                    case UIDeviceOrientationPortrait:
                    case UIDeviceOrientationPortraitUpsideDown: {
                        
                        _kPregoressWeight =  2.2;
                        
                        break;
                    }
                    case UIDeviceOrientationLandscapeLeft:
                    case UIDeviceOrientationLandscapeRight: {
                        
                        _kPregoressWeight =  2.5;
                        
                        break;
                    }
                    default: {
                        _kPregoressWeight =  2.5;
                        break;
                    }
                }
                break;
            }
            default: {
                _kPregoressWeight = 1.8;
                break;
            }
        }
        
        self.tableViewProxyDelegate = tableViewDelegate;
        
        self.tableView = tableView;
        
        self.isScrollTopPosition = YES;
        self.isScrollDragging = NO;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        [self.tableView addGestureRecognizer:pan];
        
        self.refreshView = refreshView;
    }
    
    return self;
}

- (void)startRefresh
{
    if (self.delegate) {
        [self.delegate pullToRefreshDidStart];
    }
    
    [self.refreshView startRefresh];
}

- (void)finishRefresh
{
    [self.refreshView finishRefresh];
}

#pragma mark UIPanGestureRecognizer
- (void)panAction:(UIPanGestureRecognizer *)sender
{
    CGPoint location = [sender translationInView:self.tableView];
    
    if ([self.refreshView isRefreshing]) {
        return;
    }
    
    if (location.y > 0 && self.isScrollTopPosition && self.isScrollDragging) {
        [self.refreshView setRefreshBarProgress:location.y * _kPregoressWeight];
        if (self.scrollingMax < location.y) {
            self.scrollingMax = location.y;
        }
        
        if (self.scrollingMax - 10 > location.y) {
            self.isScrollDragging = NO;
            [self.refreshView setRefreshBarProgress:0];
        }
    }
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UITableViewDelegate <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.tableViewProxyDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.tableViewProxyDelegate scrollViewDidScroll:scrollView];
    }
    
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
    
    if (offset > 0) {
        self.isScrollTopPosition = NO;
        [self.refreshView setRefreshBarProgress:0];
        
        scrollView.bounces = YES;
        
    } else if (offset == 0) {
        self.isScrollTopPosition = YES;
        
        scrollView.bounces = NO;
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.tableViewProxyDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.tableViewProxyDelegate scrollViewDidScrollToTop:scrollView];
    }
    
    self.isScrollTopPosition = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.tableViewProxyDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.tableViewProxyDelegate scrollViewWillBeginDragging:scrollView];
    }
    
    self.isScrollDragging = YES;
    self.scrollingMax = 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.tableViewProxyDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.tableViewProxyDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    if ([self.refreshView isProgressFull]) {
        [self startRefresh];
    }
    
    self.isScrollDragging = NO;
    [self.refreshView setRefreshBarProgress:0];
    
}

#pragma mark - Method Forwarding
- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector] || [self.tableViewProxyDelegate respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([self.tableViewProxyDelegate respondsToSelector:aSelector]) {
        return [(id) self.tableViewProxyDelegate methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.tableViewProxyDelegate respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.tableViewProxyDelegate];
    }
}

@end
