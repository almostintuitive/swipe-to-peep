//
//  HNPostWebView.h
//  SwipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessagesView;

@protocol MessagesViewDelegate <NSObject>

@required
- (void)postViewDidStartSwiping:(MessagesView *)postView;
- (void)postViewCompletedSwiping:(MessagesView *)postView;
- (void)postViewCancelledSwiping:(MessagesView *)postView;
- (void)postView:(MessagesView *)postView didSwipeWithHorizontalPosition:(CGFloat)horizontalPosition progress:(float)progress;

@end


@interface MessagesView : UIView <UIGestureRecognizerDelegate>

//@property (nonatomic) UIImage *image;
@property (nonatomic, assign) id <MessagesViewDelegate> swipeDelegate;
@property (nonatomic) NSString *conversationText;


@end
