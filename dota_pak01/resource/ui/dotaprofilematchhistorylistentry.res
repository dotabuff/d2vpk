"Resource/UI/DOTAMatchHistoryListEntry.res"
{
	controls
	{
		"Background"
		{
			"ControlName"		"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"wide"				"556"
			"tall"				"20"
			"mouseinputenabled"	"0"
			"visible"			"0"
		}

		"DateLabel"
		{
			"ControlName"			"Button"
			"fieldName"			"DateLabel"
			"xpos"				"17"
			"ypos"				"0"
			"wide"				"150"
			"tall"				"14"
			"textAlignment"			"west"
			"labelText"			"%date%"
			"style"				"SmallButton"
			"mouseinputenabled"	"1"
			"command"			"ShowMatchDetails"
		}
		
		"HeroImage"
		{
			"ControlName"			"Label"
			"fieldName"			"HeroImage"
			"xpos"				"0"
			"ypos"				"0"
			"wide"				"14"
			"tall"				"14"
			"scaleImage"		"1"
			"mouseinputenabled"	"0"
		}
		"HeroLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"HeroLabel"
			"xpos"				"162"
			"ypos"				"0"
			"wide"				"80"
			"tall"				"20"
			"textAlignment"			"west"
			"style"				"StatLabel"
			"mouseinputenabled"	"0"
			"visible"			"0"
		}
		
		"KDALabel"
		{
			"ControlName"			"Label"
			"fieldName"			"KDALabel"
			"xpos"				"272"
			"ypos"				"0"
			"wide"				"100"
			"tall"				"20"
			"textAlignment"			"west"
			"style"				"StatLabel"
			"mouseinputenabled"	"0"
			"visible"			"0"
		}
		
		"ItemImage0" { ControlName=Label fieldName=ItemImage0 xpos=330 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
		"ItemImage1" { ControlName=Label fieldName=ItemImage1 xpos=346 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
		"ItemImage2" { ControlName=Label fieldName=ItemImage2 xpos=362 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
		"ItemImage3" { ControlName=Label fieldName=ItemImage3 xpos=378 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
		"ItemImage4" { ControlName=Label fieldName=ItemImage4 xpos=394 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
		"ItemImage5" { ControlName=Label fieldName=ItemImage5 xpos=410 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
		
		"WinLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"WinLabel"
			"xpos"				"460"
			"ypos"				"0"
			"wide"				"100"
			"tall"				"20"
			"textAlignment"			"west"
			"style"				"StatLabel"
			"mouseinputenabled"	"0"
			"visible"			"0"
		}
	}
	
	include="resource/UI/dashboard_style.res"
}