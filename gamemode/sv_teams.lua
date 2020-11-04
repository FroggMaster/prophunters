

function GM:TeamsSetupPlayer(ply)
	local cops = team.NumPlayers(2)
	local robbers = team.NumPlayers(3)
	if robbers <= cops then
		ply:SetTeam(3)
	else
		ply:SetTeam(2)
	end
end

concommand.Add("car_jointeam", function (ply, com, args)
	local curteam = ply:Team()
	local newteam = tonumber(args[1] or "") or 0
	if newteam == 1 && curteam != 1 then

		ply:SetTeam(newteam)
		if ply:Alive() then
			ply:Kill()
		end
		local ct = ChatText()
		ct:Add(ply:Nick())
		ct:Add(" changed team to ")
		ct:Add(team.GetName(newteam), team.GetColor(newteam))
		ct:SendAll()

	elseif newteam >= 2 && newteam <= 3 && newteam != curteam then

		// make sure we can't join the bigger team
		local otherteam = newteam == 2 and 3 or 2
		if team.NumPlayers(newteam) <= team.NumPlayers(otherteam) then
			ply:SetTeam(newteam)
			if ply:Alive() then
				ply:Kill()
			end
			local ct = ChatText()
			ct:Add(ply:Nick())
			ct:Add(" changed team to ")
			ct:Add(team.GetName(newteam), team.GetColor(newteam))
			ct:SendAll()
		else
			local ct = ChatText()
			ct:Add("Team full, you cannot join")
			ct:Send(ply)
		end

	end

end)

function GM:CheckTeamBalance()
	if !self.TeamBalanceCheck || self.TeamBalanceCheck < CurTime() then
		self.TeamBalanceCheck = CurTime() + 3 * 60 // check every 3 minutes

		local diff = team.NumPlayers(2) - team.NumPlayers(3)
		if diff < -1 || diff > 1 then // teams must be off by more than 2 for team balance
			self.TeamBalanceTimer = CurTime() + 30 // balance in 30 seconds
			for k,ply in pairs(player.GetAll()) do
				ply:ChatPrint("Auto team balance in 30 seconds")
			end
		end
	end
	if self.TeamBalanceTimer && self.TeamBalanceTimer < CurTime() then
		self.TeamBalanceTimer = nil
		self:BalanceTeams()
	end
end

function GM:BalanceTeams(nokill)
	local diff = team.NumPlayers(2) - team.NumPlayers(3)
	if diff < -1 || diff > 1 then // teams must be off by more than 2 for team balance
		local biggerTeam, smallerTeam = 3,2
		if diff > 0 then
			biggerTeam = 2
			smallerTeam = 3
		end
		diff = team.NumPlayers(biggerTeam) - team.NumPlayers(smallerTeam)
		while diff > 1 do
			local players = team.GetPlayers(biggerTeam)
			local ply = players[math.random(#players)]
			ply:SetTeam(smallerTeam)
			if !nokill && ply:Alive() then
				ply:Kill()
			end
			local ct = ChatText()
			ct:Add(ply:Nick())
			ct:Add(" team balanced to ")
			ct:Add(team.GetName(smallerTeam), team.GetColor(smallerTeam))
			ct:SendAll()
			diff = diff - 2
		end
	end
end

-- Old Team Management Function
--[[function GM:SwapTeams()
	for k, ply in pairs(player.GetAll()) do
		if ply:Team() == 2 then
			ply:SetTeam(3)
		elseif ply:Team() == 3 then
			ply:SetTeam(2)
		end
	end
	local ct = ChatText()
	ct:Add("Teams have been swapped", Color(50, 220, 150))
	ct:SendAll()
end]]--

function GM:SwapTeams()

for k, ply in pairs(player.GetAll()) do
if ply:Team() == 2 then
ply:SetTeam(3)
end
end

print(#team.GetPlayers(2))

local ct = ChatText()
local maxhunters = 2 -- HuntersMax = Number + 1
local hunters = #team.GetPlayers(2)

-- The variable nbmaxhunters define how much hunters you want
-- If yo want only 1 hunter, set it to 0 (trust me, it's because of my bad code)
-- If you want 2 hunters, set it to 1. If you want 3 hunters, set it to 2...
-- Use this mathematic formula if you're not sure
-- HowMuchHuntersYouWant - 1 = nbmaxhunters

local nbmaxhunters = 0


if hunters != maxhunters then -- Bug fixed, weird use of repeat loop

print("Not Enough Hunters!")

for h=0, nbmaxhunters do

local randomprop = table.Random(team.GetPlayers(3))
local randomprop_str = tostring(randomprop)

randomprop:SetTeam(2)
randomprop:Spawn()

-- I believe this is where the bug is that causes nbmaxhunters to increase by one
local h = h + 1

print("Number of Hunters: " .. randomprop_str )

print(h)

end

print("")
print("New Number of Hunters: " .. #team.GetPlayers(2))

end

end
