"Resource/UI/DOTAAlertsPanel.res"
{
	controls
	{
		"DOTAAlertsPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAAlertsPanel"
			"xpos"			"r256"
			"ypos"			"r256"
			"wide"	 		"256"
			"tall"	 		"256"
			"zpos"			"20"
			"bgcolor_override"	"0 0 0 0"
			"visible"		"1"
		}
		
		"Background"
		{
			"ControlName"		"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"0"
			"wide"				"256"
			"tall"				"256"
			"style"				"GreyNoiseBackground"
			"visible"			"1"
			"mouseInputEnabled"	"0"
		}
		
		"BackgroundInner"
		{
			"ControlName"		"Panel"
			"fieldName"			"BackgroundInner"
			"xpos"				"4"
			"ypos"				"20"
			"zpos"				"0"
			"wide"				"248"
			"tall"				"232"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			"mouseInputEnabled"	"0"
		}
		
		"Title"
		{
			"ControlName"			"Label"
			"fieldName"			"Title"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"256"
			"tall"				"20"			
			"textAlignment"		"center"
			"labelText"			"LATEST"	// TODO: Localize
			"style"				"DashboardTitle"
			"mouseInputEnabled"	"0"
		}
	}
	
	include="resource/UI/dashboard_style.res"
	
	colors
	{
	}
	
	styles
	{
	}
}
