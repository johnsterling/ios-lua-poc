//
//  LPViewController.m
//  Lua POC
//
//  Created by John Sterling on 2/15/14.
//  Copyright (c) 2014 Volar Video. All rights reserved.
//

#import "LPViewController.h"
#import "LPScriptViewController.h"

@interface LPViewController ()

@property (strong, nonatomic) LPAnimController *animController;

@end

@implementation LPViewController
{
	NSArray *scripts;
	NSString *customScript;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	scripts = @[@"script1", @"script2", @"script3"];
	customScript = @"";
	self.animController = [[LPAnimController alloc] init];
	self.animController.viewController = self;
}

- (IBAction)selectScript:(UISegmentedControl *)sender
{
	if (sender.selectedSegmentIndex == 0) {
		self.customButton.hidden = YES;
		[self.animController loadScript:customScript];
	} else {
		self.customButton.hidden = NO;
		NSString *script = [self scriptForSelected];
		[self.animController loadScript:script];
	}
	self.startStopButton.enabled = YES;
	self.scriptButton.enabled = YES;
}

- (IBAction)custom
{
	customScript = [self scriptForSelected];
	self.scriptControl.selectedSegmentIndex = 0;
	[self selectScript:self.scriptControl];
	[self performSegueWithIdentifier:@"Script" sender:nil];
}

- (IBAction)startStop
{
	if (self.animController.isAnimating) {
		[self.animController stopAnimating];
	} else {
		[self.animController startAnimating];
	}
	if (self.animController.isAnimating) {
		[self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
		self.scriptControl.enabled = NO;
		self.scriptButton.enabled = NO;
		self.customButton.enabled = NO;
	} else {
		[self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
		self.scriptControl.enabled = YES;
		self.scriptButton.enabled = YES;
		self.customButton.enabled = YES;
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	LPScriptViewController *scriptViewController = (LPScriptViewController *)segue.destinationViewController;
	scriptViewController.delegate = self;
	if (self.scriptControl.selectedSegmentIndex == 0) {
		scriptViewController.script = customScript;
		scriptViewController.editable = YES;
	} else {
		scriptViewController.script = [self scriptForSelected];
	}
}

- (void)scriptViewDidEditScript:(NSString *)script
{
	customScript = script;
	[self selectScript:self.scriptControl];
}

- (NSString *)scriptForSelected
{
	NSURL *scriptUrl = [[NSBundle mainBundle] URLForResource:scripts[self.scriptControl.selectedSegmentIndex - 1]
											   withExtension:@"lua"];
	return [NSString stringWithContentsOfURL:scriptUrl
									encoding:NSUTF8StringEncoding
									   error:nil];

}

@end
