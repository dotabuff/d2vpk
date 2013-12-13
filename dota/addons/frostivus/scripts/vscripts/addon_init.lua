-- This chunk of code forces the reloading of all modules when we reload script.
if g_reloadState == nil then
	g_reloadState = {}
	for k,v in pairs( package.loaded ) do
		g_reloadState[k] = v
	end
else
	for k,v in pairs( package.loaded ) do
		if g_reloadState[k] == nil then
			package.loaded[k] = nil
		end
	end
end

-- A function to re-lookup a function by name every time.
function Dynamic_Wrap( mt, name )
	if Convars:GetFloat( 'developer' ) == 1 then
		local function w(...) return mt[name](...) end
		return w
	else
		return mt[name]
	end
end

-- Going to store off some info when we precache units
UnitPrecacheData = {}

function PrecacheFrostivusUnit( name )
	if not UnitPrecacheData[name] then
		local unit = CreateUnitByName( name, Vec3(0,0,0), true, nil, nil, DOTA_TEAM_BADGUYS )
		if unit then
			UnitPrecacheData[name] = { xp = unit:GetDeathXP() }
			UTIL_RemoveImmediate( unit )
		end
	end
end

require( "frostivus" )
require( "frostivus_logging" )
require( "ai_core" )
