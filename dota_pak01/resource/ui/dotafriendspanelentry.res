"Resource/UI/DOTAFriendsPanelEntry.res"
{
	controls
	{
		"DOTAFriendsPanelEntry"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAFriendsPanelEntry"
			"visible" 		"1"
			"enabled" 		"1"
			"wide"	 		"150"
			"tall"	 		"24"
			"bgcolor_override" "0 0 0 0"
		}
		
		"Avatar"
		{
			"ControlName"		"CAvatarImagePanel"
			"fieldName"		"Avatar"
			"xpos"			"0"
			"ypos"			"2"
			"wide"			"20"
			"tall"			"20"
			"visible"		"1"
			"enabled"		"1"
			"scaleImage"		"1"
			"autoResize"		"0"
			"pinCorner"		"0"
			"fgcolor_override" 	"255 255 255 255"
			"drawcolor_override" 	"255 255 255 255"
			"alpha"			"255"
			"zpos"			"3"
		}

		"PlayerName"
		{
			"ControlName"			"Button"
			"fieldName"			"PlayerName"
			"xpos"				"24"
			"ypos"				"2"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"14"
			"textAlignment"			"north-west"
			"auto_wide_tocontents"		"1"
			"labelText"			"%playername%"
			"style"				"SmallButton"
			"textinsetx"			"1"
			"textinsety"			"1"
			"command"			"PlayerButton"
		}
		
		"HeaderLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"HeaderLabel"
			"xpos"				"0"
			"ypos"				"2"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"20"
			"textAlignment"			"south-west"
			"auto_wide_tocontents"		"1"
			"labelText"			"%header%"
			"style"				"SectionTitle"
		}
	}
	include="resource/UI/dashboard_style.res"	
}
