-- Taunt automatically every 90s
-- Need to add hook so this only begins when a player spawns, it will continue through rounds. (Sorta Annoying.)
local intervals = 60

timer.Create( "timeLeft", 1, 0, function()
	if IsValid(LocalPlayer()) && LocalPlayer():Team() == 3 then
		local ply = LocalPlayer()
		local timeLeft = getTimeleft(ply) - 1
		setTimeleft(ply, timeLeft )
		if (timeLeft <= 0) then
			RunConsoleCommand("ph_taunt_random")
			-- intervals = math.floor((intervals/2)+(intervals/4)+0.5) -- has a bug that will constantly reduce the time a Taunt will happen, it never resets an eventually will always be 1
			intervals = 60 -- Reset timer to 
			setTimeleft(ply, intervals)
		end
	end
end)

hook.Add("TauntPlayed", "TauntPlayed", function(ply)
	print("hook called")
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

		local txt = "Taunt in " .. timeLeft .. "s"

		local gap = draw.GetFontHeight("RobotoHUD-8")
		surface.SetFont("RobotoHUD-8")
		-- UI Bar Size/Placement
		local w = 166 -- width
		local h = 19 -- height
		
		draw.RoundedBox(5, ScrW() - w - gap - 10, ScrH() - h - gap - 10, w + 20, h + 20, Color(0, 0, 0, 200))
		draw.RoundedBox(5, ScrW() - w - gap - 5, ScrH() - h - gap - 5, (w + 10) * percentage, h + 10, Color(200, 0, 0, 200))
		-- Text Screen Placement
		draw.ShadowText(txt, "RobotoHUD-8", ScrW() - w - gap + 0, ScrH() - h - gap + -6, Color(255,255,255), 0)
	end
end