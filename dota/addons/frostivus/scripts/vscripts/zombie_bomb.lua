s_EntityAncient = Entities:FindByName( nil, "dota_goodguys_fort" )

--[[-------------------------------------------------------------------------
	Setup the focus on ancient think on spawn
-----------------------------------------------------------------------------]]
function DispatchOnPostSpawn()
	AddThinkToEnt( thisEntity, "FocusAncientThink" )
end

--[[-------------------------------------------------------------------------
	Focus on ancient
-----------------------------------------------------------------------------]]
function FocusAncientThink()
	-- If the zombie is near the ancient then explode
	local distance = ( thisEntity:GetOrigin() - s_EntityAncient:GetOrigin() ):length()
	if distance < 400 then
		print( "Exploding!" )
		explode = thisEntity:FindAbilityByName( "creature_zombie_explode" )
		if explode then
			thisEntity:CastAbilityNoTarget( explode, -1 )
			thisEntity:ForceKill( false )

			-- Hack for damaging an invulnerable Ancient
			local health = s_EntityAncient:GetHealth()
			health = health - 1500
			s_EntityAncient:SetHealth( health )
			
			return nil
		end
	end

	return 1.0
end