//
//  LPLuaTimer.m
//  Lua POC
//
//  Created by John Sterling on 2/17/14.
//  Copyright (c) 2014 Volar Video. All rights reserved.
//

#import "LPLuaTimer.h"
#include "lauxlib.h"

@implementation LPLuaTimer
{
	lua_State *L;
	int ref;
	NSTimer *timer;
}

- (id)initWithState:(lua_State *)_L functionRef:(int)_ref interval:(double)interval repeating:(int)repeating
{
	if (self = [super init]) {
		L = _L;
		ref = _ref;
		timer = [NSTimer scheduledTimerWithTimeInterval:interval
												 target:self
											   selector:@selector(fireTimer)
											   userInfo:nil
												repeats:repeating];
	}
	return self;
}

- (void)dealloc
{
	luaL_unref(L, LUA_REGISTRYINDEX, ref);
}

- (void)invalidate
{
	[timer invalidate];
}

- (void)fireTimer
{
	lua_rawgeti(L, LUA_REGISTRYINDEX, ref);
	if (lua_pcall(L, 0, 0, 0)) {
		NSLog(@"error calling timer function: %s", lua_tostring(L, -1));
		lua_pop(L, 1);
	}
}

@end
