//
//  SpeechBubbleView.m
//  SwipeToPeep
//
//  Created by mark on 29/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import "SpeechBubbleLabel.h"
#import <ChameleonFramework/Chameleon.h>

@implementation SpeechBubbleLabel

- (instancetype)initWithFrame:(CGRect)frame andText:(NSString*)text {
    self = [super initWithFrame:frame];
    if (self) {
        self.text = text;
        self.numberOfLines = 100;
        [self sizeToFit];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}



@end
