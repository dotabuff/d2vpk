"Resource/UI/DOTAReplayDownloadPanel.res"
{
	controls
	{
		"DOTAReplayDownloadPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAReplayDownloadPanel"
			"wide"	 		"300"
			"tall"	 		"100"
			"zpos"			"20"
			"paintbackground"	"0"
		}
		
		
		"WatchReplayButton" { ControlName="Button" fieldName="WatchReplayButton" wide=150 xpos=25 ypos=0 tall=15 command="WatchReplayButton" labelText="#dota_watch_replay" textAlignment=center }
		"DownloadReplayButton" { ControlName="Button" fieldName="DownloadReplayButton" wide=150 xpos=25 ypos=0 tall=15 command="DownloadReplayButton" labelText="#dota_download_replay" textAlignment=center }
		"DownloadProgress" { ControlName="ProgressBar" fieldName="DownloadProgress" xpos=0 ypos=20 wide=200 tall=15 }
		"DownloadingLabel" { ControlName="Label" fieldName="DownloadingLabel" style=StatLabel wide=200 xpos=0 ypos=0 tall=15 textAlignment=north-west labelText="#dota_downloading_replay" }
		"DownloadSizeLabel" { ControlName="Label" fieldName="DownloadSizeLabel" style=StatLabel wide=200 xpos=0 ypos=0 tall=15 textAlignment=north-east }
		"ReplayUnavailableLabel" { ControlName="Label" fieldName="ReplayUnavailableLabel" style=StatLabel wide=150 xpos=25 ypos=0 tall=15 labelText="#dota_replay_unavailable" textAlignment=center }
	}
		
	include="resource/UI/dashboard_style.res"	
}
