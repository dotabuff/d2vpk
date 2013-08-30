"Resource/UI/DOTAAchievementItemPanel.res"
{
	controls
	{
		"DOTAAchievementItemPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAAchievementItemPanel"
			"wide"	 		"546"
			"tall"	 		"43"
			"zpos"			"2"
			"bgcolor_override" "0 0 0 0"
		}
		"Background"
		{
			"ControlName"		"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"wide"				"556"
			"tall"				"40"
			"mouseinputenabled"	"0"
		}

		"NameLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"NameLabel"
			"xpos"				"45"
			"ypos"				"4"
			"wide"				"300"
			"tall"				"15"
			"zpos"        "2"
			"textAlignment"			"west"
			"labelText"   "%name%"
			"style"				"AchievementNameStyle"
		}
		
		"DescriptionLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"DescriptionLabel"
			"xpos"				"45"
			"ypos"				"19"
			"wide"				"300"
			"tall"				"15"
			"zpos"        "2"
			"textAlignment"			"west"
			"labelText"   "%description%"
			"style"				"AchievementDescStyle"
		}
		
		"AchievementImage"
		{
			"ControlName"			"Label"
			"fieldName"			"AchievementImage"
			"xpos"				"1"
			"ypos"				"1"
			"wide"				"38"
			"tall"				"38"
			"scaleImage"		"1"
			"mouseinputenabled"	"0"
		}
		"ProgressLabel"
		{
		  "ControlName"	"Label"
		  "fieldName"		"ProgressLabel"
		  "xpos"			"505"
		  "ypos"			"5"
		  "wide"			"100"
		  "tall"			"10"
		  "labelText"   "%progress%"
		  "style"				"StatLabel"
		}
		"ProgressBar"
		{
		  "ControlName"	"ProgressBar"
		  "fieldName"		"ProgressBar"
		  "xpos"			"400"
		  "ypos"      "5"
		  "wide"			"100"
		  "tall"			"11"
		}
	}
	
	"colors"
	{
		AchievementNameColor="255 255 255 255"
		AchievementDescColor="138 138 138 255"
	}
	
	styles
	{
		"AchievementNameStyle"
		{
			textcolor=AchievementNameColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		
		"AchievementDescStyle"
		{
			textcolor=AchievementDescColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
	}
	
	include="resource/UI/dashboard_style.res"
}