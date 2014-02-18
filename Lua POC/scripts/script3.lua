red = 0
blue = .5
green = .75
function inc(name)
	_G[name] = _G[name] + .1
	if _G[name] > 1 then _G[name] = 0 end
end
function startAnimating()
	timer = setTimer(
		function ()
			inc("red")
			inc("blue")
			inc("green")
			animController:setBackgroundColor(red, green, blue)
		end,
		.2,
		true
	)
	animController:setBackgroundColor(red, green, blue)
	isAnimating = true
end
function stopAnimating()
	if timer then
		clearTimer(timer)
		timer = nil
	end
	animController:setBackgroundColor(1, 1, 1)
	isAnimating = false
end
