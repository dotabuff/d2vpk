"Resource/UI/DOTAProfilePanel.res"
{
	controls
	{
		"DOTAProfilePanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAProfilePanel"
			"xpos"			"0"
			"ypos"			"r256"
			"wide"	 		"256"
			"tall"	 		"256"
			"zpos"			"20"
			"paintbackground" "0"
			"visible"		"1"
		}
		
		"Background"
		{
			"ControlName"		"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"-1"
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
			"labelText"			"PROFILE"	// todo: Localize
			"style"				"DashboardTitle"
			"mouseInputEnabled"	"0"
		}
		
		"Avatar"
		{
			"ControlName"		"CAvatarImagePanel"
			"fieldName"		"Avatar"
			"xpos"			"8"
			"ypos"			"34"
			"wide"			"48"
			"tall"			"48"
			"scaleImage"		"1"
			"autoResize"		"0"
			"pinCorner"		"0"
			//"fgcolor_override" 	"255 255 255 255"
			//"drawcolor_override" 	"255 255 255 255"
			//"alpha"			"255"
			"zpos"			"3"
			"group"				"PersonaDetails"
			"style"				"StatLabel"
		}

		"PlayerName"
		{
			"ControlName"			"Button"
			"fieldName"			"PlayerName"
			"xpos"				"65"
			"ypos"				"34"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"labelText"			"%playername%"
			//"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
			"command"			"FullProfile"
		}
		"FullProfileButton"
		{
			"ControlName"			"Button"
			"fieldName"			"FullProfileButton"
			"xpos"				"65"
			"ypos"				"55"
			"zpos"				"2"
			"wide"				"120"
			"tall"				"14"
			"textAlignment"		"north-west"
			"labelText"			"FULL PROFILE"
			"command"			"FullProfile"
			"textinsetx"		"0"
			"textinsety"		"0"
			"auto_wide_tocontents"		"1"
			"visible" "0"
		}
		"WinCountTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"WinCountTitle"
			"xpos"				"8"
			"ypos"				"95"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"labelText"			"#dota_profile_wins"
			"auto_wide_tocontents"		"1"
			"style"				"StatLabel"
			"group"				"PersonaDetails"
		}
		"LossCountTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"LossCountTitle"
			"xpos"				"8"
			"ypos"				"110"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"labelText"			"#dota_profile_losses"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"KarmaTitle"
		{
			"ControlName"		"Label"
			"fieldName"			"KarmaTitle"
			"xpos"				"8"
			"ypos"				"125"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"		"north-west"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"labelText"			"#dota_persona_karma"
			"group"				"PersonaDetails"
		}
		"WinCountLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"WinCountLabel"
			"xpos"				"74"
			"ypos"				"95"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"enabled"			"1"
			"textAlignment"			"north-west"
			"labelText"			"%wincount%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"LossCountLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"LossCountLabel"
			"xpos"				"74"
			"ypos"				"110"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"enabled"			"1"
			"textAlignment"			"north-west"
			"labelText"			"%losscount%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"KarmaLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"KarmaLabel"
			"xpos"				"74"
			"ypos"				"125"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"labelText"			"%karma%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"MostPlayedTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"MostPlayedTitle"
			"xpos"				"8"
			"ypos"				"155"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"style"				"SectionTitle"
			"auto_wide_tocontents"		"1"
			"labelText"			"HEROES PLAYED"
			"group"				"PersonaDetails"
		}
		"MostPlayedWinsTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"MostPlayedWinsTitle"
			"xpos"				"110"
			"ypos"				"155"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"auto_wide_tocontents"		"1"
			"labelText"			"WINS"
			"style"				"SectionTitle"
			"group"				"PersonaDetails"
		}
		"MostPlayedLossesTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"MostPlayedLossesTitle"
			"xpos"				"148"
			"ypos"				"155"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"auto_wide_tocontents"		"1"
			"labelText"			"LOSSES"
			"style"				"SectionTitle"
			"group"				"PersonaDetails"
		}
		// top 3 played heroes
		"TopHeroName0"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroName0"
			"xpos"				"8"
			"ypos"				"170"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"labelText"			"%TopHeroName0%"
			"group"				"PersonaDetails"
		}
		"TopHeroWins0"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroWins0"
			"xpos"				"110"
			"ypos"				"170"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"labelText"			"%topherowins0%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"TopHeroLosses0"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroLosses0"
			"xpos"				"148"
			"ypos"				"170"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"labelText"			"%topherolosses0%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		// ==
		"TopHeroName1"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroName1"
			"xpos"				"8"
			"ypos"				"185"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"labelText"			"%TopHeroName1%"
			"group"				"PersonaDetails"
		}
		"TopHeroWins1"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroWins1"
			"xpos"				"110"
			"ypos"				"185"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"labelText"			"%topherowins1%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"TopHeroLosses1"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroLosses1"
			"xpos"				"148"
			"ypos"				"185"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"labelText"			"%topherolosses1%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		// ==
		"TopHeroName2"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroName2"
			"xpos"				"8"
			"ypos"				"200"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"labelText"			"%TopHeroName2%"
			"group"				"PersonaDetails"
		}
		"TopHeroWins2"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroWins2"
			"xpos"				"110"
			"ypos"				"200"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"labelText"			"%topherowins2%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"TopHeroLosses2"
		{
			"ControlName"			"Label"
			"fieldName"			"TopHeroLosses2"
			"xpos"				"148"
			"ypos"				"200"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"
			"textAlignment"			"north-west"
			"labelText"			"%topherolosses2%"
			"style"				"StatLabel"
			"auto_wide_tocontents"		"1"
			"group"				"PersonaDetails"
		}
		"MatchHistoryButton"
		{
			"ControlName"			"Button"
			"fieldName"			"MatchHistoryButton"
			"xpos"				"8"
			"ypos"				"294"
			"zpos"				"2"
			"wide"				"120"
			"tall"				"14"
			"textAlignment"		"north-west"
			"labelText"			"more..."			// TODO: Localize
			"command"			"MatchHistoryButton"
			"textinsetx"		"0"
			"textinsety"		"0"
			"auto_wide_tocontents"		"1"
		}
		"AchievementsButton"
		{
			"ControlName"			"Button"
			"fieldName"			"AchievementsButton"
			"xpos"				"8"
			"ypos"				"322"
			"zpos"				"2"
			"wide"				"120"
			"tall"				"14"
			"textAlignment"		"north-west"
			"labelText"			"ACHIEVEMENTS..."
			"command"			"AchievementsButton"
			"textinsetx"		"0"
			"textinsety"		"0"
			"auto_wide_tocontents"		"1"
		}
		"RecentMatchesTitle"
		{
			"ControlName"			"Label"
			"fieldName"			"RecentMatchesTitle"
			"xpos"				"8"
			"ypos"				"230"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"15"

			"textAlignment"			"north-west"
			"auto_wide_tocontents"		"1"
			"labelText"			"RECENT MATCHES"
			"style"				"SectionTitle"
			//"group"				"PersonaDetails"
			visible=0
		}
		"HistoryListEntry0"
		{
			"ControlName"		"Panel"
			"fieldName"			"HistoryListEntry0"
			"wide"	 		"556"
			"tall"	 		"16"
			"zpos"			"2"	
			"bgcolor_override" "0 0 0 0"
			visible=0
		}
		"HistoryListEntry1"
		{
			"ControlName"		"Panel"
			"fieldName"			"HistoryListEntry1"
			"wide"	 		"556"
			"tall"	 		"16"
			"zpos"			"2"	
			"bgcolor_override" "0 0 0 0"
			visible=0
		}
		"HistoryListEntry2"
		{
			"ControlName"		"Panel"
			"fieldName"			"HistoryListEntry2"
			"wide"	 		"556"
			"tall"	 		"16"
			"zpos"			"2"
			"bgcolor_override" "0 0 0 0"
			visible=0
		}
	}
	
	include="resource/UI/dashboard_style.res"	
	layout
	{
		region { name=RecentMatchesRegion x=8 y=247 width=556 }
		place { region=RecentMatchesRegion controls=HistoryListEntry0,HistoryListEntry1,HistoryListEntry2 dir=down spacing=0 }
	}
	
	colors
	{
		
	}
	
	styles
	{
		
	}
}
