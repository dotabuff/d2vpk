"Resource/UI/Chat.res"
{
	controls
	{
		"DOTAChatPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAChatPanel"
			"xpos"			"4"
			"ypos"			"22"
			wide=f0
			tall=256
			"zpos"			"20"
			"PaintBackground"	"0"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "0 0 0 0"
			"TabStartX"		"2"
			"TabStartY"		"2"
			"TabPadding"	"3"
			"visible"		"1"
		}
		
		"Background"
		{
			"ControlName"			"ImagePanel"
			"fieldName"			"Background"
			"scaleImage"			"1"
			//"image"			
			"fillcolor"			"46 43 39 255"
			"visible"			"0"
			"mouseInputEnabled"	"0"
		}	
		
		"NewChatChannelButton"
		{
			"ControlName"			"Button"
			"fieldName"			"NewChatChannelButton"
			"zpos"				"2"
			"visible"			"1"
			"ypos"				"2"
			"tall"				"18"
			//"auto_wide_tocontents"		"1"
			"wide"				"16"
			"style"				"TabButton"
		}
	
		"ChannelTabsBackground"
		{
			"ControlName"		"Panel"
			"fieldName"			"ChannelTabsBackground"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"-1"
			//"wide"				"440"
			"tall"				"20"
			"style"				"TabBarBackground"
		}
		
		"ParticipantsBackground"
		{
			"ControlName"		"Panel"
			"fieldName"			"ParticipantsBackground"
			"wide"				"100"
			"tall"				"20"
			"style"				"TabBarBackground"
		}
		
		"ParticipantsLabel"
		{
			"ControlName"		"Label"
			"fieldName"			"ParticipantsLabel"
			"zpos"				"5"
			"wide"				"100"
			"tall"				"20"
			"textAlignment"		"west"
			"labelText"			"PARTICIPANTS"
			style=ParticipantsLabelStyle
		}
	}
	
	styles
	{
		ParticipantsLabelStyle
		{
			"textcolor"		"TabButtonText"
			font=Arial12Thick
			
			render_bg
			{
				0="fill(x0,y0,x1,y1,0)"
			}
		}
	}
	include="resource/UI/dashboard_style.res"
	
	layout
	{
	}
}
