//
//  SwipeableCell.m
//  swipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import "SwipeToPeepCell.h"
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>

#define horizontalSensitivy 0.7

@interface SwipeToPeepCell ()

@property (nonatomic) UIView *interactiveBackground;
@property (nonatomic) UIView *content;
@property (nonatomic) BOOL isDragging;


@end

@implementation SwipeToPeepCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.interactiveBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  100)];
        self.interactiveBackground.backgroundColor = [UIColor greenColor];
        self.interactiveBackground.alpha = 0;
        [self insertSubview:self.interactiveBackground atIndex:0];
        
        self.content = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.content];
    }
    return self;
}



- (void)configureSwipeableCell {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
}


- (void)pan:(UIPanGestureRecognizer*)gestureRecognizer {
    
    CGPoint touchLocation = [gestureRecognizer locationInView:nil];
    CGPoint touchVelocity = [gestureRecognizer velocityInView:nil];
    float progress = 1- (touchLocation.x / self.frame.size.width);
        


    if ([self.delegate respondsToSelector:@selector(swipeableCellDidStartSwiping:)] && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.delegate swipeableCellDidStartSwiping:self];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self changeBackgroundColorBasedOnProgress:progress];
        [self.delegate swipeableCell:self didSwipeWithHorizontalPosition:touchLocation.x progress:progress];
        

    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (progress >= horizontalSensitivy || touchVelocity.x < -300) {
            [self.delegate swipeableCellCompletedSwiping:self];
        } else {
            [self.delegate swipeableCellCancelledSwiping:self];
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [self.delegate swipeableCellCancelledSwiping:self];
    }
}



#pragma mark GestureRecognizer magic
         
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer velocityInView:nil];
    
    if (point.x > 0) {
        return NO;
    }
    
    if (fabsf(point.x) > fabsf(point.y) ) {
        return YES;
    }
    
    return NO;
}

#pragma mark Private methods

- (void)changeBackgroundColorBasedOnProgress:(float)progress {
    
    self.interactiveBackground.alpha = progress;
    
}


@end
