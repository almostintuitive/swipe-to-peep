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
#import <ChameleonFramework/Chameleon.h>


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
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectInset(self.speechBubble.frame, -10,-10)];
    background.backgroundColor = [UIColor flatGrayColor];
    background.layer.masksToBounds = YES;
    background.layer.cornerRadius = 5;
    [self insertSubview:background atIndex:0];
    
}




- (void)pan:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer {
    
    CGPoint touchLocation = [gestureRecognizer locationInView:nil];
    float progress = touchLocation.x / [UIScreen mainScreen].bounds.size.width;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.swipeDelegate postViewDidStartSwiping:self];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self.swipeDelegate postView:self didSwipeWithHorizontalPosition:touchLocation.x progress:progress];
    
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"messagesView: UIGestureRecognizerStateEnded");
        [self.swipeDelegate postViewCompletedSwiping:self];
    }
    
    
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}




@end
