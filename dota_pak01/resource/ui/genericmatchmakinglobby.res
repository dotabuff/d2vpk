//------------------------------------
// Generic Matchmaking Dialog
//------------------------------------
"GenericMatchmakingDialog.res"
{	
	"GenericMatchmakingLobby"
	{
		"ControlName"		"CGenericMatchmakingLobby"
		"fieldName"		"GenericMatchmakingLobby"
		"xpos"		"100"
		"ypos"		"100"
		"wide"		"200"
		"tall"		"300"
		"autoResize"				"0"
		"pinCorner"					"0"
		"visible"					"1"
		"enabled"					"1"
		"tabPosition"				"0"
		"settitlebarvisible"		"1"
		"title"						"#GameUI_Matchmaker_Lobby_Title"
		"borderwidth"				"15"
	}
	
	"Back" //back button
	{
		"ControlName"		"Button"
		"fieldName"		"Back"
		"xpos"		"115"
		"ypos"		"270"
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
	
	
	"Launch" //back button
	{
		"ControlName"		"Button"
		"fieldName"		"Launch"
		"xpos"		"15"
		"ypos"		"270"
		"wide"		"70"
		"tall"		"24"
		"autoResize"		"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"4"
		"labelText"		"#GameUI_Matchmaking_Launch"
		"textAlignment"		"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"0"
		"Command"		"LaunchGame"
		"Default"		"0"
	}
	
	"listpanel_players"
	{
		"ControlName"		"PanelListPanel"
		"fieldName"		"listpanel_players"
		"xpos"		"15"
		"ypos"		"45"
		"wide"		"170"
		"tall"		"167"
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
		"ypos"		"45"
		"wide"		"170"
		"tall"		"167"
		"fillcolor"	"32 32 32 255"
		"zpos"	"-3"
		"visible"		"1"
		"enabled"		"1"
		"pinCorner"		"0"
		"autoResize"		"3"
	}
	
	"mode_selector_combo"
	{
		"ControlName"	"ComboBox"
		"fieldName"		"mode_selector_combo"
		"xpos"			"15"
		"ypos"			"215"
		"wide"			"170"
		"tall"			"24"
		"enabled"		"1"
		"visible"		"1"
		"editable"		"0"
	}
	
	
	"maxplayers_text"
	{
		"ControlName"		"Label"
		"fieldName"		"maxplayers_text"
		"xpos"		"15"
		"ypos"		"242"
		"wide"		"120"
		"tall"		"20"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"labelText"		"#GameUI_Matchmaker_Maxplayers"
		"textAlignment"		"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"0"
		"fillcolor"	"255 255 255 255"
		"font"		"AchievementItemDescription"	//"defaultlarg"
	}
	
	"maxplayers_combo"
	{
		"ControlName"	"ComboBox"
		"fieldName"		"maxplayers_combo"
		"xpos"			"135"
		"ypos"			"242"
		"wide"			"50"
		"tall"			"24"
		"enabled"		"1"
		"visible"		"1"
		"editable"		"0"
	}
}