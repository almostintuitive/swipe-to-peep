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
        self.backgroundColor = [UIColor flatGrayColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
    }
    return self;
}



@end
