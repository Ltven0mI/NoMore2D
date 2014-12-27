menu = {}

-- Callbacks --
function menu.drawscreen()
	local bw, bh = main.width/10, main.width/30
	if ui.button(camera.vWindow.w/2-bw/2, camera.vWindow.h/2-bh/2, bw, bh, "Play") then state.loadState("game") end
	if ui.button(camera.vWindow.w/2-bw/2, camera.vWindow.h/2-bh/2+bh+5, bw, bh, "Multiplayer") then state.loadState("game") end
end

function menu.stateOpen()

end

function menu.stateClose()

end

return menu