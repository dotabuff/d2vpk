//------------------------------------
// Matchmaker Item
//------------------------------------
"DOTAMatchMakingItem.res"
{	
	controls
	{
		"DOTAMatchmakingDialogItemPanel"
		{
		  "ControlName"	"CDOTAMatchmakingDialogItemPanel"
		  "fieldName"		"DOTAMatchmakingDialogItemPanel"
		  "wide"						"380"
		  "tall"						"64"
		  "PaintBackground" "0"
		}

		"Background" { ControlName=Panel fieldName="Background" mouseInputEnabled=0 style=ProfileGradientBackground wide=594 tall=64 zpos=-1}
		    
		"GameName"
		{
		  "ControlName"	"label"
		  "fieldName"		"GameName"
		  "labeltext"		"name"
		  "xpos"			"10"
		  "ypos"			"2"
		  "wide"			"256"
		  "tall"			"20"
		  "font"			"AchievementItemTitle"
		  "textAlignment"		"west"
		  style=SectionTitle
		}

		"GameDesc"
		{
		  "ControlName"	"label"
		  "fieldName"		"GameDesc"
		  "labeltext"		"desc"
		  "xpos"			"15"
		  "ypos"			"22"
		  "wide"			"380"
		  "tall"			"40"
		  "font"			"AchievementItemDescription"
		  "wrap"			"1"
		  "textAlignment"		"north-west"
		  style=StatLabel
		}
	}
	include="resource/UI/dashboard_style.res"
}
