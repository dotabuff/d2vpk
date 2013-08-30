"Resource/UI/DOTACommunityPanel.res"
{
	controls
	{
		"DOTACommunityPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTACommunityPanel"
			"visible" 		"1"
			"enabled" 		"1"
			"xpos"			"257"
			"ypos"			"r256"
			"tall"	 		"256"
			"zpos"			"20"
			"PaintBackground"	"0"
		}
		
		"Background"
		{
			"ControlName"		"Panel"
			"fieldName"			"Background"
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
			"tall"				"232"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			"mouseInputEnabled"	"0"
		}
		
		"Title"
		{
			"ControlName"		"Label"
			"fieldName"			"Title"
			//"xpos"				"5"
			"ypos"				"0"
			"zpos"				"8"
			//"wide"				"576"
			"tall"				"20"
			"textAlignment"		"center"
			"labelText"			"COMMUNICATION"		// TODO: Localize
			"style"				"DashboardTitle"
		}
	}
	
	include="resource/UI/dashboard_style.res"
	
	layout
	{
	}
}
