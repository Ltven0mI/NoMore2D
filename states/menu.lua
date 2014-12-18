menu = {}

-- Callbacks --
function menu.draw()
	ui.push()
		ui.setMode("screen")
		if ui.button(main.width/2, main.height/2, main.width/10, main.height/30, "Play") then state.loadState("game") end
	ui.pop()
end

function menu.stateOpen()

end

function menu.stateClose()

end

return menu