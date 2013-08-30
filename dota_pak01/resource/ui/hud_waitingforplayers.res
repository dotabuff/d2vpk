"Resource/UI/HUD_WaitingForPlayers.res"
{
	"HudDOTAWaitingForPlayersElement"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"HudDOTAWaitingForPlayersElement"
		"xpos"				"c-187"
		"ypos"				"50"
		"zpos"				"1"
		"wide"				"374"
		"tall"				"300"
		"style"				"WaitingBackground"	
	}
	
	"TitleLabel" { ControlName=Label fieldName=TitleLabel style=DashboardTitle textAlignment=center xpos=0 ypos=20 wide=374 tall=20 labelText="WAITING FOR PLAYERS" }
	"PlayerCountLabel" { ControlName=Label fieldName=PlayerCountLabel style=PlayerCountStyle textAlignment=center xpos=0 ypos=40 wide=374 tall=30 labelText="" }
	
	"TimeoutLabel" { ControlName=Label fieldName=TimeoutLabel style=DashboardTitle textAlignment=center xpos=0 ypos=270 wide=374 tall=20 }
	
	
	"PlayerLabel0" { ControlName=Label fieldName=PlayerLabel0 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"PlayerLabel1" { ControlName=Label fieldName=PlayerLabel1 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"PlayerLabel2" { ControlName=Label fieldName=PlayerLabel2 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"PlayerLabel3" { ControlName=Label fieldName=PlayerLabel3 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"PlayerLabel4" { ControlName=Label fieldName=PlayerLabel4 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"PlayerLabel5" { ControlName=Label fieldName=PlayerLabel5 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"PlayerLabel6" { ControlName=Label fieldName=PlayerLabel6 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"PlayerLabel7" { ControlName=Label fieldName=PlayerLabel7 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"PlayerLabel8" { ControlName=Label fieldName=PlayerLabel8 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"PlayerLabel9" { ControlName=Label fieldName=PlayerLabel9 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"PlayerLabel10" { ControlName=Label fieldName=PlayerLabel10 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"PlayerLabel11" { ControlName=Label fieldName=PlayerLabel11 style=NameStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	
	"StatusLabel0" { ControlName=Label fieldName=StatusLabel0 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"StatusLabel1" { ControlName=Label fieldName=StatusLabel1 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"StatusLabel2" { ControlName=Label fieldName=StatusLabel2 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"StatusLabel3" { ControlName=Label fieldName=StatusLabel3 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"StatusLabel4" { ControlName=Label fieldName=StatusLabel4 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"StatusLabel5" { ControlName=Label fieldName=StatusLabel5 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"StatusLabel6" { ControlName=Label fieldName=StatusLabel6 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"StatusLabel7" { ControlName=Label fieldName=StatusLabel7 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"StatusLabel8" { ControlName=Label fieldName=StatusLabel8 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"StatusLabel9" { ControlName=Label fieldName=StatusLabel9 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"StatusLabel10" { ControlName=Label fieldName=StatusLabel10 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	"StatusLabel11" { ControlName=Label fieldName=StatusLabel11 style=LoadingStyle wide=187 tall=15 textAlignment=center minimum-width=187 }
	
	colors
	{
		transblack="0 0 0 192"
		LoadingLabelColor="255 32 0 255"
		ReadyLabelColor="32 255 32 255"
	}
	
	styles
	{
		WaitingBackground
		{
			render_bg
			{
				0="fill( x0, y0, x1, y1, transblack )"
			}
		}
		PlayerCountStyle
		{
			textcolor=DashboardTitleColor
			font=Arial24Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"NameStyle"
		{
			textcolor=DashboardTitleColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"LoadingStyle"
		{
			textcolor=LoadingLabelColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"ReadyStyle"
		{
			textcolor=ReadyLabelColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
	}
	
	include="resource/UI/dashboard_style.res"
	
	layout
	{
		region { name=leftcolumn x=10 y=80 width=177 }
		place { region=leftcolumn controls=PlayerLabel0,PlayerLabel1,PlayerLabel2,PlayerLabel3,PlayerLabel4,PlayerLabel5,PlayerLabel6,PlayerLabel7,PlayerLabel8,PlayerLabel9,PlayerLabel10,PlayerLabel11 dir=down spacing=4 }
		region { name=rightcolumn x=187 y=80 width=177 }
		place { region=rightcolumn controls=StatusLabel0,StatusLabel1,StatusLabel2,StatusLabel3,StatusLabel4,StatusLabel5,StatusLabel6,StatusLabel7,StatusLabel8,StatusLabel9,StatusLabel10,StatusLabel11 dir=down spacing=4 }
	}
}