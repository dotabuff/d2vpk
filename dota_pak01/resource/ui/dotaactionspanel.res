"Resource/UI/DOTAActionsPanel.res"
{
	"DOTAActionsPanel"
	{
		"ControlName"		"EditablePanel"
		"fieldName" 		"DOTAActionsPanel"
		"visible" 			"0"
		"enabled" 			"1"
		"xpos"				"c-480"
		"ypos"				"24"
		"wide"	 			"193"
		"tall"	 			"490"
		"bgcolor_override"	"0 0 0 0"
	}
	
	"Background"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"Background"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"0"
		"wide"				"193"
		"tall"				"490"
		"enabled"			"1"
		"visible"			"0"
		"scaleImage"		"1"
		"fillcolor"			"46 43 39 255"
	}
	
// Play Section...

	"StartPlayingLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"StartPlayingLabel"
		"xpos"					"6"
		"ypos"					"16"
		"zpos"					"2"
		"wide"					"180"
		"tall"					"16"
		"enabled"				"1"
		"visible"				"1"	
		"textAlignment"			"west"
		"labelText"				"#dota_dashboard_start_playing"
	}

	"Matchmaking_Button"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"Matchmaking_Button"
		"xpos"						"0"
		"ypos"						"8"
		"zpos"						"2"
		"wide"						"95"
		"tall"						"14"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"west"
//		"command"					""
		"labelText"					"#dota_dashboard_action_matchmaking"
		"bindable"					"1"
		
		"pin_to_sibling"			"StartPlayingLabel"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"	
	}	
	
	"Matchmaking_Label"
	{
		"ControlName"			"Label"
		"fieldName"				"Matchmaking_Label"
		"xpos"					"-5"
		"ypos"					"0"
		"zpos"					"2"
		"wide"					"160"
		"tall"					"12"
		"enabled"				"1"
		"visible"				"1"	
		"labelText"				"#dota_dashboard_action_matchmaking_label"
		"textAlignment"			"west"

		"pin_to_sibling"			"Matchmaking_Button"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
		
		"style"					"DescriptionLabel"
	}
	
	"Private_Button"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"Private_Button"
		"xpos"						"5"
		"ypos"						"8"
		"zpos"						"2"
		"wide"						"95"
		"tall"						"14"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"west"
//		"command"					""
		"labelText"					"#dota_dashboard_action_private"
		"bindable"					"1"
		"command"					"PlayPrivateButton"
		
		"pin_to_sibling"			"Matchmaking_Label"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
	}	
	
	"Private_Label"
	{
		"ControlName"			"Label"
		"fieldName"				"Private_Label"
		"xpos"					"-5"
		"ypos"					"0"
		"zpos"					"2"
		"wide"					"160"
		"tall"					"12"
		"enabled"				"1"
		"visible"				"1"	
		"labelText"				"#dota_dashboard_action_private_label"
		"textAlignment"			"west"

		"pin_to_sibling"			"Private_Button"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
		
		"style"					"DescriptionLabel"
	}

	"AI_Button"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"AI_Button"
		"xpos"						"5"
		"ypos"						"8"
		"zpos"						"2"
		"wide"						"95"
		"tall"						"14"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"west"
		"command"					"PlayAIButton"
		"labelText"					"#dota_dashboard_action_ai"
		"bindable"					"1"
		
		"pin_to_sibling"			"Private_Label"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
	}	
	
	"AI_Label"
	{
		"ControlName"			"Label"
		"fieldName"				"AI_Label"
		"xpos"					"-5"
		"ypos"					"0"
		"zpos"					"2"
		"wide"					"160"
		"tall"					"12"
		"enabled"				"1"
		"visible"				"1"	
		"labelText"				"#dota_dashboard_action_ai_label"
		"textAlignment"			"west"

		"pin_to_sibling"			"AI_Button"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
		
		"style"					"DescriptionLabel"
	}

	"Tutorial_Button"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"Tutorial_Button"
		"xpos"						"5"
		"ypos"						"8"
		"zpos"						"2"
		"wide"						"95"
		"tall"						"14"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"west"
		"command"					"TipsButton"
		"labelText"					"#dota_dashboard_action_tutorial"
		"bindable"					"1"
		
		"pin_to_sibling"			"AI_Label"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
	}	
	
	"Tutorial_Label"
	{
		"ControlName"			"Label"
		"fieldName"				"Tutorial_Label"
		"xpos"					"-5"
		"ypos"					"0"
		"zpos"					"2"
		"wide"					"160"
		"tall"					"12"
		"enabled"				"1"
		"visible"				"1"	
		"labelText"				"#dota_dashboard_action_tutorial_label"
		"textAlignment"			"west"

		"pin_to_sibling"			"Tutorial_Button"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
		
		"style"					"DescriptionLabel"
	}

	"Friends_Button"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"Friends_Button"
		"xpos"						"5"
		"ypos"						"8"
		"zpos"						"2"
		"wide"						"130"
		"tall"						"14"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"west"
//		"command"					""
		"labelText"					"#dota_dashboard_action_friends_game"
		"bindable"					"1"
		
		"pin_to_sibling"			"Tutorial_Label"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
	}	

	"Friends_Label"
	{
		"ControlName"			"Label"
		"fieldName"				"Friends_Label"
		"xpos"					"-5"
		"ypos"					"0"
		"zpos"					"2"
		"wide"					"165"
		"tall"					"12"
		"enabled"				"1"
		"visible"				"1"	
		"labelText"				"#dota_dashboard_action_friends_game_label"
		"textAlignment"			"west"

		"pin_to_sibling"			"Friends_Button"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
		
		"style"					"DescriptionLabel"
	}

// Prepare & Research Section...

	"PrepareResearchLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"PrepareResearchLabel"
		"xpos"					"6"
		"ypos"					"210"
		"zpos"					"2"
		"wide"					"185"
		"tall"					"16"
		"enabled"				"1"
		"visible"				"1"	
		"textAlignment"			"west"
		"labelText"				"#dota_dashboard_prepareresearch"
	}

	"Heroes_Button"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"Heroes_Button"
		"xpos"						"0"
		"ypos"						"8"
		"zpos"						"2"
		"wide"						"57"
		"tall"						"14"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"west"
		"command"					"HeropediaButton"
		"labelText"					"#dota_dashboard_action_heroes"
		"bindable"					"1"
		
		"pin_to_sibling"			"PrepareResearchLabel"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
	}	

	"Items_Button"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"Items_Button"
		"xpos"						"0"
		"ypos"						"4"
		"zpos"						"2"
		"wide"						"45"
		"tall"						"14"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"west"
//		"command"					""
		"labelText"					"#dota_dashboard_action_items"
		"bindable"					"1"
		
		"pin_to_sibling"			"Heroes_Button"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
	}	

	"Replays_Button"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"Replays_Button"
		"xpos"						"0"
		"ypos"						"4"
		"zpos"						"2"
		"wide"						"62"
		"tall"						"14"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"west"
//		"command"					""
		"labelText"					"#dota_dashboard_action_replays"
		"bindable"					"1"
		
		"pin_to_sibling"			"Items_Button"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
	}	

// Help a Brother Out....

	"HelpOutLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"HelpOutLabel"
		"xpos"					"6"
		"ypos"					"292"
		"zpos"					"2"
		"wide"					"185"
		"tall"					"16"
		"enabled"				"1"
		"visible"				"1"	
		"textAlignment"			"west"
		"labelText"				"#dota_dashboard_helpout"
	}

	"Contribute_Button"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"Contribute_Button"
		"xpos"						"0"
		"ypos"						"8"
		"zpos"						"2"
		"wide"						"95"
		"tall"						"14"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"west"
//		"command"					""
		"labelText"					"#dota_dashboard_action_contribute"
		"bindable"					"1"
		
		"pin_to_sibling"			"HelpOutLabel"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
	}	
	
	"Contribute_Label"
	{
		"ControlName"			"Label"
		"fieldName"				"Contribute_Label"
		"xpos"					"-5"
		"ypos"					"0"
		"zpos"					"2"
		"wide"					"160"
		"tall"					"12"
		"enabled"				"1"
		"visible"				"1"	
		"labelText"				"#dota_dashboard_action_contribute_label"
		"textAlignment"			"west"

		"pin_to_sibling"			"Contribute_Button"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
		
		"style"					"DescriptionLabel"
	}

	"Mentor_Button"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"Mentor_Button"
		"xpos"						"5"
		"ypos"						"8"
		"zpos"						"2"
		"wide"						"95"
		"tall"						"14"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"west"
//		"command"					""
		"labelText"					"#dota_dashboard_action_mentor"
		"bindable"					"1"
		
		"pin_to_sibling"			"Contribute_Label"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
	}	
	
	"Mentor_Label"
	{
		"ControlName"			"Label"
		"fieldName"				"Mentor_Label"
		"xpos"					"-5"
		"ypos"					"0"
		"zpos"					"2"
		"wide"					"160"
		"tall"					"12"
		"enabled"				"1"
		"visible"				"1"	
		"labelText"				"#dota_dashboard_action_mentor_label"
		"textAlignment"			"west"

		"pin_to_sibling"			"Mentor_Button"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"		
		
		"style"					"DescriptionLabel"
	}


















	//========================================
	
// 	"ConfigureLabel"
// 	{
// 		"ControlName"			"Label"
// 		"fieldName"			"ConfigureLabel"
// 		"xpos"				"12"
// 		"ypos"				"290"
// 		"zpos"				"2"
// 		"wide"				"180"
// 		"tall"				"12"
// 		"enabled"			"1"
// 		"visible"			"1"	
// 		"fgcolor_override"			"0 240 255 255"
// 		"textAlignment"		"north-west"
// 		"labelText"			"#dota_dashboard_configure"
// 		"font"				"Arial14Thick"
// 		"paintbackground"	"0"
// 	}
// 	
// 	"SettingsButton"
// 	{
// 		"ControlName"			"Button"
// 		"fieldName"			"SettingsButton"
// 		"xpos"				"12"
// 		"ypos"				"302"
// 		"zpos"				"2"
// 		"wide"				"180"
// 		"tall"				"14"
// 		"enabled"			"1"
// 		"visible"			"1"	
// 		//"fgcolor_override"			"0 240 255 255"
// 		"textAlignment"		"north-west"
// 		"labelText"			"#dota_dashboard_settings"
// 		"font"				"Arial14Thick"
// 		"paintbackground"	"0"
// 	}
// 	
// 	"QuitButton"
// 	{
// 		"ControlName"			"Button"
// 		"fieldName"			"QuitButton"
// 		"xpos"				"12"
// 		"ypos"				"342"
// 		"zpos"				"2"
// 		"wide"				"180"
// 		"tall"				"14"
// 		"enabled"			"1"
// 		"visible"			"1"	
// 		//"fgcolor_override"			"0 240 255 255"
// 		"textAlignment"		"north-west"
// 		"labelText"			"#dota_dashboard_quit"
// 		"font"				"Arial14Thick"
// 		"paintbackground"	"0"
// 	}

	colors
	{
		"MenuButtonBlue"		"126 176 214 255"
		"MenuBackgroundGrey"	"46 43 39 255"
		"MenuDescriptionGrey"	"103 103 102 255"
	}

	styles
	{
		// Headers
		Label
		{
			font=Arial14Thick
			textcolor=white
			bgcolor=none	
		}
		
		// Menu option buttons
		Button
		{
			textcolor=MenuButtonBlue
			font=Arial14Thick
			bgcolor=none
		}
		
		Button:hover
		{
			textcolor=MenuBackgroundGrey
			font=Arial14Thick
			
			bgcolor=MenuButtonBlue		
		}
		
		Button:active
		{
			textcolor=white
			font=Arial14Thick
			
			bgcolor=MenuButtonBlue			
		}
		
		// description of menu options
		DescriptionLabel
		{
			font=Arial10Fine
			textcolor=MenuDescriptionGrey
			bgcolor=none
		}	
	}
}
