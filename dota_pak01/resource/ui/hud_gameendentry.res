"Resource/UI/HUD_EndGameEntry.res"
{
	controls
	{
		"Background"
		{
			"ControlName"		"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"wide"				"666"
			"tall"				"20"
			//"bgColor_override"	"32 32 32 255"
			style=EntryGradient
			"zpos"				"-1"
			"Group"				"PlayerDetails"
		}

		HeroImage { ControlName=ImagePanel fieldName=HeroImage xpos=140 ypos=0 wide=20 tall=20 scaleImage=1 group=PlayerDetails }
		
		PlayerLabel { ControlName=Label fieldName=PlayerLabel xpos=5 ypos=0 wide=150 tall=20 textAlignment=west font=Arial12Thick fgColor_override="255 255 255 255" bgColor_override="0 0 0 0" group=PlayerDetails }
		LevelLabel { ControlName=Label fieldName=LevelLabel xpos=110 ypos=0 wide=27 tall=20 textAlignment=west font=Arial12Thick fgColor_override="255 255 255 255" bgColor_override="0 0 0 0" group=PlayerDetails }
		HeroLabel { ControlName=Label fieldName=HeroLabel xpos=162 ypos=0 wide=80 tall=20 textAlignment=west font=Arial12Thick fgColor_override="255 255 255 255" bgColor_override="0 0 0 0" group=PlayerDetails }
		KDALabel { ControlName=Label fieldName=KDALabel xpos=272 ypos=0 wide=100 tall=20 textAlignment=west font=Arial12Thick fgColor_override="255 255 255 255" bgColor_override="0 0 0 0" group=PlayerDetails }
			
		ItemImage0 { ControlName=ImagePanel fieldName=ItemImage0 xpos=330 ypos=2 wide=16 tall=16 scaleImage=1 group=PlayerDetails }
		ItemImage1 { ControlName=ImagePanel fieldName=ItemImage1 xpos=346 ypos=2 wide=16 tall=16 scaleImage=1 group=PlayerDetails }
		ItemImage2 { ControlName=ImagePanel fieldName=ItemImage2 xpos=362 ypos=2 wide=16 tall=16 scaleImage=1 group=PlayerDetails }
		ItemImage3 { ControlName=ImagePanel fieldName=ItemImage3 xpos=378 ypos=2 wide=16 tall=16 scaleImage=1 group=PlayerDetails }
		ItemImage4 { ControlName=ImagePanel fieldName=ItemImage4 xpos=394 ypos=2 wide=16 tall=16 scaleImage=1 group=PlayerDetails }
		ItemImage5 { ControlName=ImagePanel fieldName=ItemImage5 xpos=410 ypos=2 wide=16 tall=16 scaleImage=1 group=PlayerDetails }
		
		LevelLabel { ControlName=Label fieldName=LevelLabel xpos=110 ypos=0 wide=27 tall=20 textAlignment=west font=Arial12Thick fgColor_override="255 255 255 255" bgColor_override="0 0 0 0" group=PlayerDetails }
		GoldLabel { ControlName=Label fieldName=GoldLabel xpos=445 ypos=0 wide=45 tall=20 textAlignment=west font=Arial12Thick fgColor_override="255 255 255 255" bgColor_override="0 0 0 0" group=PlayerDetails }
		
		LastHitsLabel { ControlName=Label fieldName=LastHitsLabel xpos=483 ypos=0 wide=30 tall=20 textAlignment=west font=Arial12Thick fgColor_override="255 255 255 255" bgColor_override="0 0 0 0" group=PlayerDetails }
		DeniesLabel { ControlName=Label fieldName=DeniesLabel xpos=530 ypos=0 wide=30 tall=20 textAlignment=west font=Arial12Thick fgColor_override="255 255 255 255" bgColor_override="0 0 0 0" group=PlayerDetails }
		GoldPerMinuteLabel { ControlName=Label fieldName=GoldPerMinuteLabel xpos=575 ypos=0 wide=30 tall=20 textAlignment=west font=Arial12Thick fgColor_override="255 255 255 255" bgColor_override="0 0 0 0" group=PlayerDetails }
		XPPerMinuteLabel { ControlName=Label fieldName=XPPerMinuteLabel xpos=630 ypos=0 wide=30 tall=20 textAlignment=west font=Arial12Thick fgColor_override="255 255 255 255" bgColor_override="0 0 0 0" group=PlayerDetails }
	}
	
	colors
	{
		"EntryGradientTop"		"0 0 0 255"
		"EntryGradientBottom"	"0 0 0 255"
	}
	
	styles
	{
		EntryGradient
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, EntryGradientTop, EntryGradientBottom )"
			}
		}
	}
}

