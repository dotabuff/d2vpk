//------------------------------------
// Generic Matchmaking Dialog
//------------------------------------
"GenericMatchmakingDialog.res"
{	
	"GenericMatchmakingDialog"
	{
		"ControlName"		"CGenericMatchmakingDialog"
		"fieldName"		"GenericMatchmakingDialog"
		"xpos"		"310"
		"ypos"		"100"
		"wide"		"400"
		"tall"		"400"
		"autoResize"				"0"
		"pinCorner"					"0"
		"visible"					"1"
		"enabled"					"1"
		"tabPosition"				"0"
		"settitlebarvisible"		"1"
		"title"						"#GameUI_Matchmaker_Title"
		"borderwidth"				"15"
	}
	
	"Back" //back button
	{
		"ControlName"		"Button"
		"fieldName"		"Back"
		"xpos"		"314"
		"ypos"		"368"
		"wide"		"70"
		"tall"		"24"
		"autoResize"		"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"4"
		"labelText"		"#GameUI_Back"
		"textAlignment"		"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"0"
		"Command"		"Close"
		"Default"		"0"
	}
	
	"Lobby" //lobby button
	{
		"ControlName"		"Button"
		"fieldName"		"Lobby"
		"xpos"		"154"
		"ypos"		"368"
		"wide"		"150"
		"tall"		"24"
		"autoResize"		"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"4"
		"labelText"		"#GameUI_MatchMaker_CreateLobby"
		"textAlignment"		"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"0"
		"Command"		"CreateLobby"
		"Default"		"0"
	}
	
	"listpanel_games"
	{
		"ControlName"		"PanelListPanel"
		"fieldName"		"listpanel_games"
		"xpos"		"15"
		"ypos"		"40"
		"wide"		"370"
		"tall"		"324"
		"autoResize"		"3"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
	}
	
	"listpanel_background"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"listpanel_background"
		"xpos"		"15"
		"ypos"		"40"
		"wide"		"370"
		"tall"		"324"
		"fillcolor"	"32 32 32 255"
		"zpos"	"-3"
		"visible"		"1"
		"enabled"		"1"
		"pinCorner"		"0"
		"autoResize"		"3"
	}
}