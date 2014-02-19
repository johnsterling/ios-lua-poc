//
//  LPAnimController.h
//  Lua POC
//
//  Created by John Sterling on 2/15/14.
//  Copyright (c) 2014 Volar Video. All rights reserved.
//

// This is the primary app-facing API class

#import <Foundation/Foundation.h>

@interface LPAnimController : NSObject

@property (weak, nonatomic) UIViewController *viewController;
@property (readonly, getter = isAnimating) BOOL animating;

- (void)loadScript:(NSString *)script;

- (void)startAnimating;
- (void)stopAnimating;

- (void)setBackgroundColorRed:(NSNumber *)red green:(NSNumber *)green blue:(NSNumber *)blue;

@end
