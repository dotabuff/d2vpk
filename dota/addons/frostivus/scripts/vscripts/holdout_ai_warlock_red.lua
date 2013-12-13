--[[
Red Warlock AI
]]

require( "ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function DispatchOnPostSpawn()
       AddThinkToEnt( thisEntity, "AIThink" )
       behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorShadowWord, BehaviorFatalBonds, BehaviorChaoticOffering, BehaviorRunAway } ) 
	  
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
       return behaviorSystem:Think()
end

function CollectRetreatMarkers()
	local result = {}
	local i = 1
	local wp = nil
	while true do
		wp = Entities:FindByName( nil, string.format("waypoint_%d", i ) )
		if not wp then
			return result
		end
		table.insert( result, wp:GetOrigin() )
		i = i + 1
	end
end
POSITIONS_retreat = CollectRetreatMarkers()

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()
	self.duration = 1
	
	local ancient =  Entities:FindByName( nil, "dota_goodguys_fort" )
	
	if ancient then
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = ancient:GetOrigin()
		}
	else
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		}
	end
end

function BehaviorNone:Continue()
	self.duration = 1
end
--------------------------------------------------------------------------------------------------------

BehaviorShadowWord = {}

function BehaviorShadowWord:Evaluate()
	local desire = 0
	
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end
	
	self.shadowWordAbility = thisEntity:FindAbilityByName( "warlock_shadow_word" )
	self.warlockFriends = {}
	table.insert( self.warlockFriends, thisEntity )
	
	--Find Friendly Warlocks
	local allies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, self.shadowWordAbility:GetCastRange(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _,ally in pairs(allies) do
		table.insert( self.warlockFriends, ally )
	end 

	local lowestHealthPercent = 100
	
	if #self.warlockFriends > 0  and self.shadowWordAbility and self.shadowWordAbility:IsFullyCastable() then
		for _,friend in pairs(self.warlockFriends) do
			if friend and friend:IsAlive() and friend:GetHealthPercent() < 85 then
				if friend:GetHealthPercent() < lowestHealthPercent then
					lowestHealthPercent = friend:GetHealthPercent()
					self.target = friend
					desire = RandomInt( 3, 5 )
				end
			end
		end
	end
	
	return desire
end

function BehaviorShadowWord:Begin()
	self.duration = 1
	
	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		UnitIndex = thisEntity:entindex(),
		TargetIndex = self.target:entindex(),
		AbilityIndex = self.shadowWordAbility:entindex()
	}

end

BehaviorShadowWord.Continue = BehaviorShadowWord.Begin

--------------------------------------------------------------------------------------------------------

BehaviorFatalBonds = {}

function BehaviorFatalBonds:Evaluate()
	local desire = 0
	
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.fatalAbility = thisEntity:FindAbilityByName( "warlock_fatal_bonds" )
	
	if self.fatalAbility and self.fatalAbility:IsFullyCastable() then
		self.target = AICore:RandomEnemyHeroInRange( thisEntity, self.fatalAbility:GetCastRange() )
		if self.target then
			local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.target:GetOrigin(), nil, 575, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
			if #enemies > 2 then
				desire = 5
			end 
			
		end
	end
	
	return desire
end

function BehaviorFatalBonds:Begin()
	self.duration = 1
	
	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		UnitIndex = thisEntity:entindex(),
		TargetIndex = self.target:entindex(),
		AbilityIndex = self.fatalAbility:entindex()
	}

end

BehaviorFatalBonds.Continue = BehaviorFatalBonds.Begin

--------------------------------------------------------------------------------------------------------

BehaviorChaoticOffering = {}

function BehaviorChaoticOffering:Evaluate()
	local desire = 0
	
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.chaoticAbility = thisEntity:FindAbilityByName( "creature_chaotic_offering" )
	
	if self.chaoticAbility and self.chaoticAbility:IsFullyCastable() then
		self.target = AICore:RandomEnemyHeroInRange( thisEntity, self.chaoticAbility:GetCastRange() )
		if self.target then
			local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.target:GetOrigin(), nil, 575, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
			if #enemies > 3 then
				desire = 4
			end 
			
		end
	end
	
	return desire
end

function BehaviorChaoticOffering:Begin()
	self.duration = 1
	
	local targetPoint = self.target:GetOrigin()
	
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = self.chaoticAbility:entindex(),
		Position = targetPoint
	}

end

BehaviorChaoticOffering.Continue = BehaviorChaoticOffering.Begin

--------------------------------------------------------------------------------------------------------

BehaviorRunAway = {}

function BehaviorRunAway:Evaluate()
	local desire = 0
	local happyPlaceIndex =  RandomInt( 1, #POSITIONS_retreat )
	escapePoint = POSITIONS_retreat[ happyPlaceIndex ]
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end
	
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	if #enemies > 0 then
		desire = #enemies
	end 
	
	
	return desire
end


function BehaviorRunAway:Begin()
	self.duration = 3
	
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = escapePoint
	}
end


BehaviorRunAway.Continue = BehaviorRunAway.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorShadowWord, BehaviorFatalBonds, BehaviorChaoticOffering, BehaviorRunAway }
