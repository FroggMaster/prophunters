--Taunt automatically every 30s
local intervals = 30
local timeLeft = intervals

timer.Create( "timeLeft", 1, 0, function()
	if IsValid(LocalPlayer()) && LocalPlayer():Team() == 3 then
		timeLeft = timeLeft - 1
		if (timeLeft <= 0) then
			RunConsoleCommand("ph_taunt_random")
			timeLeft = intervals
		end
	end
end)

function GM:DrawAutoTaunt()
	if LocalPlayer():Team() == 3 then
		local percentage = timeLeft / intervals

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
