//
//  ViewController.h
//  swipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeToPeepCell.h"
#import "HNPostView.h"
#import <ChameleonFramework/Chameleon.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SwipeableCellDelegate, HNPostViewDelegate>

@end
