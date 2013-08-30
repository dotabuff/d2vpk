"Resource/UI/DOTAMatchHistoryPlayerRow.res"
{
	"DOTAMatchHistoryPlayerRow"
	{
		"ControlName"		"EditablePanel"
		"fieldName" 		"DOTAMatchHistoryPlayerRow"
		"wide"	 		"556"
		"tall"	 		"24"
		"bgcolor_override" "0 0 0 0"
	}
	"Background"
	{
		"ControlName"		"Panel"
		"fieldName"			"Background"
		"xpos"				"0"
		"ypos"				"0"
		"wide"				"543"
		"tall"				"20"
		"bgColor_override"	"0 0 0 128"
	}

	"PlayerLabel"
	{
		"ControlName"			"Button"
		"fieldName"			"PlayerLabel"
		"xpos"				"5"
		"ypos"				"0"
		"wide"				"120"
		"tall"				"20"
		"textAlignment"			"west"
		"command"			"ShowProfile"
		visible=1
		zpos=5
	}
	
	"HeroImage"
	{
		"ControlName"			"Label"
		"fieldName"			"HeroImage"
		"xpos"				"140"
		"ypos"				"0"
		"wide"				"20"
		"tall"				"20"
		"scaleImage"		"1"
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
		Style=StatLabel
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
		Style=StatLabel
	}
	
	"ItemImage0" { ControlName=ImagePanel fieldName=ItemImage0 xpos=330 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
	"ItemImage1" { ControlName=ImagePanel fieldName=ItemImage1 xpos=346 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
	"ItemImage2" { ControlName=ImagePanel fieldName=ItemImage2 xpos=362 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
	"ItemImage3" { ControlName=ImagePanel fieldName=ItemImage3 xpos=378 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
	"ItemImage4" { ControlName=ImagePanel fieldName=ItemImage4 xpos=394 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
	"ItemImage5" { ControlName=ImagePanel fieldName=ItemImage5 xpos=410 ypos=2 zpos=2 wide=16 tall=16 scaleImage=1 }
		
	"LevelLabel"
	{
		"ControlName"			"Label"
		"fieldName"			"LevelLabel"
		"xpos"				"110"
		"ypos"				"0"
		"wide"				"27"
		"tall"				"20"
		"textAlignment"			"east"
		Style=StatLabel
	}
	"GoldLabel"
	{
		"ControlName"			"Label"
		"fieldName"			"GoldLabel"
		"xpos"				"475"
		"ypos"				"0"
		"wide"				"45"
		"tall"				"20"
		"textAlignment"			"west"
		Style=StatLabel
	}
	include="resource/UI/dashboard_style.res"
}