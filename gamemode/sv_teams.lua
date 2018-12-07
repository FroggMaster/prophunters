function GM:TeamsSetupPlayer(ply)
	local cops = team.NumPlayers(2)
	local robbers = team.NumPlayers(3)
	if cops >= 1 then
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
		
		local ct = ChatText()
		ct:Add("Team full, you cannot join")
		ct:Send(ply)
		
	end
	
end)

function GM:CheckTeamBalance()
	if !self.TeamBalanceCheck || self.TeamBalanceCheck < CurTime() then
		self.TeamBalanceCheck = CurTime() + 3 * 60 // check every 3 minutes
		
		local hunter = team.NumPlayers(2)
		if hunter > 1 then // Il doit y avoir un seul hunter
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
	local hunter = team.NumPlayers(2)
	while hunter > 1 do
		local players = team.GetPlayers(2)
		local ply = players[math.random(#players)]
		ply:SetTeam(3)
		if !nokill && ply:Alive() then
			ply:Kill()
		end
		local ct = ChatText()
		ct:Add(ply:Nick())
		ct:Add(" est devenu un ")
		ct:Add(team.GetName(smallerTeam), team.GetColor(smallerTeam))
		ct:SendAll()
		hunter = hunter - 1
	end
end

function GM:SwapTeams()
	for k, ply in pairs(player.GetAll()) do
		ply:SetTeam(3)
	end
	local players = team.GetPlayers(3)
	local ply = players[math.random(#players)]
	ply:SetTeam(2)
	if !nokill && ply:Alive() then
		ply:Kill()
	end
	local ct = ChatText()
	ct:Add("Teams have been swapped", Color(50, 220, 150))
	ct:SendAll()
end
