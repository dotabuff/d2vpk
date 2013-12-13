--[[
Broodking AI
]]

function DispatchOnPostSpawn()
	AddThinkToEnt( thisEntity, "BroodkingThink" )
end

local ABILITY_spin_web = thisEntity:FindAbilityByName( "creature_spin_web" )

local ABILITY_spawn_broodmother = thisEntity:FindAbilityByName( "creature_spawn_broodmother" )
if ABILITY_spawn_broodmother == nil then
	ABILITY_spawn_broodmother = thisEntity:FindAbilityByName( "creature_spawn_broodmother_eggs" )
end
-- ENTITY_ancient = Entities:FindByName( nil, "dota_goodguys_fort" )

POSITIONS_retreat = Entities:FindAllByName( "waypoint_*" )
for i = 1, #POSITIONS_retreat do
	POSITIONS_retreat[i] = POSITIONS_retreat[i]:GetOrigin()
end

function BroodkingThink()
	if not thisEntity:IsAlive() then
		local web = Entities:FindByClassname( nil, "npc_dota_broodmother_web" )
		while web do
			local thisWeb = web
			web = Entities:FindByClassname( web, "npc_dota_broodmother_web" )
			thisWeb:ForceKill( false )
		end
		return nil
	end

	-- Spawn a broodmother whenever we're able to do so.
	if ABILITY_spawn_broodmother:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = ABILITY_spawn_broodmother:entindex()
		})
		return 0.1
	end

	return IdleWander()
end


local escapePoint = nil
local flWaitUntilTime = 0
local nWaitUntilHP = 0
function IdleWander()
	if escapePoint ~= nil then
		if (thisEntity:GetOrigin() - escapePoint):length() < 300 then
			escapePoint = nil
			flWaitUntilTime = GameRules:GetGameTime() + RandomFloat( 10, 15 ) -- Wait 10 - 15 seconds at the destination
			nWaitUntilHP = math.floor( thisEntity:GetHealth() - thisEntity:GetMaxHealth() * 0.1 ) -- Wait until we've lost some health
			-- Drop a web here, if we can.
			if ABILITY_spin_web:IsFullyCastable() then
				ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_STOP,
					Queue = false
				})
				ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = ABILITY_spin_web:entindex()
				})
			end
		end
	end

	if escapePoint == nil then
		if flWaitUntilTime > GameRules:GetGameTime() and nWaitUntilHP < thisEntity:GetHealth() then
			return 0.2
		end
		flWaitUntilTime = 0
		nWaitUntilHP = 0

		local happyPlaceIndex =  RandomInt( 1, #POSITIONS_retreat )
		escapePoint = POSITIONS_retreat[ happyPlaceIndex ]
	end
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = escapePoint,
		Queue = false
	})

	return RandomFloat( 0.1, 1.0 )
end


function DropMarkerFX( pt )
	-- Drop an effect where we're moving to
	local nFXIndex = ParticleManager:CreateParticle( "veil_of_discord", PATTACH_CUSTOMORIGIN, thisEntity )
	ParticleManager:SetParticleControl( nFXIndex, 0, pt )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vec3( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end
