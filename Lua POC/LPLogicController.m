//
//  LPLogicController.m
//  Lua POC
//
//  Created by John Sterling on 2/14/14.
//  Copyright (c) 2014 Volar Video. All rights reserved.
//

#import "LPLogicController.h"
#import "LPAnimController.h"
#import "LPLuaTimer.h"
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

@implementation LPLogicController
{
	LPAnimController *animController;
	lua_State *L;
}

- (id)initWithScript:(NSString *)string animController:(LPAnimController *)controller
{
	if (self = [super init]) {

		// new Lua context
		L = luaL_newstate();
		luaL_openlibs(L);

		// LPAnimController "class"
		luaL_newmetatable(L, "LPAnimController");

		lua_pushstring(L, "__index");
		lua_pushvalue(L, -2);
		lua_settable(L, -3); // metatable.__index = metatable

		lua_pushstring(L, "setBackgroundColor");
		lua_pushcfunction(L, animController_setBackgroundColor);
		lua_settable(L, -3); // metatable.setBackgroundColor

		lua_pop(L, 1); // LPAnimController

		// animController property
		animController = controller;
		if (controller) {
			void **userdata = lua_newuserdata(L, sizeof(LPAnimController *));
			*userdata = (__bridge void *)(controller);
			luaL_getmetatable(L, "LPAnimController");
			lua_setmetatable(L, -2);
		} else {
			lua_pushnil(L);
		}
		lua_setglobal(L, "animController");
		
		// LPLuaTimer "class"
		luaL_newmetatable(L, "LPLuaTimer");
		lua_pop(L, 1);

		// setTimer function
		lua_pushcfunction(L, setTimer);
		lua_setglobal(L, "setTimer");

		// cancelTimer function
		lua_pushcfunction(L, clearTimer);
		lua_setglobal(L, "clearTimer");

		// run script
		int error = luaL_loadbuffer(L,
									[string cStringUsingEncoding:NSUTF8StringEncoding],
									[string length],
									"LPLogicController")
		         || lua_pcall(L, 0, 0, 0);
		if (error) {
			NSLog(@"Failed initing Lua: %s", lua_tostring(L, -1));
			lua_pop(L, 1);
		}
	}
	return self;
}

- (void)dealloc
{
	lua_close(L);
}

- (BOOL)isAnimating
{
	lua_getglobal(L, "isAnimating");
	BOOL result = lua_toboolean(L, -1);
	lua_pop(L, 1);
	return result;
}

- (void)startAnimating
{
	lua_getglobal(L, "startAnimating");
	if (!lua_isfunction(L, -1)) {
		NSLog(@"startAnimating is not a function");
		lua_pop(L, 1);
		return;
	}
	if (lua_pcall(L, 0, 0, 0)) {
		NSLog(@"error calling startAnimating(): %s", lua_tostring(L, -1));
		lua_pop(L, 1);
	}
}

- (void)stopAnimating
{
	lua_getglobal(L, "stopAnimating");
	if (!lua_isfunction(L, -1)) {
		NSLog(@"stopAnimating is not a function");
		lua_pop(L, 1);
		return;
	}
	if (lua_pcall(L, 0, 0, 0)) {
		NSLog(@"error calling stopAnimating(): %s", lua_tostring(L, -1));
		lua_pop(L, 1);
	}
}

static int animController_setBackgroundColor(lua_State *L)
{
	void **ptr = luaL_checkudata(L, 1, "LPAnimController");
	LPAnimController *animController = (__bridge LPAnimController *)(*ptr);
	[animController setBackgroundColorRed:@(lua_tonumber(L, 2))
									green:@(lua_tonumber(L, 3))
									 blue:@(lua_tonumber(L, 4))];
	return 0;
}

static int setTimer(lua_State *L)
{
	luaL_checktype(L, 1, LUA_TFUNCTION);
	luaL_checknumber(L, 2);
	lua_pushvalue(L, 1);
	int funcRef = luaL_ref(L, LUA_REGISTRYINDEX);
	LPLuaTimer *timer = [[LPLuaTimer alloc] initWithState:L
											  functionRef:funcRef
												 interval:lua_tonumber(L, 2)
												repeating:lua_toboolean(L, 3)];
	void **userdata = lua_newuserdata(L, sizeof(LPLuaTimer *));
	*userdata = (__bridge void *)(timer);
	luaL_getmetatable(L, "LPLuaTimer");
	lua_setmetatable(L, -2);
	return 1;
}

static int clearTimer(lua_State *L)
{
	void **ptr = luaL_checkudata(L, 1, "LPLuaTimer");
	LPLuaTimer *timer = (__bridge LPLuaTimer *)(*ptr);
	[timer invalidate];
	return 0;
}

@end
