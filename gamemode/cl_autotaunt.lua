--Taunt automatically every 30s
local frequency = 2
local time = 60/(frequency * 2)
timer.Create( "autotaunt", time, 0, function()
	if LocalPlayer():Team() == 3 then
        RunConsoleCommand("ph_taunt_random") 
	end
end )
