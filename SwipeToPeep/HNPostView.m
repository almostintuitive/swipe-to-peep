//
//  HNPostWebView.m
//  SwipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import "HNPostView.h"
#import "HNPostManager.h"
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>


@interface HNPostView ()

@property (nonatomic) UIView *loadingOverlay;
@property (nonatomic) UILabel *postTitle;

@end

@implementation HNPostView


- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.backgroundColor = [UIColor redColor];
    
    self.delegate = self;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[HNPostManager sharedManager].activePost.UrlString]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) [self loadRequest:request];
         else if (error != nil) NSLog(@"Error: %@", error);
     }];
    
    
    self.loadingOverlay = [[UIView alloc] initWithFrame:self.bounds];
    self.loadingOverlay.backgroundColor = [UIColor blackColor];
    self.loadingOverlay.alpha = 0.5;
    [self addSubview:self.loadingOverlay];
        
    self.postTitle = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 40, 40)];
    self.postTitle.textColor = [UIColor whiteColor];
    self.postTitle.textAlignment = NSTextAlignmentCenter;
    self.postTitle.text = [HNPostManager sharedManager].activePost.Title;
    self.postTitle.numberOfLines = 5;
    [self addSubview:self.postTitle];
    
    UIScreenEdgePanGestureRecognizer *panEdgeRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panEdgeRecognizer.edges = UIRectEdgeLeft;
    panEdgeRecognizer.delegate = self;
    [self addGestureRecognizer:panEdgeRecognizer];
    
    
}


- (void)pan:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer {
    
    CGPoint touchLocation = [gestureRecognizer locationInView:nil];
    float progress = touchLocation.x / [UIScreen mainScreen].bounds.size.width;
    NSLog(@"%fl", progress);
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.scrollView.scrollEnabled = NO;
        [self.swipeDelegate postViewDidStartSwiping:self];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self.swipeDelegate postView:self didSwipeWithHorizontalPosition:touchLocation.x progress:progress];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.scrollView.scrollEnabled = YES;
        [self.swipeDelegate postViewCompletedSwiping:self];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        self.scrollView.scrollEnabled = YES;
        [self.swipeDelegate postViewCancelledSwiping:self];
    }
    
    
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [NSObject animate:^{
        self.loadingOverlay.easeInEaseOut.alpha = 0;
        self.postTitle.easeInEaseOut.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loadingOverlay removeFromSuperview];
        [self.postTitle removeFromSuperview];
    }];
    

}

@end
