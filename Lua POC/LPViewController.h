//
//  LPViewController.h
//  Lua POC
//
//  Created by John Sterling on 2/15/14.
//  Copyright (c) 2014 Volar Video. All rights reserved.
//

// This is the view controller for the main Lua POC view

#import <UIKit/UIKit.h>
#import "LPAnimController.h"

@interface LPViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UIButton *scriptButton;
@property (weak, nonatomic) IBOutlet UIButton *customButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scriptControl;

@property (readonly, nonatomic) LPAnimController *animController;

- (IBAction)selectScript:(UISegmentedControl *)sender;
- (IBAction)custom;
- (IBAction)startStop;

- (void)scriptViewDidEditScript:(NSString *)scriptString;

@end
