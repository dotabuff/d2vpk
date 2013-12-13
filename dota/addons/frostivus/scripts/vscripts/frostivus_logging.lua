--[[
Frostivus Game Mode Logging
]]

timestamp = GetSystemDate() .. " " .. GetSystemTime()

function FrostivusLogGameStart( args )
	InitLogFile( "holdout_frostivus/" .. GetMapName() .. "/overview.csv",
		"timestamp,final round,total deaths,gold bags,hero 1, hero 1 steamID, hero 1 level,hero 2, hero 2 steamID, hero 2 level,hero 3, hero 3 steamID, hero 3 level,hero 4, hero 4 steamID, hero 4 level,hero 5, hero 5 steamID, hero 5 level\n" )
	InitLogFile( "holdout_frostivus/" .. GetMapName() .. "/heroes.csv",
		"timestamp,hero,hero steamID,hero level,final round,gold bags,kills,deaths,damage taken,damage dealt,damage healed,item 1,item 2,item 3,item 4,item 5,item 6\n" )
	InitLogFile( "holdout_frostivus/" .. GetMapName() .. "/rounds.csv",
		"timestamp,round number,success,deaths,gold bags,tower damage,tower count,hero 1,hero 1 steamID,hero 1 level,hero 2,hero 2 steamID,hero 2 level,hero 3,hero 3 steamID,hero 3 level,hero 4,hero 4 steamID,hero 4 level,hero 5,hero 5 steamID,hero 5 level,time end\n" )
end

function FrostivusLogGameEnd( args )
	local vHeroData = args.gamemode.vPlayerHeroData

	local vHeroDescriptions = FillHeroDescriptions( vHeroData )

	local nGoldBags = 0
	local nDeaths = 0
	for i=1,5 do
		if vHeroData[i] then
			nGoldBags = nGoldBags + vHeroData[i].nGoldBagsCollected
			nDeaths = nDeaths + Players:GetDeaths( vHeroData[i].nPlayerID )
		end
	end

	AppendToLogFile( "frostivus/" .. GetMapName() .. "/overview.csv",
		timestamp .. "," ..
		args.gamemode.nRoundNumber .. "," ..
		nDeaths .. "," ..
		nGoldBags .. "," ..
		vHeroDescriptions[1] .. "," ..
		vHeroDescriptions[2] .. "," ..
		vHeroDescriptions[3] .. "," ..
		vHeroDescriptions[4] .. "," ..
		vHeroDescriptions[5] ..
		"\n" );

	for i=1,5 do
		if vHeroData[i] then
			local vItems = {}
			for j=0,5 do
				vItems[j] = vHeroData[i].hero:GetItemInSlot( j )
			end
			AppendToLogFile( "frostivus/" .. GetMapName() .. "/heroes.csv",
				timestamp .. "," .. 
				vHeroDescriptions[i] .. "," ..
				args.gamemode.nRoundNumber .. "," ..
				vHeroData[i].nGoldBagsCollected .. "," ..
				vHeroData[i].nCreepKills .. "," ..
				Players:GetDeaths( vHeroData[i].nPlayerID ) .. "," ..
				Players:GetCreepDamageTaken( vHeroData[i].nPlayerID ) .. "," ..
				Players:GetRawPlayerDamage( vHeroData[i].nPlayerID ) .. "," ..
				"?," .. -- healing
				(vItems[0] and vItems[0]:GetAbilityName() or "none") .. "," ..
				(vItems[1] and vItems[1]:GetAbilityName() or "none") .. "," ..
				(vItems[2] and vItems[2]:GetAbilityName() or "none") .. "," ..
				(vItems[3] and vItems[3]:GetAbilityName() or "none") .. "," ..
				(vItems[4] and vItems[4]:GetAbilityName() or "none") .. "," ..
				(vItems[5] and vItems[5]:GetAbilityName() or "none") ..
				"\n" );
		end
	end
end

function FrostivusLogRoundEnd( args )
	local vHeroData = args.gamemode.vPlayerHeroData

	local vHeroDescriptions = FillHeroDescriptions( vHeroData )
	
	local nGoldBags = 0
	local nDeaths = 0
	for i=1,5 do
		if vHeroData[i] then
			nGoldBags = nGoldBags + vHeroData[i].nGoldBagsCollectedThisRound
			nDeaths = nDeaths + (Players:GetDeaths( vHeroData[i].nPlayerID ) - vHeroData[i].nPriorRoundDeaths)
		end
	end

	AppendToLogFile( "frostivus/" .. GetMapName() .. "/rounds.csv", 
		timestamp .. "," ..
		args.gamemode.nRoundNumber .. "," ..
		tostring( args.success ) .. "," ..
		nDeaths .. "," ..
		nGoldBags .. "," ..
		"?," .. -- tower damage
		args.nTowersStanding .. "," .. -- tower count
		vHeroDescriptions[1] .. "," ..
		vHeroDescriptions[2] .. "," ..
		vHeroDescriptions[3] .. "," ..
		vHeroDescriptions[4] .. "," ..
		vHeroDescriptions[5] .. "," ..
		GetSystemTime() ..
		"\n" );
end

function FillHeroDescriptions( vHeroData )
	local vDescriptions = {}
	for i=1,5 do
		vDescriptions[i] =
			(vHeroData[i] and Players:GetSelectedHeroName( vHeroData[i].nPlayerID ) or "none") .. "," ..
			(vHeroData[i] and Players:GetSteamAccountID( vHeroData[i].nPlayerID ) or "0") .. "," ..
			(vHeroData[i] and Players:GetLevel( vHeroData[i].nPlayerID ) or "0")
	end
	return vDescriptions
end
--[[
			roundEndSummary["Player_"..heroData.nPlayerID.."_HeroName"] = Players:GetSelectedHeroName( heroData.nPlayerID )
			roundEndSummary["Player_"..heroData.nPlayerID.."_CreepKills"] = heroData.nCreepKillsThisRound
			roundEndSummary["Player_"..heroData.nPlayerID.."_GoldBagsCollected"] = heroData.nGoldBagsCollectedThisRound
			roundEndSummary["Player_"..heroData.nPlayerID.."_Deaths"] = Players:GetDeaths( heroData.nPlayerID )

						local heroData = self.vPlayerHeroData[i]
			if heroData.nPlayerID == keys.PlayerID then
				heroData.nGoldBagsCollected = heroData.nGoldBagsCollected + 1
				heroData.nGoldBagsCollectedThisRound = heroData.nGoldBagsCollectedThisRound + 1
			end
			]]