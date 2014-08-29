//
//  SwipeableCell.h
//  swipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
#import "CircleProfileImageView.h"

@class SwipeToPeepCell;

@protocol SwipeableCellDelegate <NSObject>

@required
- (void)swipeableCellDidStartSwiping:(SwipeToPeepCell *)cell;
- (void)swipeableCellCompletedSwiping:(SwipeToPeepCell *)cell;
- (void)swipeableCellCancelledSwiping:(SwipeToPeepCell *)cell;
- (void)swipeableCell:(SwipeToPeepCell *)cell didSwipeWithHorizontalPosition:(CGFloat)horizontalPosition progress:(float)progress;

@end



@interface SwipeToPeepCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic) UIImage *conversationImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewLabel;
@property (weak, nonatomic) IBOutlet CircleProfileImageView *profileImageView;


@property (nonatomic, assign) id <SwipeableCellDelegate> delegate;
- (void)configureSwipeableCell;

@end
