//
//  LPLogicController.h
//  Lua POC
//
//  Created by John Sterling on 2/14/14.
//  Copyright (c) 2014 Volar Video. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPAnimController;

@interface LPLogicController : NSObject

@property (readonly, getter = isAnimating) BOOL animating;

- (id)initWithScript:(NSString *)script animController:(LPAnimController *)animController;
- (void)startAnimating;
- (void)stopAnimating;

@end
