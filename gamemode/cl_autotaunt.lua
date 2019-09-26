--Taunt automatically every 90s
local intervals = 90

timer.Create( "timeLeft", 1, 0, function()
	if IsValid(LocalPlayer()) && LocalPlayer():Team() == 3 then
		local ply = LocalPlayer()
		local timeLeft = getTimeleft(ply) - 1
		DebugInfo(3, tostring("TIME LEFT (Counter) " .. getTimeleft(ply)))

		setTimeleft(ply, timeLeft )
		if (timeLeft <= 0) then
			RunConsoleCommand("ph_taunt_random")
			setTimeleft(ply, intervals)
		end
	end
end)

hook.Add("TauntPlayed", "TauntPlayed", function(ply)
	DebugInfo(3, tostring("TIME LEFT (PLAYED) " .. getTimeleft(ply)))
	setTimeleft(ply, intervals)
end)

function getTimeleft(ply)
	if not ply.timeLeft then 
		ply.timeLeft = intervals
		setTimeleft(ply, intervals)
	end
	return ply.timeLeft
end

function setTimeleft(ply, nb)
	ply.timeLeft = nb
end

function GM:DrawAutoTaunt()
	local ply = LocalPlayer()
	if ply:Team() == 3 then
		local timeLeft = getTimeleft(ply)
		local percentage = timeLeft / intervals

		DebugInfo(1, tostring("TIME LEFT (DRAW) " .. timeLeft))

		local txt = "Auto taunting in " .. timeLeft .. "s"

		local gap = draw.GetFontHeight("RobotoHUD-8")
		surface.SetFont("RobotoHUD-8")

		local w = 166 -- width
		local h = 19 -- height
		--surface.GetTextSize(txt)
		
		draw.RoundedBox(5, ScrW() - w - gap - 10, ScrH() - h - gap - 10, w + 20, h + 20, Color(0, 0, 0, 200))
		draw.RoundedBox(5, ScrW() - w - gap - 5, ScrH() - h - gap - 5, (w + 10) * percentage, h + 10, Color(200, 0, 0, 200))

		draw.ShadowText(txt, "RobotoHUD-8", ScrW() - w - gap + 20, ScrH() - h - gap + 2, Color(255,255,255), 0)
	end
end
