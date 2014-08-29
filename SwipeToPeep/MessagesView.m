//
//  HNPostWebView.m
//  SwipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import "MessagesView.h"
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>
#import "SpeechBubbleLabel.h"

@interface MessagesView ()

@property (nonatomic) SpeechBubbleLabel *speechBubble;

@end



@implementation MessagesView


- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIScreenEdgePanGestureRecognizer *panEdgeRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panEdgeRecognizer.edges = UIRectEdgeLeft;
    panEdgeRecognizer.delegate = self;
    [self addGestureRecognizer:panEdgeRecognizer];
}

- (void)setConversationText:(NSString *)conversationText {
    self.speechBubble = [[SpeechBubbleLabel alloc] initWithFrame:CGRectInset(self.bounds, 40, 40) andText:conversationText];
    [self addSubview:self.speechBubble];
    
}




- (void)pan:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer {
    
    CGPoint touchLocation = [gestureRecognizer locationInView:nil];
    float progress = touchLocation.x / [UIScreen mainScreen].bounds.size.width;
    NSLog(@"%fl", progress);
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.swipeDelegate postViewDidStartSwiping:self];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self.swipeDelegate postView:self didSwipeWithHorizontalPosition:touchLocation.x progress:progress];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.swipeDelegate postViewCompletedSwiping:self];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [self.swipeDelegate postViewCancelledSwiping:self];
    }
    
    
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}




@end
