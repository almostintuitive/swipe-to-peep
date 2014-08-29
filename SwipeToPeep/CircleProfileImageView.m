//
//  CircleProfileImageView.m
//  SwipeToPeep
//
//  Created by mark on 29/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import "CircleProfileImageView.h"

@implementation CircleProfileImageView

- (void)didMoveToSuperview {
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.layer.masksToBounds = YES;
    [self setNeedsDisplay];
}

@end
