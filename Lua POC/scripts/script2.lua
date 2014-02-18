function startAnimating()
	timer = setTimer(
		function ()
			animController:setBackgroundColor(0, 1, 0)
			timer = nil
		end,
		5
	)
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
