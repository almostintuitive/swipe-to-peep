//
//  PostManager.h
//  SwipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libHN/libHN.h>

@interface HNPostManager : NSObject

@property (nonatomic) NSArray *posts;
@property (nonatomic) HNPost *activePost;

+ (instancetype)sharedManager;

- (void)fetchPostsWithCompletionHandler:(void (^)(void))completionHandler;

@end
