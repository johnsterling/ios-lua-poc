//
//  LPScriptViewController.h
//  Lua POC
//
//  Created by John Sterling on 2/17/14.
//  Copyright (c) 2014 Volar Video. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPViewController.h"

@interface LPScriptViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *scriptView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) LPViewController *delegate;
@property (copy, nonatomic) NSString *script;
@property (nonatomic) BOOL editable;

- (IBAction)done:(id)sender;

@end
