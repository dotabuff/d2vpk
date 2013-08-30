//------------------------------------
// Matchmaker Item
//------------------------------------
"DOTAMatchmakingLobbyPlayer.res"
{	
	controls
	{
		"DOTAMatchmakingLobbyPlayer"
		{
			"ControlName"	"CDOTAMatchmakingLobbyPlayer"
			"fieldName"		"DOTAMatchmakingLobbyPlayer"
			"xpos"						"0"	
			"ypos"						"0"
			"wide"						"160"
			"tall"						"14"
			"paintbackground"			"0"
		}
				
		"PlayerName"
		{
			"ControlName"	"label"
			"fieldName"		"PlayerName"
			"labeltext"		"name"
			"xpos"			"0"
			"ypos"			"0"
			"wide"			"98"
			"tall"			"14"
			"textAlignment"		"west"
			"style"			"WhiteLabel"
			fgcolor_override="255 255 255 255"
		}
		
		"PlayerRank"
		{
			"ControlName"	"label"
			"fieldName"		"PlayerRank"
			"xpos"			"0"
			"ypos"			"0"
			"wide"			"120"
			"tall"			"14"
			"textAlignment"		"east"
			"style"			"RankLabel"
		}
	}
	
	include="resource/UI/dashboard_style.res"
	
	"colors"
	{
		White="255 255 255 255"
		RankLabelColor="128 128 128 255"
	}
	
	styles
	{
		WhiteLabel
		{
			textcolor=White
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		RankLabel
		{
			textcolor=RankLabelColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
	}
}
