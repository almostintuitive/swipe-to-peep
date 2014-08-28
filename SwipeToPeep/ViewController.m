//
//  ViewController.m
//  swipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import "ViewController.h"
#import <libHN/libHN.h>
#import <ViewUtils/ViewUtils.h>
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>
#import "SwipeToPeepCell.h"
#import "HNPostView.h"
#import "HNPostManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) HNPostView *postWebView;
@property (nonatomic) HNPost *activePost;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Hacker News Top Posts";
    
    [[HNPostManager sharedManager] fetchPostsWithCompletionHandler:^{
        [self.tableView reloadData];
    }];

}



#pragma mark TableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HNPostManager sharedManager].posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwipeToPeepCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwipeToPeepCell"];
    
    if (cell == nil) {
        cell = [[SwipeToPeepCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SwipeToPeepCells"];
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.delegate = self;
    }
    
    HNPost *post = [[HNPostManager sharedManager].posts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = post.Title;
    cell.post = post;
    
    [cell configureSwipeableCell];

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 100.0f;
}


#pragma mark TableView delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}



#pragma mark SwipeableCell delegate

- (void)swipeableCellDidStartSwiping:(SwipeToPeepCell *)cell {
    [HNPostManager sharedManager].activePost = cell.post;
    
    self.postWebView = [[HNPostView alloc] initWithFrame:self.view.bounds];
    self.postWebView.center = CGPointMake(self.view.bounds.size.width+self.view.center.x, self.view.center.y);
    self.postWebView.swipeDelegate = self;
    [self.view addSubview:self.postWebView];
    
    self.tableView.spring.alpha = 1;
    self.tableView.scrollEnabled = NO;
}


- (void)swipeableCell:(SwipeToPeepCell *)cell didSwipeWithHorizontalPosition:(CGFloat)horizontalPosition progress:(float)progress {
    self.tableView.spring.alpha = (1-progress);
    self.tableView.spring.center = CGPointMake(self.view.center.x*(1-progress), self.view.center.y);
    self.postWebView.spring.center = CGPointMake(self.view.center.x+(self.view.bounds.size.width*(1-progress)), self.view.center.y);
}

- (void)swipeableCellCancelledSwiping:(SwipeToPeepCell *)cell {
    self.tableView.scrollEnabled = YES;
    [NSObject animate:^{
        self.tableView.spring.alpha = 1;
        self.tableView.spring.center = self.view.center;
        self.postWebView.spring.center = CGPointMake(self.view.bounds.size.width+self.view.center.x, self.view.center.y);
    } completion:^(BOOL finished) {
        [self.postWebView stopLoading];
        [self.postWebView removeFromSuperview];
        self.postWebView = nil;
    }];
}


- (void)swipeableCellCompletedSwiping:(SwipeToPeepCell *)cell {
    self.tableView.spring.alpha = 0;
    self.postWebView.spring.center = self.view.center;
}




#pragma mark PostView delegate


- (void)postViewDidStartSwiping:(HNPostView *)postView {
    self.tableView.spring.alpha = 0;
    self.tableView.center = CGPointMake(0, self.view.center.y);
}

- (void)postView:(HNPostView *)postView didSwipeWithHorizontalPosition:(CGFloat)horizontalPosition progress:(float)progress {
    self.tableView.spring.alpha = progress;
    self.tableView.spring.center = CGPointMake(self.view.center.x*progress, self.view.center.y);
    self.postWebView.spring.center = CGPointMake(self.view.center.x+(self.view.bounds.size.width*progress), self.view.center.y);

}


- (void)postViewCancelledSwiping:(HNPostView *)postView {
    self.tableView.spring.alpha = 0;
    self.tableView.spring.center = CGPointMake(0, self.view.center.y);
    self.postWebView.spring.center = self.view.center;

}


- (void)postViewCompletedSwiping:(HNPostView *)postView {
    self.tableView.scrollEnabled = YES;
    
    [NSObject animate:^{
        self.postWebView.spring.center = CGPointMake(self.view.center.x+self.view.bounds.size.width, self.view.center.y);
        self.tableView.spring.alpha = 1;
        self.tableView.spring.center = self.view.center;
    } completion:^(BOOL finished) {
        [self.postWebView stopLoading];
        [self.postWebView removeFromSuperview];
        self.postWebView = nil;
    }];

}




@end
