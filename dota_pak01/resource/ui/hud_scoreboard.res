"Resource/UI/HUD_Scoreboard.res"
{
	"HudDOTAScoreboardPanel"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"HudDOTAScoreboardPanel"
		"xpos"					"%1.3"
		"ypos"					"%10.0"
		"zpos"					"0"
		"wide"					"%29.75"
		"tall"					"%23.3"
		"visible"				"0"
		"enabled"				"0"
		"bgcolor_override"		"0 0 0 255"
		"fgcolor_override"		"0 0 0 255"
	}

	"ScoreboardBackground"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"ScoreboardBackground"
		"fillcolor"			"0 0 0 255"
		"xpos"				"%0"
		"ypos"				"%0"
		"zpos"				"-1"
		"wide"				"%29.75"
		"tall"				"%23.3"				// Add .5 for rounding error.
		"enabled"			"1"
		"visible"			"1"
	}
		
	"HeadingLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"HeadingLabel"
		"xpos"				"%0.75"
		"ypos"				"%1.5"
		"zpos"				"3"
		"wide"				"%27.75"
		"tall"				"%1.5"
		"enabled"			"1"
		"textAlignment"		"center"
		"labelText"			"#DOTA_Scoreboard"
		"font" 				"HudUnitSmall"
		"fgColor_override" 	"255 255 139 255"
		"bgcolor_override"	"26 26 26 255"
	}

	"GoodGuysLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"GoodGuysLabel"
		"xpos"				"%1"
		"ypos"				"%3.0"
		"zpos"				"3"
		"wide"				"%27.75"
		"tall"				"%1.5"
		"enabled"			"2"
		"textAlignment"		"left"
		"labelText"			"#DOTA_Scoreboard_GoodGuys"
		"font" 				"HudUnitSmall"
		"fgColor_override" 	"40 240 40 255"
		"bgcolor_override"	"26 26 26 255"
	}

	"BadGuysLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"BadGuysLabel"
		"xpos"				"%1"
		"ypos"				"%13.0"
		"zpos"				"3"
		"wide"				"%27.75"
		"tall"				"%1.5"
		"enabled"			"1"
		"textAlignment"		"left"
		"labelText"			"#DOTA_Scoreboard_BadGuys"
		"font" 				"HudUnitSmall"
		"fgColor_override" 	"240 40 40 255"
		"bgcolor_override"	"26 26 26 255"
	}
}
