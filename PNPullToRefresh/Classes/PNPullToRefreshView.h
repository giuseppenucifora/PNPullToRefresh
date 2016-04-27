//
//  PNPullToRefreshView.h
//
//  Created by Giuseppe Nucifora on 04/27/2016.
//  Copyright (c) 2016 Giuseppe Nucifora. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 `PNPullToRefreshView` is the View for refresh animation.
 
 To be managed by `PNPullToRefresh`, there is no need to work directly with this.
 */
@interface PNPullToRefreshView : UIView

///---------------------
/// @name Setting Properties
///---------------------

/**
 Refresh status.
 */
@property (nonatomic, assign, readonly) BOOL isRefreshing;

/**
 Color of the refresh bar.
 */
@property (nonatomic, strong) UIColor *progressColor;

///---------------------
/// @name Refresh bar staus
///---------------------

/**
 Set the progress of refresh bar.
 
 @param progress Progress of refresh bar.
 */
- (void)setRefreshBarProgress:(CGFloat)progress;

/**
 Return whether progress full.
 */
- (BOOL)isProgressFull;

///---------------------
/// @name Refresh Animation
///---------------------

/**
 Start refresh animation manually. Send to the delegate after the start.
 */
- (void)startRefresh;

/**
 Stop refresh animation.
 */
- (void)finishRefresh;

@end
