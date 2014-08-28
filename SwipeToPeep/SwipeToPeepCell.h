//
//  SwipeableCell.h
//  swipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libHN/libHN.h>

@class SwipeToPeepCell;

@protocol SwipeableCellDelegate <NSObject>

@required
- (void)swipeableCellDidStartSwiping:(SwipeToPeepCell *)cell;
- (void)swipeableCellCompletedSwiping:(SwipeToPeepCell *)cell;
- (void)swipeableCellCancelledSwiping:(SwipeToPeepCell *)cell;
- (void)swipeableCell:(SwipeToPeepCell *)cell didSwipeWithHorizontalPosition:(CGFloat)horizontalPosition progress:(float)progress;

@end



@interface SwipeToPeepCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic) HNPost *post;

@property (nonatomic, assign) id <SwipeableCellDelegate> delegate;
- (void)configureSwipeableCell;

@end
