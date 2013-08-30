"Resource/UI/DOTAJoinChatPanel.res"
{
	controls
	{
		"DOTAJoinChatPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAJoinChatPanel"
			"xpos"			"c-228"
			"ypos"			"c-180"
			"wide"	 		"456"
			"tall"	 		"360"
			"zpos"			"100"
			"TabStartX"		"12"
			"TabStartY"		"5"
			"TabPadding"	"3"
		}
		
		"Background"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"1"
			"wide"				"f0"
			"tall"				"f0"
			"style"				"GradientBackground"
		}
		
		"JoinChatPrompt"
		{
			"ControlName"			"Label"
			"fieldName"			"JoinChatPrompt"
			"xpos"				"12"
			"ypos"				"290"
			"zpos"				"3"
			"wide"				"60"
			"tall"				"19"
			"fgcolor_override"	"255 255 255 255"
			"bgcolor_override"	"0 0 0 255"
			"font"				"Arial12Med"
			"labelText"			"#dota_join_chat_channel_prompt"
		}
		
		"DOTAJoinChatEntry"
		{
			"ControlName"			"DOTAJoinChatEntry"
			"fieldName"			"DOTAJoinChatEntry"
			"xpos"				"70"
			"ypos"				"290"
			"zpos"				"3"
			"wide"				"200"
			"tall"				"19"
			"bgcolor_override"	"0 0 0 255"
			"font"				"Arial12Med"
		}
		"JoinButton"
		{
			"ControlName"			"Button"
			"fieldName"			"JoinButton"
			"xpos"				"360"
			"ypos"				"290"
			"zpos"				"3"
			"wide"				"80"
			"tall"				"19"
			"labelText"			"#dota_join_chat_channel_button"
			"textAlignment"		"center"
		}
		"CloseButton"
		{
			"ControlName"			"Button"
			"fieldName"			"CloseButton"
			"xpos"				"430"
			"ypos"				"5"
			"zpos"				"3"
			"wide"				"16"
			"tall"				"19"
			"labelText"			"X"
			"textAlignment"		"center"
			"Command"			"CloseClicked"
		}
	}
	
	colors
	{
		"DashboardGradientTop"		"50 50 50 255"
		"DashboardGradientBottom"	"0 0 0 255"
		"TopBarButtonLight"			"97 97 97 255"
		"TopBarBG"					"58 58 58 255"
	}
		
	styles
	{
		GradientBackground
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, DashboardGradientTop, DashboardGradientBottom )"
			}
		}
	}
}
