//
//  LPLuaTimer.h
//  Lua POC
//
//  Created by John Sterling on 2/17/14.
//  Copyright (c) 2014 Volar Video. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "lua.h"

@interface LPLuaTimer : NSObject

- (id)initWithState:(lua_State *)L functionRef:(int)ref interval:(double)interval repeating:(int)repeating;
- (void)invalidate;

@end
