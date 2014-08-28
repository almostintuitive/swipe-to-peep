//
//  PostManager.m
//  SwipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import "HNPostManager.h"

@implementation HNPostManager

+ (instancetype)sharedManager {
    static HNPostManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        [sharedMyManager initPostManager];
    });
    return sharedMyManager;
}


- (void)initPostManager {
    [[HNManager sharedManager] startSession];
}


- (void)fetchPostsWithCompletionHandler:(void (^)(void))completionHandler {
    [[HNManager sharedManager] loadPostsWithFilter:PostFilterTypeTop completion:^(NSArray *posts) {
        if (!posts) {
            NSLog(@"error fetching news");
            HNPost *fakePost = [[HNPost alloc] init];
            fakePost.Title = @"Fake post";
            fakePost.UrlString = @"jweofijwejf";
            self.posts = @[fakePost];
        } else {
            self.posts = posts;
        }
        
        completionHandler();
    }];

}


@end
