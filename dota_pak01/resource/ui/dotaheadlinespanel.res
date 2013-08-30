"Resource/UI/DOTAHeadlinesPanel.res"
{
	controls
	{
		"DOTAHeadlinesPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAHeadlinesPanel"
			//"xpos"				"8"
			"ypos"				"0"
			"zpos"				"0"
			//"wide"				"1016"
			"tall"				"416"
			"mouseinputenabled"	"1"
			"zpos"				"3"
			bgcolor_override="0 0 0 0"
		}
		
		"Background"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background"
			//"xpos"				"100"
			"ypos"				"0"
			"zpos"				"0"
			//"wide"				"816"
			"tall"				"416"
			visible=1
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "0 0 0 255"
			mouseInputEnabled=0
			zpos=3
		}
		
		"HTML"
		{
			"ControlName"			"Panel"
			"fieldName"			"HTML"
			//"xpos"				"100"
			"ypos"				"2"
			"zpos"				"0"
			//"wide"				"816"
			"tall"				"412"
			"mouseinputenabled"	"1"
			"zpos"				"4"
			bgcolor_override="0 0 0 0"
			visible=1
		}
		
		"HomeButton"
		{
			"ControlName"			"Button"
			"fieldName"			"HomeButton"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"5"
			"wide"				"70"
			"tall"				"14"
			"textAlignment"		"north-west"
			"labelText"			"HOME"	// TODO: Localize
			"command"			"Home"
		}
	}
	include="resource/UI/dashboard_style.res"
	
	styles
	{
		include="resource/UI/dashboard_style.res"
	}	
}
