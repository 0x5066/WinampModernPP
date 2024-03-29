/*---------------------------------------------------
-----------------------------------------------------
Filename:	visualizer.m
Version:	2.0

Type:		maki
Date:		07. Okt. 2007 - 19:56 , May 24th 2021 - 2:13am UTC+1
Author:		Martin Poehlmann aka Deimos, Eris Lund (0x5066), mirzi
E-Mail:		martin@skinconsortium.com
Internet:	www.skinconsortium.com
			www.martin.deimos.de.vu

Note:		This script revamped the vis menu and cycling
			with the mouse, as well as adding a VU Meter
			to be on parity with WACUP Classic
-----------------------------------------------------
---------------------------------------------------*/

#include "..\..\..\lib/std.mi"

Function refreshVisSettings();
Function setVis (int mode);
Function ProcessMenuResult (int a);
Function FliptheVU(int h);
Function GRAVorNOT();
Function SetVUState();

Global Group scriptGroup;
Global Vis visualizer;

Global Timer VU, VUStopTimer;

Global PopUpMenu visMenu;
Global PopUpMenu pksmenu;
Global PopUpMenu anamenu;
Global PopUpMenu vumenu;
Global PopUpMenu anasettings;
Global PopUpMenu oscsettings;
Global PopUpMenu vusettings;

Global Int currentMode, a_falloffspeed, p_falloffspeed, vp_falloffspeed, Level1, Level2, osc_render, ana_render, logl, logr;
Global float peak1, peak2, pgrav1, pgrav2, vu_falloffspeed;
Global Boolean show_peaks, show_vupeaks, vu_gravity, isShade;
Global layer trigger;

Global AnimatedLayer LeftMeter, RightMeter, LeftMeterPeak, RightMeterPeak;

Global Layout thislayout;
Global Container main;

System.onScriptLoaded()
{ 
	scriptGroup = getScriptGroup();
	thislayout = scriptGroup.getParentLayout();
	main = thislayout.getContainer();

	visualizer = scriptGroup.findObject("visual");

	trigger = scriptGroup.findObject("main.vis.trigger");

	//LeftMeterPeak.setXmlParam("visible", integerToString(show_vupeaks));
	//RightMeterPeak.setXmlParam("visible", integerToString(show_vupeaks));
	visualizer.setXmlParam("peaks", integerToString(show_peaks));
	visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	visualizer.setXmlParam("oscstyle", integerToString(osc_render));
	visualizer.setXmlParam("bandwidth", integerToString(ana_render));

	LeftMeter = scriptGroup.findObject("player.vu.left");
	RightMeter = scriptGroup.findObject("player.vu.right");
	LeftMeterPeak = scriptGroup.findObject("player.vu.leftpeak");
	RightMeterPeak = scriptGroup.findObject("player.vu.rightpeak");

	// init gravity values to make mr. maki happy
	pgrav1 = 0;
	pgrav2 = 0;

	VU = new Timer;
	VU.setdelay(16);

	vuStopTimer = new Timer;
	vuStopTimer.setdelay(4000);

	SetVUState();

	refreshVisSettings();
}

// saving those precious cycles
System.onStop(){
	if(currentMode == 3){
		VU.start(); //prevents VU meter getting stuck on stop
		VUStopTimer.start();
	}
}

System.onPause(){
	if(currentMode == 3){
		VUStopTimer.start();
	}
}

System.onResume(){
	if(currentMode == 3){
		VUStopTimer.stop();
		VU.start();
	}
}

System.onPlay(){
	if(currentMode == 3){
		VUStopTimer.stop();
		VU.start();
	}
}

// this timer stops all vu meter calculations
VUStopTimer.onTimer(){
	VUStopTimer.stop();
	VU.stop();
}

FliptheVU(int h){
	//i hate this, so much
	if(currentmode == 3){

		if(h){
			LeftMeter.setXmlParam("image", "player.visualization.vuf");
			RightMeter.setXmlParam("image", "player.visualization.vuf");
			LeftMeterPeak.setXmlParam("image", "player.visualization.vupeakf");
			RightMeterPeak.setXmlParam("image", "player.visualization.vupeakf");
			//messagebox("player.visualization.vuf, player.visualization.vupeakf", "", 1, "");
		}else{
			LeftMeter.setXmlParam("image", "player.visualization.vu");
			RightMeter.setXmlParam("image", "player.visualization.vu");
			LeftMeterPeak.setXmlParam("image", "player.visualization.vupeak");
			RightMeterPeak.setXmlParam("image", "player.visualization.vupeak");
			//messagebox("player.visualization.vu, player.visualization.vupeak, 1", "", 1, "");
		}

		LeftMeter.setXmlParam("visible", "1");
		RightMeter.setXmlParam("visible", "1");

	}else{
		LeftMeterPeak.setXmlParam("image", "");
		RightMeterPeak.setXmlParam("image", "");
		LeftMeter.setXmlParam("visible", "0");
		RightMeter.setXmlParam("visible", "0");
		//messagebox("empty, 0", "", 1, "");
	}
}

refreshVisSettings ()
{
	currentMode = getPrivateInt(getSkinName(), "Visualizer Mode", 1);
	show_peaks = getPrivateInt(getSkinName(), "Visualizer show Peaks", 1);
	show_vupeaks = getPrivateInt(getSkinName(), "Visualizer show VU Peaks", 1);
	a_falloffspeed = getPrivateInt(getSkinName(), "Visualizer analyzer falloff", 3);
	p_falloffspeed = getPrivateInt(getSkinName(), "Visualizer peaks falloff", 2);
	vp_falloffspeed = getPrivateInt(getSkinName(), "Visualizer VU peaks falloff", 2);
	osc_render = getPrivateInt(getSkinName(), "Oscilloscope Settings", 1);
	ana_render = getPrivateInt(getSkinName(), "Spectrum Analyzer Settings", 2);
	vu_gravity = getPrivateInt(getSkinName(), "VU Peak Gravity", 1);

	visualizer.setXmlParam("peaks", integerToString(show_peaks));
	LeftMeterPeak.setXmlParam("visible", integerToString(show_vupeaks));
	RightMeterPeak.setXmlParam("visible", integerToString(show_vupeaks));
	visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	visualizer.setXmlParam("oscstyle", integerToString(osc_render));
	visualizer.setXmlParam("bandwidth", integerToString(ana_render));

	vu_falloffspeed = (vp_falloffspeed/100)+0.02;

	if (osc_render == 0)
		{
			visualizer.setXmlParam("oscstyle", "Lines");
		}
		else if (osc_render == 2)
		{
			visualizer.setXmlParam("oscstyle", "Lines");
		}
		else if (osc_render == 1)
		{
			visualizer.setXmlParam("oscstyle", "Solid");
		}
		else if (osc_render == 3)
		{
			visualizer.setXmlParam("oscstyle", "Dots");
		}
	setPrivateInt(getSkinName(), "Oscilloscope Settings", osc_render);
    
	if (ana_render == 0)
		{
			visualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 1)
		{
			visualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 2)
		{
			visualizer.setXmlParam("bandwidth", "wide");
		}
	setPrivateInt(getSkinName(), "Spectrum Analyzer Settings", ana_render);

    if (currentMode >= 4) {currentMode = 1; FliptheVU(h);} 
	setVis (currentMode);
}

trigger.onLeftButtonDown (int x, int y)
{
	if (isKeyDown(VK_ALT) && isKeyDown(VK_SHIFT) && isKeyDown(VK_CONTROL))
	{
		if (visualizer.getXmlParam("fliph") == "1")
		{
			visualizer.setXmlParam("fliph", "0");
			FliptheVU(0);
		}
		else
		{
			visualizer.setXmlParam("fliph", "1");
			FliptheVU(1);
		}
		return;
	}

	if (isKeyDown(4) && isKeyDown(VK_SHIFT) && isKeyDown(VK_CONTROL))
	{
		if (visualizer.getXmlParam("flipv") == "1")
		{
			visualizer.setXmlParam("flipv", "0");
		}
		else
		{
			visualizer.setXmlParam("flipv", "1");
		}
		return;
	}


	currentMode++;

	if (currentMode == 4)
	{
		currentMode = 0;
	}

	setVis (currentMode);
	complete;
}

trigger.onRightButtonUp (int x, int y)
{
	visMenu = new PopUpMenu;
	pksmenu = new PopUpMenu;
	anamenu = new PopUpMenu;
	anasettings = new PopUpMenu;
	oscsettings = new PopUpMenu;
	vusettings = new PopUpMenu;
	vumenu = new PopUpMenu;

	visMenu.addCommand("Modes:", 999, 0, 1);
	visMenu.addSeparator();
	visMenu.addCommand("Disabled", 100, currentMode == 0, 0);
	visMenu.addCommand("Spectrum Analyzer", 1, currentMode == 1, 0);
	visMenu.addCommand("Oscilloscope", 2, currentMode == 2, 0);
	visMenu.addCommand("VU Meter", 3, currentMode == 3, 0);
	
	visMenu.addSeparator();
	visMenu.addCommand("Modern Visualizer Settings", 998, 0, 1);
	visMenu.addSeparator();
	visMenu.addSubmenu(anasettings, "Spectrum Analyzer Options");
	anasettings.addCommand("Band line width:", 997, 0, 1);
	anasettings.addSeparator();
	anasettings.addCommand("Thin", 701, ana_render == 1, 0);
	if(getDateDay(getDate()) == 1 && getDateMonth(getDate()) == 3){
		anasettings.addCommand("乇乂丅尺卂 丅卄工匚匚", 702, ana_render == 2, 0);
	}else{
		anasettings.addCommand("Thick", 702, ana_render == 2, 0);
	}
	anasettings.addSeparator();
	anasettings.addCommand("Show Peaks", 101, show_peaks == 1, 0);
	anasettings.addSeparator();
	pksmenu.addCommand("Slower", 200, p_falloffspeed == 0, 0);
	pksmenu.addCommand("Slow", 201, p_falloffspeed == 1, 0);
	pksmenu.addCommand("Moderate", 202, p_falloffspeed == 2, 0);
	pksmenu.addCommand("Fast", 203, p_falloffspeed == 3, 0);
	pksmenu.addCommand("Faster", 204, p_falloffspeed == 4, 0);
	anasettings.addSubMenu(pksmenu, "Peak falloff Speed");
	anamenu.addCommand("Slower", 300, a_falloffspeed == 0, 0);
	anamenu.addCommand("Slow", 301, a_falloffspeed == 1, 0);
	anamenu.addCommand("Moderate", 302, a_falloffspeed == 2, 0);
	anamenu.addCommand("Fast", 303, a_falloffspeed == 3, 0);
	anamenu.addCommand("Faster", 304, a_falloffspeed == 4, 0);
	anasettings.addSubMenu(anamenu, "Analyzer falloff Speed");
	visMenu.addSubmenu(oscsettings, "Oscilloscope Options");
	oscsettings.addCommand("Oscilloscope drawing style:", 996, 0, 1);
	oscsettings.addSeparator();
	oscsettings.addCommand("Dots", 603, osc_render == 3, 0);
	oscsettings.addCommand("Lines", 601, osc_render == 1, 0);
	oscsettings.addCommand("Solid", 602, osc_render == 2, 0);
	visMenu.addSubmenu(vusettings, "VU Meter Options");
	vusettings.addCommand("Show VU Peaks", 102, show_vupeaks == 1, 0);
	vusettings.addCommand("Smooth VU Peak falloff", 105, vu_gravity == 1, 0);
	vusettings.addSeparator();
	vusettings.addSubmenu(vumenu, "Peak falloff Speed");
	vumenu.addCommand("Slower", 500, vp_falloffspeed == 0, 0);
	vumenu.addCommand("Slow", 501, vp_falloffspeed == 1, 0);
	vumenu.addCommand("Moderate", 502, vp_falloffspeed == 2, 0);
	vumenu.addCommand("Fast", 503, vp_falloffspeed == 3, 0);
	vumenu.addCommand("Faster", 504, vp_falloffspeed == 4, 0);

	ProcessMenuResult (visMenu.popAtMouse());

	FliptheVU(h);

	delete visMenu;
	delete pksmenu;
	delete anamenu;
	delete anasettings;
	delete oscsettings;
	delete vusettings;
	delete vumenu;

	complete;	
}

ProcessMenuResult (int a)
{
	if (a < 1) return;

	if (a > 0 && a <= 6 || a == 100)
	{
		if (a == 100) a = 0;
		setVis(a);
	}

	else if (a == 101)
	{
		show_peaks = (show_peaks - 1) * (-1);
		visualizer.setXmlParam("peaks", integerToString(show_peaks));
		setPrivateInt(getSkinName(), "Visualizer show Peaks", show_peaks);
	}

	else if (a == 102)
	{
		show_vupeaks = (show_vupeaks - 1) * (-1);
		LeftMeterPeak.setXmlParam("visible", integerToString(show_vupeaks));
		RightMeterPeak.setXmlParam("visible", integerToString(show_vupeaks));
		setPrivateInt(getSkinName(), "Visualizer show VU Peaks", show_vupeaks);
	}


	else if (a == 105)
	{
		vu_gravity = (vu_gravity - 1) * (-1);
		setPrivateInt(getSkinName(), "VU Peak Gravity", vu_gravity);
	}

	else if (a >= 200 && a <= 204)
	{
		p_falloffspeed = a - 200;
		visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer peaks falloff", p_falloffspeed);
	}

	else if (a >= 300 && a <= 304)
	{
		a_falloffspeed = a - 300;
		visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer analyzer falloff", a_falloffspeed);
	}

	else if (a >= 500 && a <= 504)
	{
		vp_falloffspeed = a - 500;
		vu_falloffspeed = (vp_falloffspeed/100)+0.02;
		setPrivateInt(getSkinName(), "Visualizer VU peaks falloff", vp_falloffspeed);
	}

	else if (a >= 600 && a <= 603)
	{
		osc_render = a - 600;
		if (osc_render == 0)
		{
			visualizer.setXmlParam("oscstyle", "lines");
		}
		else if (osc_render == 2)
		{
			visualizer.setXmlParam("oscstyle", "lines");
		}
		else if (osc_render == 1)
		{
			visualizer.setXmlParam("oscstyle", "solid");
		}
		else if (osc_render == 3)
		{
			visualizer.setXmlParam("oscstyle", "dots");
		}
		setPrivateInt(getSkinName(), "Oscilloscope Settings", osc_render);
	}

	else if (a >= 700 && a <= 702)
	{
		ana_render = a - 700;
		if (ana_render == 0)
		{
			visualizer.setXmlParam("bandwidth", "thin");
		}
		else if (ana_render == 1)
		{
			visualizer.setXmlParam("bandwidth", "thin");
		}
		else if (ana_render == 2)
		{
			visualizer.setXmlParam("bandwidth", "wide");
		}
		setPrivateInt(getSkinName(), "Spectrum Analyzer Settings", ana_render);
	}
}

VU.onTimer(){

	level1 = (getLeftVuMeter()*LeftMeter.getLength()/256);
	level2 = (getRightVuMeter()*RightMeter.getLength()/256);

    LeftMeter.gotoFrame(level1);
    RightMeter.gotoFrame(level2);

	GRAVorNOT();

	LeftMeterPeak.gotoFrame(peak1);
	RightMeterPeak.gotoFrame(peak2);
}

SetVUState(){

	level1 = (getLeftVuMeter()*LeftMeter.getLength()/256);
	level2 = (getRightVuMeter()*RightMeter.getLength()/256);

    LeftMeter.gotoFrame(level1);
    RightMeter.gotoFrame(level2);

	GRAVorNOT();

	LeftMeterPeak.gotoFrame(peak1);
	RightMeterPeak.gotoFrame(peak2);
}

GRAVorNOT(){
	if(vu_gravity == 0){
		if (level1 >= peak1){
			peak1 = level1;
			//pgrav1 = 0;
		}
		else{
			//peak1 += pgrav1;
			peak1 -= vu_falloffspeed*60;
		}
		if (level2 >= peak2){
			peak2 = level2;
			//pgrav2 = 0;
		}
		else{
			//peak2 += pgrav2;
			peak2 -= vu_falloffspeed*60;
		}
	}else{
		if (level1 >= peak1){
			peak1 = level1;
			pgrav1 = 0;
		}
		else{
			peak1 += pgrav1;
			pgrav1 -= vu_falloffspeed;
		}
		if (level2 >= peak2){
			peak2 = level2;
			pgrav2 = 0;
		}
		else{
			peak2 += pgrav2;
			pgrav2 -= vu_falloffspeed;
		}
	}
}

setVis (int mode)
{
	setPrivateInt(getSkinName(), "Visualizer Mode", mode);
	if (mode == 0)
	{
		VU.stop();
		LeftMeterPeak.setXmlParam("image", "");
		RightMeterPeak.setXmlParam("image", "");
		LeftMeter.setXmlParam("visible", "0");
		RightMeter.setXmlParam("visible", "0");
		visualizer.setMode(0);
	}
	else if (mode == 1)
	{
		VU.stop();
		LeftMeterPeak.setXmlParam("image", "");
		RightMeterPeak.setXmlParam("image", "");
		LeftMeter.setXmlParam("visible", "0");
		RightMeter.setXmlParam("visible", "0");
		visualizer.setMode(1);
	}
	else if (mode == 2)
	{
		VU.stop();
		LeftMeterPeak.setXmlParam("image", "");
		RightMeterPeak.setXmlParam("image", "");
		LeftMeter.setXmlParam("visible", "0");
		RightMeter.setXmlParam("visible", "0");
		visualizer.setMode(2);
	}
	else if (mode == 3)
	{
		FliptheVU(h);
		VU.start();
		visualizer.setMode(0);
	}
	currentMode = mode;
}

// Sync Normal and Shade Layout

main.onBeforeSwitchToLayout(Layout oldlayout, Layout newlayout)
{
	if (newlayout != thislayout)
	{
		return;
	}
	
	refreshVisSettings();
}