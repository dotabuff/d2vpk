"Resource/UI/HUD_TooltipAchievement.res"
{
	"dota_tooltip"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"dota_tooltip"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"240"
		"tall"					"600"
		"visible"				"0"
		"enabled"				"1"
		"style"					"tooltipbackground"
	}

	"Name"
	{
		"ControlName"	"Label"
		"fieldName"		"Name"
		"zpos"			"1"
		"wide"			"235"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%name%"
		"textAlignment"	"west"
		"style"			"AbilityName"
	}
	
	"divider"
	{
		"ControlName"			"Panel"
		"fieldName"				"divider"
		"zpos"					"1"
		"wide"					"219"
		"tall"					"1"
		"visible"				"1"
		"enabled"				"1"
		"style"					"divider"
	}

// 	"background_description"
// 	{
// 		"ControlName"				"EditablePanel"
// 		"fieldName"				"background_description"
// 		"xpos"					"3"
// 		"ypos"					"3"
// 		"zpos"					"0"
// 		"wide"					"224"
// 		"tall"					"117"
// 		"visible"				"1"
// 		"enabled"				"1"
// 		"bgcolor_override"			"26 26 26 255"
// 		"fgcolor_override"			"26 26 26 255"
// 		"PaintBackgroundType"			"2"
// 		"pin_to_sibling"			"divider1"
// 		"pin_corner_to_sibling"			"0"
// 		"pin_to_sibling_corner"			"2"
// 	}

	"Description"
	{
		"ControlName"		"Label"
		"fieldName"		"Description"
		"font" 			"Arial10Thick"
		"xpos"			"-5"
		"ypos"			"-3"
		"zpos"			"1"
		"wide"			"219"
		"tall"			"5"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%description%"
		"textAlignment"		"west"
		"bgcolor_override"	"0 151 0 0"
		"fgcolor_override"	"255 255 255 175"
		"scrollbar"		"false"
		"wrap"	"1"
		"auto_tall_tocontents"	"1"
		"minimum-width"		"235"
	}

	styles
	{
		AbilityName
		{
			textcolor=white
			bgcolor=none
			font=DIN14Thick
		}
		divider
		{
			render
			{
				0="fill(x0,y0,x1,y1,dividergrey)"
			}
		}
		
		AbilityInfo
		{
			textcolor=tooltipgrey
			font=Arial8Thick
		}
		
		IconInset
		{
		}
		
		IconProperty
		{
			// inset so it lines up with the text
			inset-left=2
			inset-top=-2
			textcolor=tooltipgrey			
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}	
	}
		
	layout
	{
		region { name=tooltip x=0 y=0 width=235 height=600 margin=7 }
		place { region=tooltip dir=down Controls=Name,divider,Description spacing=4 }
	}
}
