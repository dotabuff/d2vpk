//------------------------------------
// Matchmaker Item
//------------------------------------
"GenericMatchMakingItem.res"
{	
	"GenericMatchmakingDialogItemPanel"
	{
		"ControlName"	"CGenericMatchmakingDialogItemPanel"
		"fieldName"		"GenericMatchmakingDialogItemPanel"
		"xpos"						"0"	
		"ypos"						"0"
		"wide"						"594"
		"tall"						"64"
		"autoResize"				"0"
		"visible"					"1"
		"enabled"					"1"
		"tabPosition"				"0"
		"settitlebarvisible"		"0"
		"pinCorner"					"0"
		"ProgressBarColor" 	"200 184 148 255" [$WIN32]
		"PaintBackgroundType"	"2"
	}
			
	"GameName"
	{
		"ControlName"	"label"
		"fieldName"		"GameName"
		"labeltext"		"name"
		"xpos"			"10"
		"ypos"			"2"
		"wide"			"256"
		"tall"			"20"
		"font"			"AchievementItemTitle"
		"textAlignment"		"west"
	}
	
	"GameDesc"
	{
		"ControlName"	"label"
		"fieldName"		"GameDesc"
		"labeltext"		"desc"
		"xpos"			"15"
		"ypos"			"22"
		"wide"			"490"
		"tall"			"40"
		"font"			"AchievementItemDescription"
		"wrap"			"1"
		"textAlignment"		"north-west"
	}
}
