function GenerateRing( arg, pointList )
	local center = pointList[1]
	local radius = arg.Radius or 100
	local count = arg.Count or 8

	local fwdVec = arg.caster:GetForwardVector()
	
	local v_x = fwdVec.x
	local v_y = fwdVec.y
	local v_len2 = v_x*v_x + v_y*v_y;
	if v_len2 > 0.001 then
		local v_len = math.sqrt( v_len2 )
		v_x = v_x / v_len
		v_y = v_y / v_len
	else
		v_x = 1
		v_y = 0
	end

	v_x = v_x * radius
	v_y = v_y * radius
	local result = {}
	for i = 1,count do
		local theta = (math.pi * 2) * ( ( i - 1 ) / count )
		local p_x = math.cos( theta ) * v_x + math.sin( theta ) * v_y
		local p_y = -math.sin( theta ) * v_x + math.cos( theta ) * v_y
		local v = center + Vec3( p_x, p_y, 0 )
		table.insert( result, v )
	end
	return result
end