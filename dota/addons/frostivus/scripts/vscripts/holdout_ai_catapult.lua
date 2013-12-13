--[[
Catapult AI
]]

s_AbilityCatapultAttack = thisEntity:FindAbilityByName( "catapult_attack" )
s_AbilityCatapultDisembark = thisEntity:FindAbilityByName( "catapult_disembark" )
local s_DisembarkTimeMin = 25.0
local s_DisembarkTimeMax = 35.0
local s_NextDisembarkTime = 0.0

function DispatchOnPostSpawn()
	AddThinkToEnt( thisEntity, "CatapultAIThink" )

	s_NextDisembarkTime = GameRules:GetGameTime() + RandomFloat( 10, 15 )
end

function CatapultAIThink()

	-- Get the current time
	local currentTime = GameRules:GetGameTime()

	-- Determine if we need to disembark or not
	if s_NextDisembarkTime < currentTime then
		local orderDisembark = {}
		orderDisembark.UnitIndex = thisEntity:entindex()
		orderDisembark.OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET
		orderDisembark.AbilityIndex = s_AbilityCatapultDisembark:entindex()
		ExecuteOrderFromTable( orderDisembark )

		print ( "disembark" )

		s_NextDisembarkTime = currentTime + RandomFloat( s_DisembarkTimeMin, s_DisembarkTimeMax )

		return 2.5
	end

	if s_AbilityCatapultAttack then

		local radius = s_AbilityCatapultAttack:GetSpecialValueFor("explosion_radius")
		local minRange = s_AbilityCatapultAttack:GetSpecialValueFor("mindistance")
		local range = s_AbilityCatapultAttack:GetCastRange()
		local maxAdjacentHeroes = 0
		local bestHero
		
		for i = 0, HeroList:GetHeroCount()-1 do
			--print( "i: " .. i )
		
			local hero = HeroList:GetHero( i )
			local distanceToHero = #(thisEntity:GetOrigin() - hero:GetOrigin())
			
			--print("dist: " .. distanceToHero)
			
			if hero:IsAlive() and range > distanceToHero and minRange < distanceToHero then
			
				local adjacentHeroes = 1
				
				for j = 0, HeroList:GetHeroCount()-1 do
					if j ~= i then
						local otherHero = HeroList:GetHero( j )
						local separation = hero:GetOrigin() - otherHero:GetOrigin()
						local distanceBetweenHeroes = #separation
						
						--print("j: " .. j)
						--print("distbetween: " .. distanceBetweenHeroes)
						
						if otherHero:IsAlive() and distanceBetweenHeroes < radius then
							adjacentHeroes = adjacentHeroes + 1
						end
					end
				end
			
				--print("adjacent: " .. adjacentHeroes)
			
				if maxAdjacentHeroes < adjacentHeroes or 
					(maxAdjacentHeroes == adjacentHeroes and RandomInt(0,1) == 1) then
					
					maxAdjacentHeroes = adjacentHeroes
					bestHero = hero
				end
			end
		end
		
		if bestHero then
			local order = {}
			
			order.UnitIndex = thisEntity:entindex()
			order.OrderType = DOTA_UNIT_ORDER_CAST_POSITION
			order.Position = bestHero:GetOrigin()
			order.AbilityIndex = s_AbilityCatapultAttack:entindex()
			ExecuteOrderFromTable( order )
		
			return 3.5
		end
	end

	return 1.0
end
