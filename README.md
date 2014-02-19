# Lua POC

The basic idea here is to implement core business logic in Lua so that it doesn't have to be replicated
in multiple languages.

The basic structure of this demo is:

- `LPAnimController` is the application-facing API
	- In this case, its function is to control animating a view
		- It currently can change the background color
	- It is implemented in the host language
	- It contains the wrapped Lua context
	- Its exposed API consists of:
		- `-loadScript:`
			- Setup method for loading specific Lua code
		- `-startAnimating`
			- Starts the animation cycle
		- `-stopAnimating`
			- Stops the animation cycle
		- `animating`
			- Property indicating animation state
		- `viewController:`
			- Property for setting the view controller that will be animated
	- It exposes this API to its child `LPLogicController`:
		- `-setBackgroundColorRed:blue:green:`
- `LPLogicController` is the wrapper for the Lua context
	- Its function is to provide the logic, in this case colors and timing for the view background color
	- It has 2 parts:
		- A wrapper implemented in the host language
			- Provides initialization methods
			- Provides translation from host language method calls and property accesses to the Lua context
		- A Lua context
			- Provides the common business logic
			- Defines variables and functions accessed by the host language
			- Makes use of functions exposed to it which are implemented
	- It exposes this API to `LPAnimController`:
		- `-initWithScript:animController:`
			- Setup method for loading Lua code and passing a reference to its parent `LPAnimController`
		- `-startAnimating`
			- Starts the animation cycle
			- Translated to function call of `startAnimating()` in the Lua context
				- This requires a wrapper C function
		- `-stopAnimating`
			- Stops the animation cycle
			- Translated to function call of `stopAnimating()` in the Lua context
				- This requires a wrapper C function
		- `animating`
			- Property indicating animation state
			- Translated to variable lookup of `isAnimating` in the Lua context
	- It makes available within its Lua context:
		- `animController`
			- userdata representing its parent `LPAnimController` instance
			- `-setBackgroundColorRed:blue:green:` is translated to `setBackgroundColor()`
		- `setTimer()`
			- function returning a userdata representing an `LPLuaTimer` instance
		- `clearTimer()`
			- function invalidating an `LPLuaTimer` userdata
- `LPLuaTimer` is an `NSTimer` wrapper that encapsulates a Lua context and function reference for callback
	- It is implemented in the host language
	- It is managed by functions created by `LPLogicController`
	- It maintains a reference to a Lua variable by using the registry

Some key things this POC accomplishes:
- Calls Lua functions from the host language
	- `startAnimating()`
	- `stopAnimating()`
- Accesses Lua variable from the host language
	- `isAnimating`
- Maintains references to host language objects in Lua
	- `animController` (`LPAnimController`)
	- `setTimer()`'s return (`LPLuaTimer`)
- Calls host language code from Lua
	- `animController.setBackgroundColor()`
	- `setTimer()`
	- `clearTimer()`
- Maintains references to Lua variables in host language
	- `LPLuaTimer`'s registry reference of callback function
