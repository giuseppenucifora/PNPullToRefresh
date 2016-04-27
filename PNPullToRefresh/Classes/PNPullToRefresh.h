//
//  PNPullToRefresh.h
//
//  Created by Giuseppe Nucifora on 04/27/2016.
//  Copyright (c) 2016 Giuseppe Nucifora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNPullToRefreshView.h"

/**
 `PNPullToRefreshDelegate` protocol defines the methods a delegate of a `PNPullToRefresh`.
 */
@protocol PNPullToRefreshDelegate <NSObject>

/**
 Sent to the delegate at the start of refresh animation.
 */
- (void)pullToRefreshDidStart;
@end

/**
 `PNPullToRefresh` is management view and delegate.
 
 UI Component like ActionBar-PullToRefresh of Android for iOS.
 */
@interface PNPullToRefresh : NSObject <UITableViewDelegate, UIGestureRecognizerDelegate>

///---------------------
/// @name Setting Properties
///---------------------

/**
 The receiver’s delegate
 */
@property (nonatomic, weak) id<PNPullToRefreshDelegate> delegate;

///---------------------
/// @name Initialization
///---------------------

/**
 Create and return instance of not necessary to UITableViewDelegate. Will not be processed for UITableViewDelegate.
 
 @param tableView UITableView that should be subject to the pull to refresh.
 @param refreshView View for refresh animation.
 */
- (id)initWithTableView:(UITableView *)tableView refreshView:(PNPullToRefreshView *)refreshView;

/**
 Create and return instance for processing UITableViewDelegate.

 @param tableView UITableView that should be subject to the pull to refresh.
 @param refreshView View for refresh animation.
 @param tableViewDelegate Receiver for processing UITableViewDelegate.
 */
- (id)initWithTableView:(UITableView *)tableView refreshView:(PNPullToRefreshView *)refreshView tableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate;

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
