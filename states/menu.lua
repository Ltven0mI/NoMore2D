menu = {}

-- Callbacks --
function menu.draw()
	ui.push()
		ui.setMode("screen")
		local bw, bh = main.width/10, main.width/30
		if ui.button(main.width/2-bw/2, main.height/2-bh/2, bw, bh, "Play") then state.loadState("game") end
	ui.pop()
end

function menu.stateOpen()

end

function menu.stateClose()

end

return menu