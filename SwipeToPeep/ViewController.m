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
@property (nonatomic) NSArray *threadMsgProfileImagesArray;
@property (nonatomic) NSArray *threadMsgNamesArray;
@property (nonatomic) NSArray *threadMsgDescriptionArray;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.threadMsgProfileImagesArray = @[[UIImage imageNamed:@"mrblonde.jpg"], [UIImage imageNamed:@"mrblue.jpg"], [UIImage imageNamed:@"mrbrown.jpg"], [UIImage imageNamed:@"mrorange.jpg"], [UIImage imageNamed:@"mrwhite.jpg"]];
    self.threadMsgNamesArray = @[@"Mr Blonde", @"Mr Blue", @"Mr Brown", @"Mr Orange", @"Mr White"];
    self.threadMsgDescriptionArray = @[@"Are you gonna bark all day, little doggie, or are you gonna bite?",
                                       @"You know what these chicks make? They make shit.",
                                       @"Let me tell you what 'Like a Virgin' is about. It's all about a girl who digs a guy with a big dick. The entire song. It's a metaphor for big dicks.",
                                       @"German shepherd starts barking. He's barking at me. I mean, it's obvious. He's barking at me. Every nerve-ending, all my senses, blood in my veins, everything I have is screaming, 'Take off, man! Just bail, just get the fuck out of there!' Panic hits me like a bucket of water. First there's the shock of it--BAM, right in the face. I'm standing there drenched in panic. All these sheriffs looking at me, and they know, man. They can smell it. Sure as that fucking dog can, they can smell it on me.",
                                       @"When you're dealing with a store like this, they're insured up the ass. They're not supposed to give you any resistance whatsoever. If you get a customer, or an employee, who thinks he's Charles Bronson, take the butt of your gun and smash their nose in. Everybody jumps. He falls down screaming, blood squirts out of his nose, nobody says fucking shit after that. You might get some bitch talk shit to you, but give her a look like you're gonna smash her face next, watch her shut the fuck up. Now if it's a manager, that's a different story. Managers know better than to fuck around, so if you get one that's giving you static, he probably thinks he's a real cowboy, so you gotta break that son of a bitch in two. If you wanna know something and he won't tell you, cut off one of his fingers. The little one. Then tell him his thumb's next. After that he'll tell you if he wears ladies underwear. … I'm hungry. Let's get a taco."];


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
    
    cell.profileImageView.image = self.threadMsgProfileImagesArray[indexPath.row];
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
    [self adjustViewBasedOnSwipeProgress:(1-progress)];
}

- (void)swipeableCellCancelledSwiping:(SwipeToPeepCell *)cell {
    [self showTableView];
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
    [self adjustViewBasedOnSwipeProgress:progress];
}


- (void)postViewCancelledSwiping:(MessagesView *)postView {
    self.tableView.spring.alpha = 0;
    self.tableView.spring.center = CGPointMake(0, self.view.center.y);
    self.postWebView.spring.center = self.view.center;

}


- (void)postViewCompletedSwiping:(MessagesView *)postView {
    [self showTableView];
}



#pragma mark Adjust view based on progress

- (void)adjustViewBasedOnSwipeProgress:(float)progress {
    self.tableView.spring.alpha = progress;
    self.tableView.spring.center = CGPointMake(self.view.center.x*progress, self.view.center.y);
    self.postWebView.spring.center = CGPointMake(self.view.center.x+(self.view.bounds.size.width*progress), self.view.center.y);
}

- (void)showTableView {
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

@end
