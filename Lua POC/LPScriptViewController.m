//
//  LPScriptViewController.m
//  Lua POC
//
//  Created by John Sterling on 2/17/14.
//  Copyright (c) 2014 Volar Video. All rights reserved.
//

#import "LPScriptViewController.h"

@implementation LPScriptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.scriptView.editable = self.editable;
	if (self.editable) {
		self.cancelButton.hidden = NO;
	}
	self.scriptView.text = self.script;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

- (void)keyboardDidShow:(NSNotification*)aNotification
{
	NSDictionary* info = [aNotification userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
	self.scriptView.contentInset = contentInsets;
	self.scriptView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
	UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	self.scriptView.contentInset = contentInsets;
	self.scriptView.scrollIndicatorInsets = contentInsets;
}

- (IBAction)done:(id)sender
{
	if (sender != self.cancelButton && self.editable && [self.delegate respondsToSelector:@selector(scriptViewDidEditScript:)]) {
		[self.delegate scriptViewDidEditScript:self.scriptView.text];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
