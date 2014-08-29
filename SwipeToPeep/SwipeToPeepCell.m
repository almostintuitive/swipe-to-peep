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
#import "CircleProfileImageView.h"

#define horizontalSensitivy 0.7

@interface SwipeToPeepCell ()

@property (nonatomic) UIView *interactiveBackground;

@end

@implementation SwipeToPeepCell


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor flatMintColor];
        
        self.interactiveBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  80)];
        self.interactiveBackground.backgroundColor = [UIColor whiteColor];
        self.interactiveBackground.alpha = 0;
        [self insertSubview:self.interactiveBackground atIndex:0];
        
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        
        self.previewLabel.textColor = [UIColor whiteColor];
        self.previewLabel.backgroundColor = [UIColor clearColor];
        

        
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
        [self changeBackgroundColorBasedOnProgress:1];
        [self.delegate swipeableCellDidStartSwiping:self];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self changeBackgroundColorBasedOnProgress:progress];
        [self.delegate swipeableCell:self didSwipeWithHorizontalPosition:touchLocation.x progress:progress];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self changeBackgroundColorBasedOnProgress:0];
        if (progress >= horizontalSensitivy || touchVelocity.x < -300) {
            [self.delegate swipeableCellCompletedSwiping:self];
        } else {
            [self.delegate swipeableCellCancelledSwiping:self];
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [self changeBackgroundColorBasedOnProgress:0];
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


- (void)didMoveToSuperview {
    self.interactiveBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  self.bounds.size.height)];
    self.interactiveBackground.backgroundColor = [UIColor whiteColor];
    self.interactiveBackground.alpha = 0;
    [self insertSubview:self.interactiveBackground atIndex:0];
}


@end
