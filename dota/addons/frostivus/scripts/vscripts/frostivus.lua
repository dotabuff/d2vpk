--[[
Frostivus Game Mode

Festive game mode for great fun.
]]


-- Written like this to allow reloading
if FrostivusGameMode == nil then
	FrostivusGameMode = {}
	FrostivusGameMode.szEntityClassName = "frostivus"
	FrostivusGameMode.szNativeClassName = "dota_base_game_mode"
	FrostivusGameMode.__index = FrostivusGameMode

	-- Preserve this across script reloads
	-- How many guys this round are we respawning right now (to avoid ending early)
	FrostivusGameMode.nExecutingRespawns = 0
	-- How many guys this round have already respawned (to update quest text)
	FrostivusGameMode.nExecutedRespawns = 0
	FrostivusGameMode.bQuestTextDirty = false
end

function FrostivusGameMode:new (o)
	o = o or {}
	setmetatable(o, self)
	return o
end

-- Default settings for regular Dota
local minimapHeroScale = 600
local minimapCreepScale = 1

function FrostivusGameMode:_SetInitialValues()
	self.bRoundHasStarted = false
	self.bRoundHasSpawnedAllEnemies = false
	self.bRoundHasFinished = false
	self.bDistributeGoldToAllPlayers = false
	self.bRestoreHPAfterRound = false 
	self.bRestoreMPAfterRound = false
	self.bIsHeroRespawnEnabled = false
	self.bRewardForTowersStanding = false
	self.bUseReactiveDifficulty = false
	self.nGameEndState = NOT_ENDED

	self.nRoundBagCount = -1
	self.nGoldRemainingInRound = 0
	self.nGoldFromRound = 0
	self.nXPFRomRound = 0
	self.nNumberOfRounds = 0
	self.nRoundNumber = 1
	self.roundTitle = ""
	self.nGoldBagsExpired = 0
	self.nCurrentEnemyCount = 0
	self.nBagsToSpawn = 0
	self.nBagVariance = 0
	self.nTowerRewardAmount = 0
	self.nTowerScalingRewardPerRound = 0

	self.flPrepTimeBetweenRounds = 0
	self.flItemExpireTime = 0
	self.flThinkTimeAccumulator = 0
	self.flPrepTimeLeft = 0
	self.flXPMultiplier = 1

	self.vEnemiesRemaining = {}
	self.vPlayerHeroData = {}
	self.vRoundQuests = {}
	self.vWaypointList = {}

	self.vTowers = {}
	self.vDroppedItems = {}
	self.vTombstones = {}

	self.vSavedHeroStatesByRound = {}			-- state of each hero at the start of each round

	self.flDefeatTimer = 0
	self.flVictoryTimer = 0

	self.nRestartVoteYes = 0
	self.nRestartVoteNo = 0

	self.hStatusQuest = nil

	self.thinkState = Dynamic_Wrap( FrostivusGameMode, '_thinkState_Prep' )
	self._scriptBind:BeginThink( "FrostivusThink", Dynamic_Wrap( FrostivusGameMode, 'Think' ), 0.25 )

	self.keyValues = LoadKeyValues( "scripts/maps/" .. GetMapName() .. ".txt" )
	self:_readGameKeyValues( self.keyValues)		
end

-- Called from C++ to Initialize
function FrostivusGameMode:InitGameMode()
	-- Bind "self" in the callback
	local function _boundStartRoundConsoleCommand(...)
		return self:_StartRoundConsoleCommand(...)
	end
	Convars:RegisterCommand( "frostivus_start_round", _boundStartRoundConsoleCommand, "Skip to a round of Frostivus", FCVAR_CHEAT )

	local function _boundTestConsoleCommand(...)
		return self:_TestRoundConsoleCommand(...)
	end
	Convars:RegisterCommand( "frostivus_test", _boundTestConsoleCommand, "Test a round of Frostivus", FCVAR_CHEAT )

	local function _boundWatConsoleCommand(...)
		return self:_WatConsoleCommand(...)
	end
	Convars:RegisterCommand( "frostivus_wat", _boundWatConsoleCommand, "Report the status of Frostivus", 0 )

	Convars:RegisterConvar( "frostivus_difficulty", "0", "Additional difficulty on Frostivus mode.", FCVAR_CHEAT )
	Convars:RegisterConvar( "frostivus_report_data", "0", "Do we report xp and gold data on round end.", 0 )
	
	local function _boundExitGameConsoleCommand(...)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then
			return self:_voteExitGame( cmdPlayer:GetPlayerID() ) 
		end
	end
	local function _boundRestartGameConsoleCommand(...)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then
			self:_voteRestartGame( cmdPlayer:GetPlayerID() )
		end
	end
	Convars:RegisterCommand( "holdout_exit_game", _boundExitGameConsoleCommand, "A player chose to exit the game when the game was lost", 0 )
	Convars:RegisterCommand( "holdout_restart_game", _boundRestartGameConsoleCommand, "A player chose to restart the game when the game was lost", 0 )
	
	local function _boundWraithKingSpawnTime(...)
		self:WraithKingSpawnTime()
	end
	Convars:RegisterCommand( "wraith_king_test_spawn", _boundWraithKingSpawnTime, "Spawn the Wraith King", 0 )

	self.hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	self.hAncient:AddAbility( "ability_ancient_buddha" ) -- the ancient nevar dies!
	local buddhaAbility = self.hAncient:FindAbilityByName( "ability_ancient_buddha" )
	if buddhaAbility then
		buddhaAbility:SetLevel( 1 )
	end
	self.nAncientInvulnerabilityCount = self.hAncient:GetInvulnCount()

	self.nDifficulty = GameRules:GetDifficulty()

	self:_SetInitialValues()

	self._scriptBind:SetRemoveIllusionsOnDeath( true )

	ListenToGameEvent( "entity_killed", Dynamic_Wrap( FrostivusGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( FrostivusGameMode, 'OnNPCSpawned' ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( FrostivusGameMode, 'OnItemPickedUp' ), self )
	ListenToGameEvent( "dota_match_done", Dynamic_Wrap( FrostivusGameMode, 'OnMatchDone' ), self )
	ListenToGameEvent( "dota_holdout_revive_complete", Dynamic_Wrap( FrostivusGameMode, 'OnHoldoutReviveComplete' ), self )

	FrostivusLogGameStart( self )

	GameRules:SetHeroRespawnEnabled( false )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetHeroSelectionTime( 30.0 )
	GameRules:SetPreGameTime( 60.0 )
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetHeroMinimapIconSize( 400 )
	GameRules:SetCreepMinimapIconScale( 0.7 )
	GameRules:SetRuneMinimapIconScale( 0.7 )

	GameRules:SetTimeOfDay( 0.75 )
	Convars:SetBool( "dota_force_night", true )
	Convars:SetBool( "dota_suppress_invalid_orders", true )

	-- Make the enemy towers invulnerable
	local enemyTowers = Entities:FindAllByName( "npc_dota_holdout_tower_spawn_protection" )
	for i=1,#enemyTowers do
		enemyTowers[i]:AddNewModifier( enemyTowers[i], nil, "modifier_invulnerable", {} )
	end
end

function FrostivusGameMode:_InitCVars()
	if self.bHasSetCVars then
		return
	end
	self.bHasSetCVars = true
	Convars:SetBool( "dota_winter_ambientfx", true )
	Convars:SetBool( "dota_teamscore_enable", false )
end

function FrostivusGameMode:_RestartGame()	

	-- Clean up the last round
	self:_finishRound( false )
	while #self.vEnemiesRemaining > 0 do
		local unitData = table.remove( self.vEnemiesRemaining )
		if unitData and unitData.hEnemy and not unitData.hEnemy:IsNull() and unitData.hEnemy:IsAlive() then
			UTIL_RemoveImmediate( unitData.hEnemy )
		end
	end

	-- Clean up everything on the ground; gold, tombstones, items, everything.
	while GameRules:NumDroppedItems() > 0 do
		local item = GameRules:GetDroppedItem(0)
		UTIL_RemoveImmediate( item )
	end
	self:_respawnTowers()
	for playerID=0,4 do
		Players:SetGold( playerID, STARTING_GOLD, false )
		Players:SetGold( playerID, 0, true )
		Players:SetBuybackCooldownTime( playerID, 0 )
		Players:SetBuybackGoldLimitTime( playerID, 0 )
		Players:ResetBuybackCostTime( playerID )
	end

	-- Reset values
	self:_SetInitialValues()

	GameRules:ResetDefeated()

	-- Back to hero picker
	GameRules:ResetToHeroSelection()

	-- Reset suggested items
	FireGameEvent( "dota_reset_suggested_items", {} )

	-- Reset voting
	self.votes = {}
	self.flEndTime = nil
end

function FrostivusGameMode:_StartRoundConsoleCommand(...)
	local nArgs = select( '#', ... )
	self:SkipToRound( tonumber( select( 2, ... ) ) )
end

XP_PER_LEVEL_TABLE = {
	0,-- 1
	200,-- 2
	500,-- 3
	900,-- 4
	1400,-- 5
	2000,-- 6
	2600,-- 7
	3200,-- 8
	4400,-- 9
	5400,-- 10
	6000,-- 11
	8200,-- 12
	9000,-- 13
	10400,-- 14
	11900,-- 15
	13500,-- 16
	15200,-- 17
	17000,-- 18
	18900,-- 19
	20900,-- 20
	23000,-- 21
	25200,-- 22
	27500,-- 23
	29900,-- 24
	32400 -- 25
}

STARTING_GOLD = 625
ROUND_EXPECTED_VALUES_TABLE = {
	{ gold = STARTING_GOLD, xp = 0 }, -- 1
	{ gold = 1054+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[4] }, -- 2
	{ gold = 2212+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[5] }, -- 3
	{ gold = 3456+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[6] }, -- 4
	{ gold = 4804+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[8] }, -- 5
	{ gold = 6256+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[9] }, -- 6
	{ gold = 7812+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[9] }, -- 7
	{ gold = 9471+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[10] }, -- 8
	{ gold = 11234+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[11] }, -- 9
	{ gold = 13100+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[13] }, -- 10
	{ gold = 15071+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[13] }, -- 11
	{ gold = 17145+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[14] }, -- 12
	{ gold = 19322+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[16] }, -- 13
	{ gold = 21604+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[18] }, -- 14
	{ gold = 23368+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[18] } -- 15
}

-- game end states
NOT_ENDED = 0
VICTORIOUS = 1
DEFEATED = 2

function FrostivusGameMode:_TestRoundConsoleCommand(...)
	local nArgs = select( '#', ... )
	if nArgs < 2 then
		print ('frostivus_test <roundNumber>')
		return
	end


	local nTargetRound = tonumber( select( 2, ... ) )
	self:SkipToRound( nTargetRound )
	self.nGoldBagsExpired = 0
	self.flPrepTimeLeft = 30 -- Give some time to buy gear

	local nExpectedGold = ROUND_EXPECTED_VALUES_TABLE[nTargetRound].gold or 600
	local nExpectedXP = ROUND_EXPECTED_VALUES_TABLE[nTargetRound].xp or 0
	for _,heroEntity in ipairs( HeroList:GetAllHeroes() ) do
		local playerEntity = heroEntity:GetPlayerOwner()
		playerEntity:ReplaceHeroWith( heroEntity:GetUnitName(), nExpectedGold, nExpectedXP )
	end
end

function FrostivusGameMode:SkipToRound( nRoundNumber )
	if nRoundNumber < 1 or nRoundNumber > self.nNumberOfRounds then
		Warning( "Tried to skip to round " .. tostring( nRoundNumber ) .. " which does not exist.\n" )
		return
	end

	-- clear out existing enemies
	while #self.vEnemiesRemaining > 0 do
		local unitData = table.remove( self.vEnemiesRemaining )
		if unitData and unitData.hEnemy and not unitData.hEnemy:IsNull() and unitData.hEnemy:IsAlive() then
			if unitData.hEnemy.ForceKill ~= nil then
				unitData.hEnemy:ForceKill( false )
			end
		end
	end
	self:_removeAllDroppedItems()
	-- Fully heal the ancient when skipping rounds.
	if self.hAncient and not self.hAncient:IsNull() then
		self.hAncient:SetHealth( self.hAncient:GetMaxHealth() )
	end

	self.vPlayerHeroData = {}
	self:_populatePlayerHeroData()
	for i,heroEntity in ipairs( HeroList:GetAllHeroes() ) do
		Players:SetBuybackCooldownTime( heroEntity:GetPlayerID(), 0 )
		Players:SetBuybackGoldLimitTime( heroEntity:GetPlayerID(), 0 )
		Players:ResetBuybackCostTime( heroEntity:GetPlayerID() )
	end

	-- update custom hero, unit, ability and item values from disk
	GameRules:Playtesting_UpdateCustomKeyValues()

	-- reload round data from disk
	self.keyValues = LoadKeyValues( "scripts/maps/" .. GetMapName() .. ".txt" )
	self:_readGameKeyValues( self.keyValues)
	-- going back or restarting the current round, revert heroes
	self:_revertHeroesToRoundNumber( nRoundNumber )
	
	-- _finishRound has the side effect of incrementing the round number.
	self.nRoundNumber = nRoundNumber - 1
	self:_finishRound( false, false )
	self.flPrepTimeLeft = 5
	self.thinkState = Dynamic_Wrap( FrostivusGameMode, '_thinkState_Prep' )

	self:_showWraithKing()
end

function FrostivusGameMode:_WatConsoleCommand()
	print( '******* Frostivus Game Status ***************' )
	print( string.format( 'Round number %d', self.nRoundNumber ) )
	print( string.format( 'Round has finished? %s', tostring( self.bRoundHasFinished ) ) )
	print( string.format( 'Round has spawned all entities? %s', tostring( self.bRoundHasSpawnedAllEnemies ) ) )
	print( string.format( 'Round is executing respawns %d', self.nExecutingRespawns ) )
	print( string.format( 'Enemies remaining %d', #self.vEnemiesRemaining ) )
	for i=1,#self.vEnemiesRemaining do
		local enemy = self.vEnemiesRemaining[i].hEnemy
		local className = '<unknown>'
		if enemy.GetClassname then
			className = enemy:GetClassname()
		end
		local unitName = '<no name>'
		if enemy.GetUnitName then
			unitName = enemy:GetUnitName()
		end
		print( string.format( '%d %s %s', i, className, unitName ) )
	end
	print( '*********************************************' )
end

-- Called from C++ to handle the entity_killed event
function FrostivusGameMode:OnEntityKilled( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	-- Clean up units remaining...
	local enemyData = nil
	if killedUnit then
		for i=#self.vEnemiesRemaining,1,-1 do
			if self.vEnemiesRemaining[i].hEnemy == killedUnit then
				enemyData = self.vEnemiesRemaining[i]
				table.remove( self.vEnemiesRemaining, i )
				if enemyData.bCoreRoundEnemy then			
					self.nCurrentEnemyCount = self.nCurrentEnemyCount - 1
					enemyData.unitData.nUnitsCurrentlyAlive = enemyData.unitData.nUnitsCurrentlyAlive - 1
					if self.hStatusQuest then
						self.hStatusQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, ( self.nWaveEnemyCount - self.nCurrentEnemyCount ) - FrostivusGameMode.nExecutedRespawns )
					end
				end
			end
		end
	end

	if killedUnit and killedUnit:IsCreature() then
		if killerEntity then
			local killerPlayerID = -1
			if killerEntity.GetPlayerOwnerID then killerPlayerID = killerEntity:GetPlayerOwnerID() end
			for _,heroData in ipairs(self.vPlayerHeroData) do
				if heroData.nPlayerID == killerPlayerID then
					heroData.nCreepKills = heroData.nCreepKills + 1
					heroData.nCreepKillsThisRound = heroData.nCreepKillsThisRound + 1
					-- Last hit effects.
					EmitSoundOnClient( "FrostivusLastHit", heroData.hero:GetPlayerOwner() )
					ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "frostivus_last_hit_effect", PATTACH_ABSORIGIN_FOLLOW, killedUnit, heroData.hero:GetPlayerOwner() ) )
				end
			end
		end

		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "frostivus_death_creep", PATTACH_ABSORIGIN_FOLLOW, killedUnit ) )
		

		if enemyData and enemyData.bCoreRoundEnemy then
			-- Drop gold
			if enemyData.bDistributeGoldToAllPlayers then
				local nCurrentGoldDrop = math.floor( self.nGoldRemainingInRound / math.max( 1, self.nCurrentEnemyCount ) )
				self.nGoldRemainingInRound = self.nGoldRemainingInRound - nCurrentGoldDrop
				self:_giveGoldToAllPlayers( nCurrentGoldDrop / #self.vPlayerHeroData )
			elseif self.nGoldRemainingInRound > 0 and self.nCurrentEnemyCount > 0 then
				local flCurrentDropChance = self.nBagsToSpawn / self.nCurrentEnemyCount
				local nCurrentGoldDrop = 0
				if self.nBagsToSpawn > 0 then
					local nCurrentGoldDrop = math.floor( self.nGoldRemainingInRound / self.nBagsToSpawn )
					if self.nBagsToSpawn > 1 then
						local lowerBound = math.max(1, nCurrentGoldDrop - self.nBagVariance )
						local upperBound = math.max(1, nCurrentGoldDrop + self.nBagVariance )
						nCurrentGoldDrop = RandomInt( lowerBound, upperBound  )
					end
					if nCurrentGoldDrop > 0 and RandomFloat(0, 1) <= flCurrentDropChance then
						local bag = CreateUnitByName( "npc_dota_world_gold_bag", killedUnit:GetOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
						if bag then
							local knockbackCenter = bag:GetOrigin() + RandomVector( 10 )
							local modifierTable =
							{
								gold_amount = nCurrentGoldDrop,
								knockback_duration = 0.75,
								duration = 0.75,
								knockback_distance = RandomInt( 50, 250 ),
								knockback_height = RandomInt( 150, 250 ),
								center_x = knockbackCenter.x, center_y = knockbackCenter.y, center_z = knockbackCenter.z
							}
							bag:AddNewModifier( bag, nil, "modifier_gold_bag_launch", modifierTable )
						end
						self.nGoldRemainingInRound = self.nGoldRemainingInRound - nCurrentGoldDrop
						self.nBagsToSpawn = self.nBagsToSpawn - 1
					end
				end
			end
			-- Perform drops.
			for i = 1,#self.vItemDropData do
				local itemDropInfo = self.vItemDropData[i]
				if not itemDropInfo.bMustBeChampion or killedUnit:IsChampion() then
					if killedUnit:GetLevel() >= itemDropInfo.nReqLevel then
						if ( RollPercentage( itemDropInfo.nChance ) ) then
							local ownerEntity = killerEntity
							if ownerEntity and ownerEntity:GetPlayerOwner() == nil then
								ownerEntity = nil
							end
							local newItem = CreateItem( itemDropInfo.szItemName, ownerEntity, ownerEntity )
							newItem:SetPurchaseTime( 0 )
							if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
								item:SetStacksWithOtherOwners( true )
							end
							local drop = CreateItemOnPosition( killedUnit:GetOrigin() )
							if drop then
								drop:SetContainedItem( newItem )
								table.insert( self.vDroppedItems, drop )
							end
						end
					end
				end
			end
		end
	end

	if killedUnit and killedUnit:IsRealHero() then
		local newItem = CreateItem( "item_tombstone", killedUnit, killedUnit )
		newItem:SetPurchaseTime( 0 )
		newItem:SetPurchaser( killedUnit )
		local tombstoneLocation = killedUnit:GetOrigin()
		local function onTombstoneSpawn( self, tombstone )
			table.insert( self.vTombstones, tombstone )
			tombstone:SetContainedItem( newItem )
			tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
			FindClearSpaceForUnit( tombstone, tombstoneLocation, true )
		end
		SpawnEntityFromTable( "dota_item_tombstone_drop", {}, self, onTombstoneSpawn, nil )
	end

end


-- Called from C++ to handle the npc_spawned event
function FrostivusGameMode:OnNPCSpawned( keys )
	local spawnedUnit = EntIndexToHScript( keys.entindex )
	-- Don't track thinkers, they aren't relevant.
	if spawnedUnit:GetClassname() == "npc_dota_thinker" then
		return
	end
	-- Set some level up stats
	if spawnedUnit:IsCreature() then
		spawnedUnit:SetHPGain( spawnedUnit:GetMaxHealth() * 0.3 ) -- LEVEL SCALING VALUE FOR HP
		spawnedUnit:SetManaGain( 0 )
		spawnedUnit:SetHPRegenGain( 0 )
		spawnedUnit:SetManaRegenGain( 0 )
		if spawnedUnit:IsRangedAttacker() then
			spawnedUnit:SetDamageGain( ( ( spawnedUnit:GetBaseDamageMax() + spawnedUnit:GetBaseDamageMin() ) / 2 ) * 0.1 ) -- LEVEL SCALING VALUE FOR DPS
		else
			spawnedUnit:SetDamageGain( ( ( spawnedUnit:GetBaseDamageMax() + spawnedUnit:GetBaseDamageMin() ) / 2 ) * 0.2 ) -- LEVEL SCALING VALUE FOR DPS
		end
		spawnedUnit:SetArmorGain( 0 )
		spawnedUnit:SetMagicResistanceGain( 0 )
		spawnedUnit:SetDisableResistanceGain( 0 )
		spawnedUnit:SetAttackTimeGain( 0 )
		spawnedUnit:SetMoveSpeedGain( 0 )
		spawnedUnit:SetBountyGain( 0 )
		spawnedUnit:SetXPGain( 0 )
		spawnedUnit:CreatureLevelUp( self.nDifficulty + Convars:GetFloat( "frostivus_difficulty" ) )
	end

	-- We really only track creatures
	if spawnedUnit and spawnedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS and not spawnedUnit:IsPhantom() then
		spawnedUnit:SetMustReachEachGoalEntity(true) -- don't accidentally drop goal entity
		local enemyData = {
			unitName = spawnedUnit:GetUnitName(),
			bCoreRoundEnemy = false,
			hEnemy = spawnedUnit,
			unitData = nil,
			nDesiredXP = spawnedUnit:GetDeathXP() * self.flXPMultiplier,
		}
		
		spawnedUnit:SetMaximumGoldBounty( 0 )
		spawnedUnit:SetMinimumGoldBounty( 0 )
		spawnedUnit:SetDeathXP( 0 )
		table.insert( self.vEnemiesRemaining, enemyData )
	end

	-- Attach a lighting particle system to heroes
	if spawnedUnit and spawnedUnit:IsRealHero() and spawnedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		self:_populatePlayerHeroData()
	end
end

function FrostivusGameMode:OnHoldoutReviveComplete( keys )
	local castingHero = EntIndexToHScript( keys.caster )
	local revivedHero = EntIndexToHScript( keys.target )
	print ( string.format( '%s has revived %s', castingHero:GetUnitName(), revivedHero:GetUnitName() ) )
	if castingHero then
		for _,playerData in pairs( self.vPlayerHeroData ) do
			if playerData.hero == castingHero then
				playerData.nRevivesDone = playerData.nRevivesDone + 1
			end
		end
	end
end

-- Called from C++ to handle the dota_item_picked_up event
function FrostivusGameMode:OnItemPickedUp( keys )
	if keys.itemname == "item_bag_of_gold" then
		for i = 1,#self.vPlayerHeroData do
			local heroData = self.vPlayerHeroData[i]
			if heroData.nPlayerID == keys.PlayerID then
				heroData.nGoldBagsCollected = heroData.nGoldBagsCollected + 1
				heroData.nGoldBagsCollectedThisRound = heroData.nGoldBagsCollectedThisRound + 1
			end
		end
	end
	
	if keys.itemname == "item_flask2" or keys.itemname == "item_greater_clarity" then
		local item = EntIndexToHScript( keys.ItemEntityIndex )
		local hero = EntIndexToHScript( keys.HeroEntityIndex )
		if item and hero then
			item:SetPurchaser( hero )
		end
	end
end

-- Called from C++ to handle the dota_match_done event
function FrostivusGameMode:OnMatchDone( keys )
	local success = ( keys.winningteam == 0 )
	FrostivusLogGameEnd{ gamemode = self, success = success }
	FrostivusLogRoundEnd{ gamemode = self, success = success, nTowersStanding = "0?" }
	Convars:SetFloat( "dota_minimap_hero_size", minimapHeroScale )
	Convars:SetFloat( "dota_minimap_creep_scale", minimapCreepScale )
end

-- Think function called from C++, every second.
function FrostivusGameMode:Think()
	-- If the game's over, it's over.
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		self._scriptBind:EndThink( "GameThink" )
		return
	end

	-- Track game time, since the dt passed in to think is actually wall-clock time not simulation time.
	local now = GameRules:GetGameTime()
	if self.t0 == nil then
		self.t0 = now
	end
	local dt = now - self.t0
	self.t0 = now

	self:thinkState( dt )

	-- Think any tombstones...
	for i = #self.vTombstones, 1, -1 do
		local item = self.vTombstones[i]
		if item:IsNull() then
			table.remove( self.vTombstones, i )
		elseif item:GetContainedItem() then
			item:GetContainedItem():Think()
		end
	end
	self:_updateItemExpiration()

	self:_roundThink( dt )
end


_selfGlobalPointer = {} 
WraithKingSpawnTime = {} -- declare the global function so we can fill it later
WraithKingStandStillUntil = -1
function FrostivusGameMode:WraithKingRoundStart()
	self.bWraithKingSpawn = false
	WraithKingSpawnTime = self._wraithKingSpawnTime
	_selfGlobalPointer = self

	local logicRelay = Entities:FindByName( nil, "wraith_begin_round" )

	logicRelay:Trigger()

	EmitGlobalSound( "Music_Frostivus.WraithKing" )
end

function FrostivusGameMode:_wraithKingSpawnTime()
	_selfGlobalPointer.bWraithKingSpawn = true
	-- make sure we do a think next tick to spawn him
	_selfGlobalPointer.flThinkTimeAccumulator = 5.1
	-- don't do anything for a second
	WraithKingStandStillUntil = Time() + 1.0
end

function FrostivusGameMode:_showWraithKing()
	-- unhide Wraith King
	local logicRelay = Entities:FindByName( nil, "wraith_restart_enable" )
	logicRelay:Trigger()
end


function _PhaseAllUnits( bPhase )
	local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vec3( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER, 0, FIND_ANY_ORDER, false )
	for _,unit in ipairs(units) do
		if bPhase then
			unit:AddNewModifier( units[i], nil, "modifier_phased", {} )
		else
			unit:RemoveModifierByName( "modifier_phased" )
		end
	end
end


function FrostivusGameMode:_populatePlayerHeroData()
	for i,heroEntity in ipairs( HeroList:GetAllHeroes() ) do
		if heroEntity and heroEntity:IsRealHero() then
			local nPlayerID = heroEntity:GetPlayerID()
			local bWasFound = false
			for j=1,#self.vPlayerHeroData do
				if self.vPlayerHeroData[j].nPlayerID == nPlayerID then
					self.vPlayerHeroData[j].hero = heroEntity
					bWasFound = true
					break
				end
			end
			if not bWasFound then
				local heroTable = {
					hero = heroEntity,
					nCreepKills = 0,
					nCreepKillsThisRound = 0,
					nGoldBagsCollected = 0,
					nGoldBagsCollectedThisRound = 0,
					nDamageDealt = 0,
					nDamageTaken = 0,
					nPriorRoundDeaths = 0,
					nRevivesDone = 0,
					nHealthRestored = 0,
					nPlayerID = nPlayerID
				}
				table.insert( self.vPlayerHeroData, heroTable )
			end
		end
	end
end

function FrostivusGameMode:_respawnTowers()
	-- Respawn all the towers.
	_PhaseAllUnits( true )
	local buildings = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vec3( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false )
	for _,building in ipairs( buildings ) do 
		if building:IsTower() then
			local sModelName = "models/props_structures/tower_good.mdl"
			building:SetOriginalModel( sModelName )
			building:SetModel( sModelName )
			local vOrigin = building:GetOrigin()
			if building:IsAlive() then
				building:Heal( building:GetMaxHealth(), building )
			else
				building:RespawnUnit()
			end
			building:SetOrigin( vOrigin )

			if not building:HasAbility( "tower_fortification" ) then building:AddAbility( "tower_fortification" ) end
			local fortificationAbility = building:FindAbilityByName( "tower_fortification" )
			if fortificationAbility then
				fortificationAbility:SetLevel( self.nRoundNumber / 2 )
			end

			building:RemoveModifierByName( "modifier_invulnerable" )
		end
	end
	self.hAncient:SetHealth( self.hAncient:GetMaxHealth() )
	self.hAncient:SetInvulnCount( self.nAncientInvulnerabilityCount )
	_PhaseAllUnits( false )
end

function FrostivusGameMode:_initializeNextRound()
	if not self.keyValues then
		return
	end

	self:_storeHeroStateForThisRound()
	self:_respawnTowers()

	-- Setup the altar health bar
	if self.nRoundNumber ~= 13 then
		GameRules:SetOverlayHealthBarUnit( self.hAncient, 1 )
	end

	-- Make enemy towers invulnerable
	local enemyBuildings = FindUnitsInRadius( DOTA_TEAM_BADGUYS, Vec3( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false )
	for i = 1, #enemyBuildings do 
		if enemyBuildings[i]:IsTower() then
			enemyBuildings[i]:SetInvulnCount( 1 )
		end
	end

	self.bRoundHasStarted = true
	self.bRoundHasSpawnedAllEnemies = false
	self.nGoldFromRound = 0
	self.nXPFromRound = 0
	self.vUnitRoundData = {}
	self.nWaveEnemyCount = 0
	self.nCurrentEnemyCount = 0
	self.vRoundQuests = {}

	FrostivusGameMode.nExecutingRespawns = 0
	FrostivusGameMode.nExecutedRespawns = 0
	FrostivusGameMode.bQuestTextDirty = false

	-- Setup the player data trackers...
	self:_populatePlayerHeroData()

	-- reset per player, per round counters
	for i = 1,#self.vPlayerHeroData do
		self.vPlayerHeroData[i].nCreepKillsThisRound = 0
		self.vPlayerHeroData[i].nGoldBagsCollectedThisRound = 0
		self.vPlayerHeroData[i].nPriorRoundDeaths = Players:GetDeaths( self.vPlayerHeroData[i].nPlayerID )
		self.vPlayerHeroData[i].nRevivesDone = 0
	end

	local pszRoundName = "Round" .. tostring( self.nRoundNumber )
	local pszRoundQuestTitle = "DOTA_Quest_Holdout_Round"
	self.roundTitle = ""
	local kvUnitsData = self.keyValues[pszRoundName]
	if not kvUnitsData then
		return
	end

	self.nGoldRemainingInRound = tonumber( kvUnitsData.MaxGold or 0 )
	self.nRoundBagCount = tonumber( kvUnitsData.BagCount or -1 )
	self.nBagVariance = tonumber( kvUnitsData.BagVariance or 0 )
	self.bDistributeGoldToAllPlayers = kvUnitsData.DistributeGoldToAllPlayers or false
	self.nFixedXP = tonumber( kvUnitsData.FixedXP or 0 )
	for keyName, sk in pairs( kvUnitsData ) do
	    if keyName == "round_quest_title" then
	    	pszRoundQuestTitle = sk
	    elseif keyName == "round_title" then
	    	self.roundTitle = sk
		elseif keyName == "round_quests" then
			for questName, questKey in pairs(sk) do
				table.insert( self.vRoundQuests, self:_readRoundQuestKeyValues( questKey ) )
			end
		elseif type(sk) == "table" then
			table.insert( self.vUnitRoundData, self:_readUnitKeyValues( sk, keyName ) )
    	end
	end
	self:_sortUnitRoundData()

	if self.nRoundBagCount ~= -1 then
		self.nBagsToSpawn = self.nRoundBagCount
	else
		self.nBagsToSpawn = math.max( math.floor( self.nCurrentEnemyCount / 3 ), 0 )
	end	

	local totalUnitXP = 0

	for i=1,#self.vUnitRoundData do 
		if UnitPrecacheData[self.vUnitRoundData[i].pszNPCClassName] then
			self.nWaveEnemyCount = self.nWaveEnemyCount + self.vUnitRoundData[i].nTotalUnitsToSpawnForRound
			totalUnitXP = totalUnitXP + ( UnitPrecacheData[self.vUnitRoundData[i].pszNPCClassName].xp * self.vUnitRoundData[i].nTotalUnitsToSpawnForRound )
		end
	end
	self.nCurrentEnemyCount = self.nWaveEnemyCount

	print( "Expected Round XP: " .. totalUnitXP )

	self.flXPMultiplier = 1
	if self.nFixedXP > 0 then
		self.flXPMultiplier = self.nFixedXP / totalUnitXP
	end

	if self.nWaveEnemyCount > 0 then
		local hSpawnTable = {
			name = pszRoundName,
			text = pszRoundQuestTitle,
			--subtext = "#DOTA_Quest_Holdout_Round_Subtext"
			show_progress_bar = true,
			progress_bar_hue_shift = -119 -- red
		}

		local function onQuestSpawn( self, quest )
			self.hStatusQuest = quest
			quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_ROUND, self.nRoundNumber )
			quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, self.nWaveEnemyCount )
			quest:SetTextReplaceString( self:_getDifficultyString() )
		end
		SpawnEntityFromTable( "quest_base", hSpawnTable, self, onQuestSpawn, nil )

	end

	local centerMessage = {
		message = self.roundTitle,
		duration = 3.3
	}
	FireGameEvent( "show_center_message", centerMessage )

	if kvUnitsData.StartupScript then
		self[kvUnitsData.StartupScript](self)
	end
end


function FrostivusGameMode:_startNextRound( dt ) 
	if self.hStatusQuest then
		self.hStatusQuest:CompleteQuest()
		self.hStatusQuest = nil
	end
	
	if self.nRoundNumber > self.nNumberOfRounds then
		GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
		SendFrostivusTimeElapsedToGC()
		return false
	end

	self:_initializeNextRound()
	return true
end


function FrostivusGameMode:_updateEnemiesRemaining()
	local bApplyVision = #self.vEnemiesRemaining < 5

	for i=#self.vEnemiesRemaining,1,-1 do
		local enemyData = self.vEnemiesRemaining[i]
		if enemyData == nil or enemyData.hEnemy:IsNull() or not enemyData.hEnemy:IsAlive() then			
			table.remove( self.vEnemiesRemaining, i )
		else
			local unit = enemyData.hEnemy
			if bApplyVision and self.bRoundHasSpawnedAllEnemies then		
				unit:AddNewModifier( unit, nil, "modifier_team_vision", { duration = 60 } )
			end
		end
	end
end


function FrostivusGameMode:_giveGoldToAllPlayers( nAmount )
	for i,hero in ipairs( HeroList:GetAllHeroes() ) do
		hero:ModifyGold( nAmount, true, 0 )
		self.nGoldFromRound = self.nGoldFromRound + nAmount
	end
end

function FrostivusGameMode:_defeated()
	GameRules:SetOverlayHealthBarUnit( nil, 0 )
	GameRules:Defeated()
	self.thinkState = Dynamic_Wrap( FrostivusGameMode, '_thinkState_Defeated' )
	self:thinkState( 0 )

	EmitGlobalSound( "Music_Frostivus.Lose" )
end

flVoteDuration = 30.0
function FrostivusGameMode:_showFrostivusEndScreen()
	GameRules:SetSafeToLeave( true )

	local holdoutEndData = {
		victory = (self.nGameEndState == VICTORIOUS),
		nRoundNumber = self.nRoundNumber,
		nRoundDifficulty = self.nDifficulty,
		roundName = self.roundTitle,
		flVoteDuration = flVoteDuration
	}
	if holdoutEndData.victory then
		holdoutEndData.nRoundNumber = self.nNumberOfRounds
	end

	self:_populatePlayerHeroData()
	for i = 1,#self.vPlayerHeroData do
		local heroData = self.vPlayerHeroData[i]

		if heroData.nPlayerID then 
			holdoutEndData["Player_"..heroData.nPlayerID.."_HeroName"] = Players:GetSelectedHeroName( heroData.nPlayerID )

			-- add total frosty points earned by this player so far
			if self.frostyPointData and self.frostyPointData["Player"..heroData.nPlayerID] then
				holdoutEndData["Player_"..heroData.nPlayerID.."_FrostyPoints"] = self.frostyPointData["Player"..heroData.nPlayerID]["total_frosty_points"]
				holdoutEndData["Player_"..heroData.nPlayerID.."_GoldFrostyPoints"] = self.frostyPointData["Player"..heroData.nPlayerID]["total_gold_frosty_points"]
			else
				holdoutEndData["Player_"..heroData.nPlayerID.."_FrostyPoints"] = 0
				holdoutEndData["Player_"..heroData.nPlayerID.."_GoldFrostyPoints"] = 0
			end
		end
	end

	print( "_showFrostivusEndScreen:" )
	printTable( holdoutEndData, " " )
	
	FireGameEvent( "holdout_end", holdoutEndData )

	Convars:SetBool( "dota_pause_game_pause_silently", true )
	PauseGame( true )
	self.nRestartVoteYes = 0
	self.nRestartVoteNo = 0
	self.votes = {}
end

function FrostivusGameMode:_voteRestartGame( nPlayerID )
	if self.votes[nPlayerID] == nil and ( self.nGameEndState == DEFEATED or self.nGameEndState == VICTORIOUS ) then
		self.votes[nPlayerID] = true
		self.nRestartVoteYes = self.nRestartVoteYes + 1
		self:_checkRestartVotes()
		FireGameEvent( "holdout_restart_vote", { bWantRestart = true } )
	end
end

function FrostivusGameMode:_voteExitGame( nPlayerID )
	if self.votes[nPlayerID] == nil and ( self.nGameEndState == DEFEATED or self.nGameEndState == VICTORIOUS ) then
		self.votes[nPlayerID] = false
		self.nRestartVoteNo = self.nRestartVoteNo + 1
		self:_checkRestartVotes()
		FireGameEvent( "holdout_restart_vote", { bWantRestart = false } )
	end
end

function FrostivusGameMode:_checkRestartVotes()
	if self.flEndTime == nil then
		self.flEndTime = Time() + flVoteDuration
	end

	if self.flEndTime then
		local bTimesUp = Time() > self.flEndTime

		for i = 1,#self.vPlayerHeroData do
			local heroData = self.vPlayerHeroData[i]
			if heroData.nPlayerID and Players:GetConnectionState( heroData.nPlayerID ) ~= 2 and self.votes[heroData.nPlayerID] == nil then
				self:_voteExitGame( heroData.nPlayerID )
			end
		end

		if bTimesUp or ( ( self.nRestartVoteYes + self.nRestartVoteNo ) == #self.vPlayerHeroData ) then
			SendFrostivusTimeElapsedToGC()
			if self.nRestartVoteYes == #self.vPlayerHeroData then
				self:_choseRestartGame()
			else
				self:_choseExitGame()
			end
			self.nRestartVoteYes = 0
			self.nRestartVoteNo = 0
			FireGameEvent( "holdout_restart_vote_end", {} )
		end
	end
end


function FrostivusGameMode:_choseExitGame()
	PauseGame( false )
	Convars:SetBool( "dota_pause_game_pause_silently", false )
	if not self.hAncient:IsNull() and self.hAncient:IsAlive() then
		self.hAncient:RemoveAbility( "ability_ancient_buddha" )
		self.hAncient:RemoveModifierByName( "buddha" )
	end
	SendFrostivusTimeElapsedToGC()
	GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )

	Convars:SetBool( "dota_force_night", false )
	Convars:SetBool( "dota_winter_ambientfx", false )
	Convars:SetBool( "dota_teamscore_enable", true )

	self.bQuit = true
end


function FrostivusGameMode:_getDifficultyString()
	local result = ""
	if self.nDifficulty > 4 then
		result = "(+" .. self.nDifficulty .. ")"
	elseif self.nDifficulty > 0 then
		for i=1,self.nDifficulty do
			result = result .. "+"
		end
	end
	return result
end


function FrostivusGameMode:_choseRestartGame()
	self.hAncient:SetHealth( self.hAncient:GetMaxHealth() )
	GameRules:SetSafeToLeave( false )

	if self.nGameEndState == VICTORIOUS then
		-- increase difficulty
		self.nDifficulty = self.nDifficulty + 1
		local eventData = {
			nRoundDifficulty = self.nDifficulty
		}
		FireGameEvent( "holdout_starting_next_difficulty", eventData )
	end
	
	self:_RestartGame()
	PauseGame( false )
	Convars:SetBool( "dota_pause_game_pause_silently", false )
	self:_showWraithKing()
	self.nGameEndState = NOT_ENDED
end

function FrostivusGameMode:_checkForDefeat()
	local vDeadHeroes = {}
	self:_populatePlayerHeroData()
	for i = 1,#self.vPlayerHeroData do
		local hero = self.vPlayerHeroData[i].hero
		if hero and not hero:IsAlive() then
			table.insert( vDeadHeroes, hero )
		end
	end
	if #vDeadHeroes == #self.vPlayerHeroData and GameRules:State_Get() ~= DOTA_GAMERULES_STATE_POST_GAME and #self.vPlayerHeroData > 1 then
		self:_defeated()
		return true
	end

	if not self.hAncient:IsNull() and self.hAncient:GetHealth() <= 10 then
		self:_defeated()
		return true
	end

	return false
end


function FrostivusGameMode:_finishRound( bAwardGold, bAwardFrostyPoints )
	self.bRoundHasStarted = false
	self.bRoundHasFinished = true

	if Convars:GetBool( "frostivus_report_data" ) then
		local msg = string.format( "====== End Of Round Summary for round %d =======\n", self.nRoundNumber )
		for nHero, heroEntity in ipairs( HeroList:GetAllHeros() ) do
			local totalGold = heroEntity:GetGold()
			for nItem = 0,12 do
				local itemEntity = heroEntity:GetItemInSlot( nItem )
				if itemEntity then
					totalGold = totalGold + itemEntity:GetCost()
				end
			end
			msg = msg .. string.format( 'Hero %s %d xp %d gold\n', heroEntity:GetUnitName(), heroEntity:GetCurrentXP(), totalGold )
		end
		msg  = msg .. "========================================\n"
		Msg( msg )
		if io then
			local logFile = io.open( "frostivus.log", "a+" )
			if logFile then
				logFile:write( msg )
				logFile:close()
			end
		end
	end

	if self.nRoundNumber == 0 then
		self.flPrepTimeLeft = 0
	else
		self.flPrepTimeLeft = self.flPrepTimeBetweenRounds
	end
	if ( self.nRoundNumber > 0 and bAwardFrostyPoints ) then
		self:_awardFrostyPoints()
	end
	self.nRoundNumber = self.nRoundNumber + 1

	local nTowers = 0
	local nTowersStanding = 0
	local nTowersStandingGoldReward = 0

	if bAwardGold then 
		for i=1,#self.vRoundQuests do
			local quest = self.vRoundQuests[i]
			if quest.hQuest then
				if quest.bSuccessIfNotCompleted then
					self:_giveGoldToAllPlayers( quest.nRewardGoldPerPlayer )
				end
				quest.hQuest:Remove()
			end
		end
		self.vRoundQuests = {}
		if self.hStatusQuest then
			self.hStatusQuest:CompleteQuest()
		end
	
		if self.bRewardForTowersStanding and self.nRoundNumber ~= 0 then
			local buildings = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vec3( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false )
			for i=1,#buildings do 
				if buildings[i]:IsTower() then
					nTowers = nTowers + 1
					if buildings[i]:IsAlive() then
						nTowersStanding = nTowersStanding + 1
					end
				end
			end
			
			nTowersStandingGoldReward = ( self.nTowerRewardAmount + ( self.nTowerScalingRewardPerRound * ( self.nRoundNumber - 1 ) ) ) * nTowersStanding
			self:_giveGoldToAllPlayers( nTowersStandingGoldReward )
		end
		-- for all rounds except the last, show the round summary UI
		if self.nRoundNumber <= self.nNumberOfRounds then
			self:_showRoundEndSummary( self.hStatusQuest, nTowers, nTowersStanding, nTowersStandingGoldReward )
		end
		FrostivusLogRoundEnd{ gamemode = self, success = true, nTowersStanding = nTowersStanding }
	end

	if self.bRestoreHPAfterRound or self.bRestoreMPAfterRound then
		self:_populatePlayerHeroData()
		for i,hero in ipairs( HeroList:GetAllHeroes() ) do
			if self.bRestoreHPAfterRound then
				hero:Heal( hero:GetMaxHealth(), nil )
			end
			if self.bRestoreMPAfterRound then
				hero:SetMana( hero:GetMaxMana() )
			end
			-- Refill any bottles if we're healing.
			if self.bRestoreHPAfterRound then
				for j=0,5 do
					local item = hero:GetItemInSlot( j )
					if item and item:GetAbilityName() == "item_bottle" then
						if item:GetCurrentCharges() < item:GetInitialCharges() then
							item:SetCurrentCharges( item:GetInitialCharges() )
							item:MarkAbilityButtonDirty()
						end
					end
				end
			end
		end
	end

	for i,hero in ipairs( HeroList:GetAllHeroes() ) do
		if not hero:IsAlive() then
			hero:RespawnHero( false, false, false )
			FindClearSpaceForUnit( hero, hero:GetOrigin(), true )
		end
		local playerOwner = hero:GetPlayerOwner()
		if playerOwner then
			playerOwner:SetKillCamUnit( nil )
		end
	end

	if bAwardGold then
		if self.nRoundNumber > self.nNumberOfRounds then
			GameRules:SetOverlayHealthBarUnit( nil, 0 )
			self.nGameEndState = VICTORIOUS
			FireGameEvent( "holdout_victory_message", {} )
			self.thinkState = Dynamic_Wrap( FrostivusGameMode, '_thinkState_Victory' )
			self:thinkState( 0 )
		else
			EmitGlobalSound( "Music_Frostivus.RoundEnd" )
		end
	end

	if self.hStatusQuest then
		self.hStatusQuest:CompleteQuest()
		self.hStatusQuest = nil
	end
end

function FrostivusGameMode:_showRoundEndSummary( quest, nTowers, nTowersStanding, nTowersStandingGoldReward )
	-- Prepare all the data the round end summary UI needs
	local roundEndSummary = {
		nRoundNumber = self.nRoundNumber - 1,
		nRoundDifficulty = self.nDifficulty,
		roundName = self.roundTitle,
		nTowers = nTowers,
		nTowersStanding = nTowersStanding,
		nTowersStandingGoldReward = nTowersStandingGoldReward,
		nGoldBagsExpired = self.nGoldBagsExpired
	}

	self:_populatePlayerHeroData()
	for i = 1,#self.vPlayerHeroData do
		local heroData = self.vPlayerHeroData[i]
		if heroData.nPlayerID then 
			roundEndSummary["Player_"..heroData.nPlayerID.."_HeroName"] = Players:GetSelectedHeroName( heroData.nPlayerID )
			roundEndSummary["Player_"..heroData.nPlayerID.."_CreepKills"] = heroData.nCreepKillsThisRound
			roundEndSummary["Player_"..heroData.nPlayerID.."_GoldBagsCollected"] = heroData.nGoldBagsCollectedThisRound
			roundEndSummary["Player_"..heroData.nPlayerID.."_Deaths"] = Players:GetDeaths( heroData.nPlayerID ) - heroData.nPriorRoundDeaths
			roundEndSummary["Player_"..heroData.nPlayerID.."_PlayersResurrected"] = heroData.nRevivesDone

			-- add frosty points earned this round
			roundEndSummary["Player_"..heroData.nPlayerID.."_FrostyPoints"] = GetFrostyPointsForRound( heroData.nPlayerID, self.nDifficulty, roundEndSummary.nRoundNumber )
			roundEndSummary["Player_"..heroData.nPlayerID.."_GoldFrostyPoints"] = GetGoldFrostyPointsForRound( heroData.nPlayerID, self.nDifficulty, roundEndSummary.nRoundNumber )
			roundEndSummary["Player_"..heroData.nPlayerID.."_GoldFrostyBoost"] = ( GetGoldFrostyBoostAmount( heroData.nPlayerID, self.nDifficulty ) * 100 )

			-- add total frosty points earned on this server
			if self.frostyPointData and self.frostyPointData["Player"..heroData.nPlayerID] then
				roundEndSummary["Player_"..heroData.nPlayerID.."_TotalFrostyPoints"] = self.frostyPointData["Player"..heroData.nPlayerID]["total_frosty_points"]
				roundEndSummary["Player_"..heroData.nPlayerID.."_TotalGoldFrostyPoints"] = self.frostyPointData["Player"..heroData.nPlayerID]["total_gold_frosty_points"]
			else
				roundEndSummary["Player_"..heroData.nPlayerID.."_TotalFrostyPoints"] = 0
				roundEndSummary["Player_"..heroData.nPlayerID.."_TotalGoldFrostyPoints"] = 0
			end
		end
	end

	print( "_showRoundEndSummary:" )
	printTable( roundEndSummary, " " )

	FireGameEvent( "holdout_show_round_end_summary", roundEndSummary )
end

function FrostivusGameMode:_thinkState_Prep( dt )
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:_InitCVars()
	end

	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- Waiting on the game to start...
		return
	end

	if not self.hStatusQuest then
		local function onQuestSpawn( self, quest )
			quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_ROUND, self.nRoundNumber )
			quest:SetTextReplaceString( self:_getDifficultyString() )
			self.hStatusQuest = quest
		end
		SpawnEntityFromTable( "quest_base", { name = "PrepTime", text = "#DOTA_Quest_Holdout_PrepTime" }, self, onQuestSpawn, nil )
	end

	self.flPrepTimeLeft = math.max( 0, self.flPrepTimeLeft - dt )
	if self.flPrepTimeLeft > 0 then
		if self.hStatusQuest then
			self.hStatusQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.flPrepTimeLeft )
		end
	else
		if self.hStatusQuest then
			self.hStatusQuest:CompleteQuest()
			self.hStatusQuest = nil
		end

		if not self:_startNextRound( dt ) then
			Msg( "_startNextRound returned false.\n" )
			return
		end
		self.thinkState = Dynamic_Wrap( FrostivusGameMode, '_thinkState_InRound' )
		self:thinkState( 0 )
		self:_roundThink( 0 )
	end
end

function FrostivusGameMode:_thinkState_InRound( dt )
	if not self.bRoundHasStarted then
		return
	end

	self:_updateEnemiesRemaining()

	if self.nGameEndState == DEFEATED or self.nGameEndState == VICTORIOUS then
		if not self.bQuit then
			self:_checkRestartVotes()
		end
	else
		self:_checkForDefeat()
	end

	if #self.vEnemiesRemaining == 0 and not self.bRoundHasFinished and self.bRoundHasSpawnedAllEnemies and FrostivusGameMode.nExecutingRespawns == 0 then
		self:_finishRound( true, true )
		if self.nGameEndState ~= VICTORIOUS then
			self.thinkState = Dynamic_Wrap( FrostivusGameMode, '_thinkState_Prep' )
			self:thinkState( 0 )
		end
	end
end

function FrostivusGameMode:_thinkState_Defeated( dt )
	if self.flDefeatTimer == 0 then
		self.flDefeatTimer = GameRules:GetGameTime() + 3.5
	end

	if self.flDefeatTimer < GameRules:GetGameTime() then
		self.flDefeatTimer = 0
		self.nGameEndState = DEFEATED
	
		self:_showFrostivusEndScreen()

		self.thinkState = Dynamic_Wrap( FrostivusGameMode, '_thinkState_InRound' )
		self:thinkState( 0 )
	end
end

function FrostivusGameMode:_thinkState_Victory( dt )
	if self.flVictoryTimer == 0 then
		self.flVictoryTimer = GameRules:GetGameTime() + 4.5
	end

	if self.flVictoryTimer < GameRules:GetGameTime() then
		self.flVictoryTimer = 0
	
		self:_showFrostivusEndScreen()
	end

	if not self.bQuit then
		self:_checkRestartVotes()
	end
end

function FrostivusGameMode:_processItem( item, i )
	-- Items born on or before this time are too old and must expire.
	local flCutoffTime = GameRules:GetGameTime() - self.flItemExpireTime

	if item:GetCreationTime() < flCutoffTime then
		local containedItem = item:GetContainedItem()
		if containedItem and containedItem:GetAbilityName() == "item_bag_of_gold" then
			self.nGoldBagsExpired = self.nGoldBagsExpired + 1
			-- Do not send the popup message on the screen.
			-- GameRules:SendCustomMessage( "#DOTA_Holdout_GoldBagExpired", -1, self.nGoldBagsExpired )
		end
		local nFXIndex = ParticleManager:CreateParticle( "veil_of_discord", PATTACH_CUSTOMORIGIN, item )
		ParticleManager:SetParticleControl( nFXIndex, 0, item:GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vec3( 35, 35, 25 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		local inventoryItem = item:GetContainedItem()
		if inventoryItem then
			UTIL_RemoveImmediate( inventoryItem )
		end
		UTIL_RemoveImmediate( item )
		if i then
			table.remove( self.vDroppedItems, i )
		end
	end
end

function FrostivusGameMode:_updateItemExpiration()
	if self.flItemExpireTime <= 0.0 then
		return
	end

	local goldBags = Entities:FindAllByClassname( "item_bag_of_gold" )
	for _,goldBag in pairs( goldBags ) do
		if goldBag:GetContainer() then
			self:_processItem( goldBag:GetContainer() )
		end
	end

	for i = #self.vDroppedItems, 1, -1 do
		local item = self.vDroppedItems[i]
		if item:IsNull() then
			table.remove( self.vDroppedItems, i )
		else
			self:_processItem( item, i )
		end
	end
end

function FrostivusGameMode:_removeAllDroppedItems()
	for i = 1, #self.vDroppedItems do
		local item = self.vDroppedItems[ i ]
		UTIL_RemoveImmediate( item )
	end
	self.vDropeedItems = {}
end


function FrostivusGameMode:_spawnWave( unitData )
	if unitData.nUnitsSpawnedThisRound == 0 then
		print( "Started spawning " .. unitData.pszLabel )
	end
	local spawner = Entities:FindByName( nil, unitData.pszSpawnerName )
	if not spawner then
		Msg( "Failed to find spawner named \'" .. unitData.pszSpawnerName .. "\' for \'" ..  unitData.pszNPCClassName .."\' \n" )
		return
	end

	for iUnit= 1,unitData.nUnitsPerSpawn do
		local bIsChampion = RollPercentage( unitData.nChampionChance )

		-- You can define a different NPC to spawn when a champion spawns, otherwise it will use an upgraded version of the same class
		local pszNPCtoSpawn = unitData.pszNPCClassName
		if bIsChampion and unitData.pszChampionNPCClassName ~= "" then
			pszNPCtoSpawn  = unitData.pszChampionNPCClassName
		end

		local vSpawnLocation = spawner:GetOrigin()
		if not unitData.bDontOffsetSpawn then
			vSpawnLocation = vSpawnLocation + RandomVector( 200 )
		end

		local unit = CreateUnitByName( pszNPCtoSpawn, vSpawnLocation, true, nil, nil, DOTA_TEAM_BADGUYS )
		if unit then
			if unit:IsCreature() then
				if bIsChampion then
					unit:CreatureLevelUp( ( unitData.nChampionLevel - 1 ) ) -- Difficulty is handled in the OnNPCSpawn callback
					unit:SetChampion( true )
					local nParticle = ParticleManager:CreateParticle( "heavens_halberd", PATTACH_ABSORIGIN_FOLLOW, pCreature )
					ParticleManager:ReleaseParticleIndex( nParticle )
					unit:SetModelScale( 1.1, 0 )
					unitData.nChampionMax = unitData.nChampionMax - 1 
					if unitData.nChampionMax <= 0 then
						unitData.nChampionChance = 0
					end
				elseif unitData.nCreatureLevel > 0 then
					unit:CreatureLevelUp( ( unitData.nCreatureLevel - 1 ) ) -- Difficulty is handled in the OnNPCSpawn callback
				end

				if unitData.bFaceSouth then
					unit:SetForwardVector( Vec3( 0, -1, 0 ) )
				end

				if unitData.bBonusRound and unitData.flBonusTime > 0.0 then
					unit:AddNewModifier( unit, nil, "modifier_kill", { duration = unitData.flBonusTime	} )
				end	
				self.nGoldFromRound = self.nGoldFromRound + unit:GetGoldBounty()
				self.nXPFromRound = self.nXPFromRound + unit:GetDeathXP()
			end
			
			if not unitData.bDontGiveGoal then
				unit:SetInitialGoalEntity( Entities:FindByName( nil, unitData.pszWaypointName ) )
			end

			unitData.nUnitsSpawnedThisRound = unitData.nUnitsSpawnedThisRound + 1
			unitData.nUnitsCurrentlyAlive = unitData.nUnitsCurrentlyAlive + 1
			
			for iEnemyData=1,#self.vEnemiesRemaining do
				local enemyDataTable = self.vEnemiesRemaining[iEnemyData]
				if enemyDataTable.hEnemy == unit then
					enemyDataTable.bCoreRoundEnemy = true
					enemyDataTable.unitData = unitData

					-- this is a core enemy, so XP is ok
					unit:SetDeathXP( enemyDataTable.nDesiredXP )
				end
			end
		end

		-- We spawned as many units as need to, this round of spawning is over.
		if unitData.nUnitsSpawnedThisRound >= unitData.nTotalUnitsToSpawnForRound then
			return
		end
	end
end


function FrostivusGameMode:_roundThink_UnitData( dt, unitData, unitIndex )
	-- Are we waiting for something to spawn?
	local waitForUnitData = unitData.waitForUnitData
	if waitForUnitData and waitForUnitData.nUnitsSpawnedThisRound < waitForUnitData.nTotalUnitsToSpawnForRound then
		return
	end

	if unitData.waitForScriptVariable and not self[unitData.waitForScriptVariable] then
		return
	end

	-- Pre-spawn wait times...
	if unitData.flInitialWait > 0 then
		unitData.flInitialWait = math.max( 0, unitData.flInitialWait - dt )
		return
	end

	if unitData.nUnitsCurrentlyAlive <= 0 and unitData.nUnitsSpawnedThisRound ~= 0 and self.bUseReactiveDifficulty and not unitData.groupWithUnitData then
		unitData.flSpawnTimeLeft = 0
	end

	if unitData.flSpawnTimeLeft > 0 then
		unitData.flSpawnTimeLeft = math.max( 0, unitData.flSpawnTimeLeft - dt )
	end
	if unitData.flSpawnTimeLeft > 0 or unitData.nUnitsSpawnedThisRound >= unitData.nTotalUnitsToSpawnForRound then
		return
	end

	-- Pick a waypoint to spawn at, if we're random spawning...
	if unitData.bUseRandomSpawner and not unitData.groupWithUnitData and #self.vWaypointList > 0 then
		local waypointData = self.vWaypointList[ RandomInt( 1, #self.vWaypointList ) ]
		unitData.pszSpawnerName = waypointData.pszSpawnerName
		unitData.pszWaypointName = waypointData.pszFirstWaypoint
	end

	local groupWithUnitData = unitData.groupWithUnitData
	if groupWithUnitData and groupWithUnitData.nUnitsSpawnedThisRound > 0 then
		unitData.pszSpawnerName = groupWithUnitData.pszSpawnerName
		unitData.pszWaypointName = groupWithUnitData.pszWaypointName
		unitData.flSpawnInterval = groupWithUnitData.flSpawnInterval
		if groupWithUnitData.flSpawnTimeLeft == groupWithUnitData.flSpawnInterval then
			unitData.flSpawnTimeLeft = 0
		end
	end

	if unitData.pszSpawnerName ~= "" then
        self:_spawnWave( unitData )
        unitData.flSpawnTimeLeft = unitData.flSpawnInterval
        self.bRoundHasFinished = false
    end
end


function FrostivusGameMode:_roundThink(dt)
	if not self.bRoundHasStarted then
		return
	end

	if FrostivusGameMode.bQuestTextDirty then
		FrostivusGameMode.bQuestTextDirty = false
		self.hStatusQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, ( self.nWaveEnemyCount - self.nCurrentEnemyCount ) - FrostivusGameMode.nExecutedRespawns )
	end

	-- Add a throttle to enemy spawning - don't worry about clearing this between rounds and such
	-- since the first check will show no enemies remaining so we'll pass right through.
	local nEnemiesRemaining = #self.vEnemiesRemaining
	if nEnemiesRemaining >= 150 or ( self.bThrottleSpawning and nEnemiesRemaining >= 120 ) then
		-- Remember that we're in throttled mode so don't spawn until we're below the lower bound.
		if not self.bThrottleSpawning then
			local message = string.format( "Spawning delayed because we have %d enemies remaining.", nEnemiesRemaining )
			local centerMessage = {
				message = message,
				duration = 3.3
			}
			print( message )
		end
		self.bThrottleSpawning = true
		return
	end
	self.bThrottleSpawning = false

	self.bRoundHasSpawnedAllEnemies = true
	local nUnitsSpawnedThisTick = 0
	for i=1,#self.vUnitRoundData do
		local unitData = self.vUnitRoundData[i]
		local nBaseline = unitData.nUnitsSpawnedThisRound
		self:_roundThink_UnitData( dt, unitData, i )
		nUnitsSpawnedThisTick = nUnitsSpawnedThisTick + unitData.nUnitsSpawnedThisRound - nBaseline
		if unitData.nUnitsSpawnedThisRound < unitData.nTotalUnitsToSpawnForRound then
			self.bRoundHasSpawnedAllEnemies = false
		end
	end
end

function FrostivusGameMode:_sortUnitRoundData()
	local unitDataByName = {}
	for i=1,#self.vUnitRoundData do
		self.vUnitRoundData[i].order = -1
		unitDataByName[self.vUnitRoundData[i].pszLabel] = self.vUnitRoundData[i]
	end

	local function computeOrder( unitData )
		-- If we've already computed the order, early exit
		if unitData.order ~= -1 then
			return unitData.order
		end

		unitData.order = 0
		local groupWithUnitData = unitDataByName[ unitData.pszGroupWithUnit ]
		if groupWithUnitData then
			unitData.groupWithUnitData = groupWithUnitData
			unitData.order = math.max( computeOrder( groupWithUnitData ) + 1, unitData.order )
		elseif unitData.pszGroupWithUnit ~= "" then
			print (unitData.pszLabel .. " wants to group with unit " .. unitData.pszGroupWithUnit .. " which cannot be found." )
		end

		local waitForUnitData = unitDataByName[ unitData.pszWaitForUnit ]
		if unitData.pszWaitForUnit == "" and groupWithUnitData then
			waitForUnitData = groupWithUnitData.waitForUnitData
		end
		if waitForUnitData then
			unitData.waitForUnitData = waitForUnitData
			unitData.order = math.max( computeOrder( waitForUnitData ) + 1, unitData.order )
		elseif unitData.pszWaitForUnit ~= "" then 
			print (unitData.pszLabel .. " wants to wait for unit " .. unitData.pszWaitForUnit .. " which cannot be found." )
		end 
		return unitData.order
	end

	for i=1,#self.vUnitRoundData do
		computeOrder( self.vUnitRoundData[i] )
	end

	local function compareFn( a, b )
		return a.order < b.order
	end
	table.sort( self.vUnitRoundData, compareFn )

	-- Clean up the temporary value.
	for i = 1,#self.vUnitRoundData do
		self.vUnitRoundData[i].order = nil
	end

	-- Compute the duration of the round
	local spawnEndTimeByName = {}
	for i,unitData in ipairs( self.vUnitRoundData ) do
		-- Do the thing
		local unitsToSpawn = unitData.nTotalUnitsToSpawnForRound
		local unitsPerSpawn = unitData.nUnitsPerSpawn
		local spawnCount = math.ceil( unitsToSpawn / unitsPerSpawn )
		local spawnTime = unitData.flSpawnInterval * spawnCount
		if unitData.flInitialWait then
			spawnTime = spawnTime + unitData.flInitialWait
		end
		if unitData.waitForUnitData then
			spawnTime = spawnTime + spawnEndTimeByName[ unitData.waitForUnitData.pszLabel ]
		end
		spawnEndTimeByName[ unitData.pszLabel ] = spawnTime		
	end

	local maxSpawnTime = 0
	for label,spawnTime in pairs( spawnEndTimeByName ) do
		maxSpawnTime = math.max( maxSpawnTime, spawnTime )
	end
	print( string.format( "Round %d last spawn will happen after %f seconds.", self.nRoundNumber, maxSpawnTime ) )
end




-- KeyValues interpretation functions
function FrostivusGameMode:_readGameKeyValues( keyValues )
	self.bAlwaysShowPlayerGold = keyValues.AlwaysShowPlayerGold or false
	self.bRestoreHPAfterRound = keyValues.RestoreHPAfterRound or false
	self.bRestoreMPAfterRound = keyValues.RestoreMPAfterRound or false
	self.bRewardForTowersStanding = keyValues.RewardForTowersStanding or false
	self.bUseReactiveDifficulty = keyValues.UseReactiveDifficulty or false

	self.nTowerRewardAmount = tonumber( self.keyValues.TowerRewardAmount or 0 )
	self.nTowerScalingRewardPerRound = tonumber( self.keyValues.TowerScalingRewardPerRound or 0 )

	self.flPrepTimeBetweenRounds = tonumber( self.keyValues.PrepTimeBetweenRounds or 0 )
	self.flItemExpireTime = tonumber( self.keyValues.ItemExpireTime or 10.0 )

	while true do
		local pszRoundName = "Round" .. ( self.nNumberOfRounds + 1 )
		local roundData = keyValues[ pszRoundName ]
		if not roundData then
			break
		end
		for keyName, sk in pairs( roundData ) do
			if  type(sk) == "table" and sk.NPCName then
				PrecacheFrostivusUnit( sk.NPCName )
			end
		end
		self.nNumberOfRounds = self.nNumberOfRounds + 1
	end

	self.vItemDropData = {}
	local itemDropsKey = keyValues["ItemDrops"]
	if itemDropsKey then
		for k,subKey in pairs(itemDropsKey) do
			table.insert( self.vItemDropData, self:_readItemDropKeyValues( subKey ) )
		end
	end

	self.bRandomSpawningEnabled = false
	self.vWaypointList = {}
	local randomSpawnsKey = keyValues["RandomSpawns"]
	if randomSpawnsKey ~= nil then
		for k,subKey in pairs( randomSpawnsKey ) do
			table.insert( self.vWaypointList, self:_readWaypointKeyValues( subKey ) )
		end
	end
	self.bRandomSpawningEnabled = ( #self.vWaypointList > 0 )
	
	local linkedXPEnemiesKey = keyValues["LinkedXPEnemies"]
	if linkedXPEnemiesKey then
		local dependencies = {}
		for baseEnemyName,baseEnemyData in pairs(linkedXPEnemiesKey) do
			PrecacheFrostivusUnit( baseEnemyName )
			for leafEnemyName,leafEnemyCount in pairs(baseEnemyData) do
				PrecacheFrostivusUnit( leafEnemyName )
				local XPChange = ( leafEnemyCount * UnitPrecacheData[leafEnemyName].xp )
				UnitPrecacheData[baseEnemyName].xp = UnitPrecacheData[baseEnemyName].xp + XPChange
				dependencies[leafEnemyName] = baseEnemyName -- TODO support more than one dependency?

				if dependencies[baseEnemyName] then
					local dependencyCount = linkedXPEnemiesKey[ dependencies[baseEnemyName] ][baseEnemyName]
					UnitPrecacheData[ dependencies[baseEnemyName] ].xp = UnitPrecacheData[ dependencies[baseEnemyName] ].xp + ( XPChange * dependencyCount )
				end
			end
		end
	end
end

function FrostivusGameMode:_readItemDropKeyValues( kvItemDrop )
	return {
		szItemName = tostring( kvItemDrop.Item or "" ),
		nChance = tonumber( kvItemDrop.Chance or 0 ),
		nReqLevel = tonumber( kvItemDrop.RequiredLevel or 1 ),
		bMustBeChampion = kvItemDrop.RequiredChampion or false
	}
end

function FrostivusGameMode:_readWaypointKeyValues( kvWaypoint ) 
	return {
		pszSpawnerName = kvWaypoint.SpawnerName or "",
		pszFirstWaypoint = kvWaypoint.Waypoint or ""
	}
end

function FrostivusGameMode:_readUnitKeyValues( kvUnit, unitName )
	return {
		pszLabel = unitName,
		pszNPCClassName = kvUnit.NPCName or "",
		pszChampionNPCClassName = kvUnit.ChampionNPCName or "",
		pszWaitForUnit = kvUnit.WaitForUnit or "",
		pszSpawnerName = kvUnit.SpawnerName or "",
		pszWaypointName = kvUnit.Waypoint or "",
		pszGroupWithUnit = kvUnit.GroupWithUnit or "",

		nCreatureLevel = tonumber( kvUnit.CreatureLevel or 1 ),
		nChampionChance = tonumber( kvUnit.ChampionChance or 0 ),
		nChampionLevel = tonumber( kvUnit.ChampionLevel or 1 ),
		nChampionMax = tonumber( kvUnit.ChampionMax or 1 ),
		nTotalUnitsToSpawnForRound = tonumber( kvUnit.TotalUnitsToSpawn or 0 ),
		nUnitsPerSpawn = tonumber( kvUnit.UnitsPerSpawn or 0 ),
		nUnitsSpawnedThisRound = 0,
		nUnitsCurrentlyAlive = 0,

		flInitialWait = tonumber( kvUnit.WaitForTime or 0.0 ),
		flSpawnInterval = tonumber( kvUnit.SpawnInterval or 0.0 ),
		flBonusTime = tonumber( kvUnit.BonusTime or 0.0 ),
		flSpawnTimeLeft = 0.0,
		flLastSpawnTime = 0.0,
		waitForScriptVariable = kvUnit.WaitForScriptVariable,

		bBonusRound = kvUnit.BonusRound or false,
		bUseRandomSpawner = ( tostring( kvUnit.SpawnerName or "" ) == "" ),
		bDontOffsetSpawn = kvUnit.DontOffsetSpawn or false,
		bFaceSouth = kvUnit.FaceSouth or false,
		bDontGiveGoal = kvUnit.DontGiveGoal or false
	}
end

function FrostivusGameMode:_readRoundQuestKeyValues( kvQuest )
	local roundQuest = {
		hQuest = null,
		nRewardGoldPerPlayer = tonumber( kvQuest.reward_gold_per_player or 0),
		bSuccessIfNotCompleted = kvQuest.success_if_not_completed_at_round_end or false
	}

	local questEntType = nil
	local questSpawnInfo = nil
	for k,v in pairs(kvQuest) do
		if type(v) == "table" and string.sub( k, 1, string.len("quest_")) == "quest_" then
			questEntType = k
			questSpawnInfo = v
		end
	end

	local function onQuestSpawn( self, questEnt )
		roundQuest.hQuest = questEnt
		questEnt:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_REWARD, roundQuest.nRewardGoldPerPlayer )
	end
	SpawnEntityFromTable( questEntType, questSpawnInfo, self, onQuestSpawn, nil )
	return roundQuest
end

function printTable( t, indent )
	for k,v in pairs( t ) do
        if type( v ) == "table" then
        	if ( v ~= t ) then
				print( indent..tostring(k)..":\n"..indent.."{" )
        		printTable( v, indent.."  " )
				print( indent.."}" )
        	end
        else
        	print( indent..tostring(k)..":"..tostring(v) )
        end
    end
end

function FrostivusGameMode:_getHeroInventoryItemNames( heroEntity )
	local inventory = {}

	for i=0,DOTA_ITEM_MAX-1 do
		local item = heroEntity:GetItemInSlot( i )
		if item then
			inventory[i]=item:GetAbilityName()
		end
	end
	return inventory
end

function FrostivusGameMode:_storeHeroStateForThisRound()
	local roundState = {}

	for i,heroEntity in ipairs( HeroList:GetAllHeroes() ) do
		if heroEntity and heroEntity:IsRealHero() then
			local heroState = {
				unitName = heroEntity:GetUnitName(),
				gold = heroEntity:GetGold(),
				xp = heroEntity:GetCurrentXP(),
				inventory = self:_getHeroInventoryItemNames( heroEntity )
			}
			roundState[i] = heroState
		end
		roundState["nRoundNumber"] = self.nRoundNumber
		roundState["nGoldBagsExpired"] = self.nGoldBagsExpired
	end

	print( "Storing Round "..tostring(roundState["nRoundNumber"])..":" )
	printTable( roundState, "  " )

	table.insert( self.vSavedHeroStatesByRound, roundState )
end

function FrostivusGameMode:_revertHeroesToRoundState( roundState )
	for i,heroEntity in ipairs( HeroList:GetAllHeroes() ) do
		if heroEntity and roundState[i] and heroEntity:GetUnitName() == roundState[i].unitName then
			local playerEntity = heroEntity:GetPlayerOwner()
			if playerEntity then
				local newHeroEntity = playerEntity:ReplaceHeroWith( roundState[i].unitName, roundState[i].gold, roundState[i].xp )
				if newHeroEntity then
					for s=0,DOTA_ITEM_MAX-1 do
						if roundState[i].inventory[s] then
							local item = CreateItem( roundState[i].inventory[s], newHeroEntity, newHeroEntity )
							newHeroEntity:AddItem( item )
						end
					end
				end
			end
		end
	end
	self.nGoldBagsExpired = roundState["nGoldBagsExpired"]
end

function FrostivusGameMode:_revertHeroesToRoundNumber( nRound )
	print( "Reverting to Round "..nRound..":" )
	if nRound == -1 then
		Warning( "_revertHeroesToRound: Invalid round specified" )
		return
	end

	local bFoundRound = false

	for i = 1,#self.vSavedHeroStatesByRound do
		if self.vSavedHeroStatesByRound[i]["nRoundNumber"] == nRound then
			printTable( self.vSavedHeroStatesByRound[i], "  " )
			self:_revertHeroesToRoundState( self.vSavedHeroStatesByRound[i] )
			bFoundRound = true
			break
		end
	end

	if not bFoundRound then
		print( "Didn't find revert to round data "..nRound )
	end
end

function FrostivusGameMode:_awardFrostyPoints()

	if not self.frostyPointData then
		self.frostyPointData = {
			nBestDifficulty = self.nDifficulty,
			nBestRoundNumber = self.nRoundNumber,
			nTotalRoundsPlayed = 0
		}
	end

	-- keep a running total of frosty points for each player
	for i,heroEntity in ipairs( HeroList:GetAllHeroes() ) do
		if heroEntity and heroEntity:IsRealHero() then
			local nPlayerID = heroEntity:GetPlayerID()

			if not self.frostyPointData["Player"..nPlayerID] then self.frostyPointData["Player"..nPlayerID] = {} end

			local nPoints = GetFrostyPointsForRound( nPlayerID, self.nDifficulty, self.nRoundNumber )
			local nGoldPoints = GetGoldFrostyPointsForRound( nPlayerID, self.nDifficulty, self.nRoundNumber )

			self.frostyPointData["Player"..nPlayerID]["total_frosty_points"] = ( self.frostyPointData["Player"..nPlayerID]["total_frosty_points"] or 0 ) + nPoints
			self.frostyPointData["Player"..nPlayerID]["total_gold_frosty_points"] = ( self.frostyPointData["Player"..nPlayerID]["total_gold_frosty_points"] or 0 ) + nGoldPoints
		end
	end

	self.frostyPointData.nDifficulty = self.nDifficulty
	self.frostyPointData.nRoundNumber = self.nRoundNumber
	self.frostyPointData.nTotalRoundsPlayed = self.frostyPointData.nTotalRoundsPlayed + 1

	if self.nDifficulty > self.frostyPointData.nBestDifficulty then
		self.frostyPointData.nBestDifficulty = self.nDifficulty
	end
	if self.nDifficulty == self.frostyPointData.nBestDifficulty and self.nRoundNumber > self.frostyPointData.nBestRoundNumber then
		self.frostyPointData.nBestRoundNumber = self.nRoundNumber
	end

	SendFrostyPointsMessageToGC( self.frostyPointData )
end

EntityFramework:RegisterScriptClass( FrostivusGameMode )