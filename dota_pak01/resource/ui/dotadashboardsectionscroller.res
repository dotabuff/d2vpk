"Resource/UI/DOTADashboardSectionScroller.res"
{
	controls
	{
		"DOTADashboardSectionScroller" { ControlName=EditablePanel fieldName=DOTADashboardSectionScroller zpos=4 paintbackground=0 }
		"SectionBackground0" { ControlName=ImagePanel fieldName=SectionBackground0 zpos=0  mouseInputEnabled=0 scaleImage=1 visible=0 image=dashboard/dash_bg_play.vmt }
		"SectionBackground1" { ControlName=ImagePanel fieldName=SectionBackground1 zpos=0  mouseInputEnabled=0 scaleImage=1 image=dashboard/dash_bg_play.vmt }
		"SectionBackground2" { ControlName=ImagePanel fieldName=SectionBackground2 zpos=0  mouseInputEnabled=0 scaleImage=1 image=dashboard/dash_bg_social.vmt }
		"SectionBackground3" { ControlName=ImagePanel fieldName=SectionBackground3 zpos=0  mouseInputEnabled=0 scaleImage=1 image=dashboard/dash_bg_watch.vmt }
		"SectionBackground4" { ControlName=ImagePanel fieldName=SectionBackground4 zpos=0  mouseInputEnabled=0 scaleImage=1 image=dashboard/dash_bg_learn.vmt }
		"DashboardSection0" { ControlName=Panel fieldName=DashboardSection0 zpos=2 }
		"DashboardSection1" { ControlName=Panel fieldName=DashboardSection1 zpos=2 }
		"DashboardSection2" { ControlName=Panel fieldName=DashboardSection2 zpos=2 }
		"DashboardSection3" { ControlName=Panel fieldName=DashboardSection3 zpos=2 }
		"DashboardSection4" { ControlName=Panel fieldName=DashboardSection4 zpos=2 }
		
	}
	
	include="resource/UI/dashboard_style.res"
	
	"styles"
	{
	}
}