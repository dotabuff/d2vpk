require( "utils/class" )
require( "utils/library" )
require( "utils/deepprint" )
require( "utils/vscriptinit" )

function ScriptFunctionHelp( scope )
	if scope then
		if scope == "global" then
			for _,func in pairs( FDesc ) do
				print( "\t" .. tostring( func ) )
			end
		elseif CDesc[scope] then
			for _,func in pairs( CDesc[scope].FDesc ) do
				print( "\t" .. tostring( func ) )
			end
		else
			print( "Unable to find scope: " .. scope )
		end
	else
		print( "Usage: \"dota_script_help <scope>\" where <scope> is one of the following:\n\tglobal" )

		for className,class in pairs( CDesc ) do
			print( "\t" .. className )
		end
	end
end

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
