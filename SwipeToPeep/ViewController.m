//
//  ViewController.m
//  swipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import "ViewController.h"
#import <ViewUtils/ViewUtils.h>
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>
#import "SwipeToPeepCell.h"
#import "MessagesView.h"
#import "CircleProfileImageView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) MessagesView *postWebView;
@property (nonatomic) NSArray *threadMsgNamesArray;
@property (nonatomic) NSArray *threadMsgDescriptionArray;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor flatMintColor];
    self.tableView.backgroundColor = [UIColor flatMintColor];
    
    self.threadMsgNamesArray = @[@"Mr Pink", @"Lt Aldo Raine", @"Mr Blonde"];
    self.threadMsgDescriptionArray = @[@"F*** you, White! I didn’t create the situation, I’m just dealin’ with it! You’re acting like a first year f***ing theif – I’m acting like a professional!",
                                       @"Yeah, in a basement. You know, fightin’ in a basement offers a lot of difficulties. Number one being, you’re fightin’ in a basement!",
                                       @"Listen kid, I’m not gonna bulls**t you, all right? I don’t give a good f**k what you know, or don’t know, but I’m gonna torture you anyway, regardless. Not to get information. It’s amusing, to me, to torture a cop. You can say anything you want cause I’ve heard it all before. All you can do is pray for a quick death, which you ain’t gonna get. "];


}



#pragma mark TableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.threadMsgDescriptionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwipeToPeepCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwipeToPeepCell"];
    
    cell.delegate = self;
    
    cell.nameLabel.text = self.threadMsgNamesArray[indexPath.row];
    cell.previewLabel.text = self.threadMsgDescriptionArray[indexPath.row];
    
    cell.profileImageView.image = [UIImage imageNamed:@"profile.png"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell configureSwipeableCell];

    return cell;
    
}


#pragma mark TableView delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}



#pragma mark SwipeableCell delegate

- (void)swipeableCellDidStartSwiping:(SwipeToPeepCell *)cell {
    
    self.postWebView = [[MessagesView alloc] initWithFrame:self.view.bounds];
    self.postWebView.center = CGPointMake(self.view.bounds.size.width+self.view.center.x, self.view.center.y);
    self.postWebView.swipeDelegate = self;
    self.postWebView.conversationText = cell.previewLabel.text;
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
        [self.postWebView removeFromSuperview];
        self.postWebView = nil;
    }];
}


- (void)swipeableCellCompletedSwiping:(SwipeToPeepCell *)cell {
    self.tableView.spring.alpha = 0;
    self.postWebView.spring.center = self.view.center;
    [self.postWebView wireUpView];
}




#pragma mark PostView delegate


- (void)postViewDidStartSwiping:(MessagesView *)postView {
    self.tableView.spring.alpha = 0;
    self.tableView.center = CGPointMake(0, self.view.center.y);
}

- (void)postView:(MessagesView *)postView didSwipeWithHorizontalPosition:(CGFloat)horizontalPosition progress:(float)progress {
    self.tableView.spring.alpha = progress;
    self.tableView.spring.center = CGPointMake(self.view.center.x*progress, self.view.center.y);
    self.postWebView.spring.center = CGPointMake(self.view.center.x+(self.view.bounds.size.width*progress), self.view.center.y);

}


- (void)postViewCancelledSwiping:(MessagesView *)postView {
    self.tableView.spring.alpha = 0;
    self.tableView.spring.center = CGPointMake(0, self.view.center.y);
    self.postWebView.spring.center = self.view.center;

}


- (void)postViewCompletedSwiping:(MessagesView *)postView {
    self.tableView.scrollEnabled = YES;
    
    [NSObject animate:^{
        self.postWebView.spring.center = CGPointMake(self.view.center.x+self.view.bounds.size.width, self.view.center.y);
        self.tableView.spring.alpha = 1;
        self.tableView.spring.center = self.view.center;
    } completion:^(BOOL finished) {
        [self.postWebView removeFromSuperview];
        self.postWebView = nil;
    }];

}




@end
