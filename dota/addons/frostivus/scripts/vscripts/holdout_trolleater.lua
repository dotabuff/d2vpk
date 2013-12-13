--[[-------------------------------------------------------------------------
	Troll eater "snacking" ability think
-----------------------------------------------------------------------------]]
function TrollEaterOnSpellStartSnacking( keys )

	-- Get the troll that is currently snacking
	local trollUnit = keys.caster
	if trollUnit == nil then
		return
	end

	-- Get the snack and determine what "color" it is
	local snackUnit = keys.target_entities[1]
	if snackUnit == nil then
		return
	end

	local isBlue = string.find( snackUnit:GetUnitName(), "blue" )
	if isBlue then
		trollUnit:Heal( 300, snackUnit )
--		print ("Troll is snacking on a blue snack!" )
	end

	local isRed = string.find( snackUnit:GetUnitName(), "red" )
	if isRed then
		trollUnit:CreatureLevelUp( 1 )
--		print ("Troll is snacking on a red snack!" )
	end

	-- Eat (kill) the snack
	UTIL_RemoveImmediate( snackUnit )
end

--[[-------------------------------------------------------------------------
	Setup the snacking think on spawn
-----------------------------------------------------------------------------]]
function DispatchOnPostSpawn()
	AddThinkToEnt( thisEntity, "SnackingThink" )
end

-- Local visible variables
TROLL_EATER_SNACKING = "troll_eater_snacking"
s_AbilitySnacking = thisEntity:FindAbilityByName( TROLL_EATER_SNACKING )

--[[-------------------------------------------------------------------------
	Snacking think function
-----------------------------------------------------------------------------]]
function SnackingThink()
	-- Get the troll's shacking ability
	if s_AbilitySnacking == nil then
		error( string.format( "Cannot initialize ability %s", TROLL_EATER_SNACKING ) )
	end

	-- Can we use the ability?
	if s_AbilitySnacking:IsFullyCastable() == false then
		return
	end

	-- Get all the creatures within 150.0 units
	local snackingRange = 150.0
	local creatureArray =  FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, snackingRange, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 0, false )
	if #creatureArray == 0 then
		return 3.0
	end

	-- Go through the list and see if we have any snacks	
	local bestCreature = nil
	for i = 1, #creatureArray do
		local creature = creatureArray[i]

		-- Red snacks have priority
		local isSnackRed = string.find( creature:GetUnitName(), "npc_dota_creature_snack_red" )
		if isSnackRed then
			bestCreature = creature
			break
		end

		local isSnackBlue = string.find( creature:GetUnitName(), "npc_dota_creature_snack_blue" )
		if isSnackBlue then
			bestCreature = creature
		end
	end

	if bestCreature then
		thisEntity:CastAbilityOnTarget( bestCreature, s_AbilitySnacking, 0 )
	end

	return 3.0
end

