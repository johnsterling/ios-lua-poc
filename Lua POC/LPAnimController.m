//
//  LPAnimController.m
//  Lua POC
//
//  Created by John Sterling on 2/15/14.
//  Copyright (c) 2014 Volar Video. All rights reserved.
//

#import "LPAnimController.h"
#import "LPLogicController.h"

@interface LPAnimController ()
{
	LPLogicController *logicController;
}

@end

@implementation LPAnimController

- (BOOL)isAnimating
{
	return logicController.isAnimating;
}

- (void)loadScript:(NSString *)script
{
	
	logicController = [[LPLogicController alloc] initWithScript:script animController:self];
}

- (void)startAnimating
{
	if (logicController && !logicController.isAnimating) {
		[logicController startAnimating];
	}
}

- (void)stopAnimating
{
	if (logicController && logicController.isAnimating) {
		[logicController stopAnimating];
	}
}

- (void)setBackgroundColorRed:(NSNumber *)red green:(NSNumber *)green blue:(NSNumber *)blue
{
	self.viewController.view.backgroundColor = [UIColor colorWithRed:[red floatValue]
															   green:[green floatValue]
																blue:[blue floatValue]
															   alpha:1.0];
}

@end
