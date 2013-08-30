"Resource/UI/DOTAHeroesPlayedEntry.res"
{
	controls
	{
		"DOTAHeroesPlayedEntry"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAHeroesPlayedEntry"
			"wide"	 		"556"
			"tall"	 		"24"
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
			"tall"				"20"
			"mouseinputenabled"	"0"
			"bgcolor_override"	"39 39 39 255"
		}
		"HeroImage"
		{
			"ControlName"			"Label"
			"fieldName"			"HeroImage"
			"xpos"				"0"
			"ypos"				"0"
			"wide"				"20"
			"tall"				"20"
			"scaleImage"		"1"
			"mouseinputenabled"	"0"
			"zpos"				"2"
		}
		
		"HeroLabel"	{ ControlName=Label fieldName=HeroLabel xpos=25 ypos=0 wide=100 tall=15 textAlignment="west" labelText="%heroname%" style="StatLabel" }		// TODO: Localize
		"WinsLabel"	{ ControlName=Label fieldName=WinsLabel xpos=159 ypos=0 wide=40 tall=15 textAlignment="east" labelText="%wins%" style="StatLabel" }
		"LossesLabel"	{ ControlName=Label fieldName=LossesLabel xpos=238 ypos=0 wide=40 tall=15 textAlignment="east" labelText="%losses%" style="StatLabel" }
	}
	
	include="resource/UI/dashboard_style.res"
}