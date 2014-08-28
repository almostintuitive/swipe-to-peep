//
//  HNPostWebView.h
//  SwipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libHN/libHN.h>

@class HNPostView;

@protocol HNPostViewDelegate <NSObject>

@required
- (void)postViewDidStartSwiping:(HNPostView *)postView;
- (void)postViewCompletedSwiping:(HNPostView *)postView;
- (void)postViewCancelledSwiping:(HNPostView *)postView;
- (void)postView:(HNPostView *)postView didSwipeWithHorizontalPosition:(CGFloat)horizontalPosition progress:(float)progress;

@end


@interface HNPostView : UIWebView <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) id <HNPostViewDelegate> swipeDelegate;


@end
