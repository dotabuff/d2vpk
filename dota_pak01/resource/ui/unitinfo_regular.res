"Resource/UI/UnitHealthBar_Regular.res"
{
	"HudDOTAUnitHealthBarsElement"
	{
		"ControlName"		"EditablePanel"
		"fieldName"		"HudDOTAUnitHealthBarsElement"
		"zpos"			"0"
		"visible"		"1"
		"enabled"		"1"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"37"
		"tall"			"47"
	}

	"UnitHealthBarBackground"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"UnitHealthBarBackground"
		"xpos"			"1"
		"ypos"			"5"
		"wide"			"105"
		"tall"			"102"
		"zpos"			"3"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"image"			"hud/hud_healthbar_creeps_bg"
	}

	"UnitHealthBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitHealthBar"
		"xpos"			"1"
		"ypos"			"3"
		"wide"			"105"
		"tall"			"105"
		"zpos"			"4"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"image"			"vgui\hud\hud_healthbar_creepempty_team"
		"background_image"	"vgui\hud\hud_healthbar_creepfull_team"
		"fgColor_override" 	"0 0 0 0"
		"bgcolor_override"	"0 0 0 0"
	}

}
