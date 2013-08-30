"Resource/UI/DOTAHeroesPlayedPanel.res"
{
	controls
	{
		"DOTAUnderConstructionMessage"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAUnderConstructionMessage"
			"visible" 		"1"
			"enabled" 		"1"
			"xpos"			"0"
			"wide"	 		"f0"
			"tall"	 		"500"
			"zpos"			"21"
		}
		
		"Background"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"0"
			"wide"				"f0"
			"tall"				"500"
			bgcolor_override="0 0 0 240"
			mouseInputEnabled=0
		}
		
		"Background2"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background2"
			"xpos"				"c-200"
			"ypos"				"80"
			"zpos"				"0"
			"wide"				"400"
			"tall"				"180"
			bgcolor_override="0 0 0 230"
			mouseInputEnabled=0
			visible=0
		}
		
		"BackgroundInnerTop" { Controlname=Panel fieldName=BackgroundInnerTop xpos="c-200" ypos=80 zpos=0 wide=400 tall=180 style=DashboardPlayInnerBackground mouseInputEnabled=0 visible=0 }
		
		"Title" { ControlName=Label fieldName=Title xpos=c-200 ypos=100 wide=400 tall=16 style=StandardText labelText="Matchmaking not implemented yet." textAlignment=center }
		"Desc" { ControlName=Label fieldName=Desc xpos=c-200 ypos=140 wide=400 tall=16 style=StandardText labelText="Use PRACTICE mode for internal playtests." textAlignment=center }
		
		"CloseButton"
		{
			"ControlName"			"Button"
			"fieldName"			"CloseButton"
			"xpos"				"c-100"
			"ypos"				"200"
			"zpos"				"2"
			"wide"				"200"
			"tall"				"48"
			"textAlignment"		"center"
			"labelText"			"OKAY"
			"command"			"Close"
			style=GreyButtonStyle
		}
	}
	include="resource/UI/dashboard_style.res"
	
	styles
	{
		include="resource/UI/dashboard_style.res"
	}	
}
