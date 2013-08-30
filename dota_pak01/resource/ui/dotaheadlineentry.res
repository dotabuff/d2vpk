"Resource/UI/DOTAHeadlineEntry.res"
{
	controls
	{
		"DOTAHeadlineEntry"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAHeadlineEntry"
			"wide"	 		"384"
			"tall"	 		"32"
			"zpos"			"2"
			"bgcolor_override" "0 0 0 0"
		}

		"Date"
		{
			"ControlName"			"Label"
			"fieldName"			"Date"
			"xpos"				"0"
			"ypos"				"16"
			"wide"				"384"
			"tall"				"8"
			"textAlignment"			"west"
			"style"				"NewsDate"
			"mouseinputenabled"	"0"
		}
		"Headline"
		{
			"ControlName"			"Label"
			"fieldName"			"Headline"
			"xpos"				"0"
			"ypos"				"0"
			"wide"				"384"
			"tall"				"16"
			"textAlignment"			"west"
			"style"				"NewsHeadline"
			"mouseinputenabled"	"0" 
		}
	}
	
	include="resource/UI/dashboard_style.res"
	
	"colors"
	{
		NewsDateColor="162 162 162 255"
		NewsHeadlineColor="255 255 255 255"
	}
	
	"styles"
	{
		"NewsHeadline"
		{
			textcolor=StatLabelColor
			font=Arial14Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"NewsDate"
		{
			textcolor=NewsDateColor
			font=Arial11Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
	}
}