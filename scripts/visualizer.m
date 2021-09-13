/*---------------------------------------------------
-----------------------------------------------------
Filename:	visualizer.m
Version:	1.4

Type:		maki
Date:		07. Okt. 2007 - 19:56  
Author:		Martin Poehlmann aka Deimos
E-Mail:		martin@skinconsortium.com
Internet:	www.skinconsortium.com
		www.martin.deimos.de.vu

Note:		This script handles also the timer reflection
-----------------------------------------------------
---------------------------------------------------*/

#include "..\..\..\lib/std.mi"

Function refreshVisSettings();
Function setVis (int mode);
Function ProcessMenuResult (int a);

Global Group scriptGroup;
Global Vis visualizer;
Global Text tmr;

Global Timer VU, VUStopTimer;

Global PopUpMenu visMenu;
Global PopUpMenu specmenu;
Global PopUpMenu oscmenu;
Global PopUpMenu pksmenu;
Global PopUpMenu anamenu;
Global PopUpMenu vumenu;

Global Int currentMode, a_falloffspeed, p_falloffspeed, a_coloring, vp_falloffspeed, Level1, Level2;
Global float peak1, peak2, pgrav1, pgrav2, vu_falloffspeed;
Global Boolean show_peaks, show_vupeaks, isShade;
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

	LeftMeter = scriptGroup.findObject("player.vu.left");
	RightMeter = scriptGroup.findObject("player.vu.right");
	LeftMeterPeak = scriptGroup.findObject("player.vu.leftpeak");
	RightMeterPeak = scriptGroup.findObject("player.vu.rightpeak");

	// init gravity values to make mr. maki happy
	pgrav1 = 0;
	pgrav2 = 0;

	// TODO: stop timer when song is paused
	VU = new Timer;
	VU.setdelay(16);

	vuStopTimer = new Timer;
	vuStopTimer.setdelay(1000);

	refreshVisSettings();
}

VU.onTimer() {
//credit to Egor Petrov/E-Trance for the original piece of code used in his EPS3 skin
//modified to remove the signal being made logarithmic, making it linear
//gravity/peak smoothness and optimizations by mirzi
	float DivL1 = 1.75;
	float DivR1 = DivL1;

	level1 += ((getLeftVuMeter()*LeftMeter.getLength()/256)/DivL1 - Level1 / DivL1);
	level2 += ((getRightVuMeter()*RightMeter.getLength()/256)/DivR1 - level2 / DivR1);

    LeftMeter.gotoFrame(level1);
    RightMeter.gotoFrame(level2);

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

	// also add a +1 here if you don't want the peaks and bars touching
	LeftMeterPeak.gotoFrame(peak1);
	RightMeterPeak.gotoFrame(peak2);
}

// saving those precious cycles
System.onStop(){
	if(currentMode == 6){
		VUStopTimer.start();
	}
}

System.onPause(){
	if(currentMode == 6){
		VUStopTimer.start();
	}
}

System.onResume(){
	if(currentMode == 6){
		VUStopTimer.stop();
		VU.start();
	}
}

System.onPlay(){
	if(currentMode == 6){
		VUStopTimer.stop();
		VU.start();
	}
}

// this timer stops all vu meter calculations
VUStopTimer.onTimer(){
	VUStopTimer.stop();
	VU.stop();
}

refreshVisSettings ()
{
	currentMode = getPrivateInt(getSkinName(), "Visualizer Mode", 1);
	show_peaks = getPrivateInt(getSkinName(), "Visualizer show Peaks", 1);
	show_vupeaks = getPrivateInt(getSkinName(), "Visualizer show VU Peaks", 1);
	a_falloffspeed = getPrivateInt(getSkinName(), "Visualizer analyzer falloff", 3);
	p_falloffspeed = getPrivateInt(getSkinName(), "Visualizer peaks falloff", 2);
	vp_falloffspeed = getPrivateInt(getSkinName(), "Visualizer VU peaks falloff", 2);
	a_coloring = getPrivateInt(getSkinName(), "Visualizer analyzer coloring", 0);

	visualizer.setXmlParam("peaks", integerToString(show_peaks));
	LeftMeterPeak.setXmlParam("visible", integerToString(show_vupeaks));
	RightMeterPeak.setXmlParam("visible", integerToString(show_vupeaks));
	visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));

	vu_falloffspeed = (vp_falloffspeed/100)+0.02;

	if (a_coloring == 0)
	{
		visualizer.setXmlParam("coloring", "Normal");
	}
	else if (a_coloring == 1)
	{
		visualizer.setXmlParam("coloring", "Normal");
	}
	else if (a_coloring == 2)
	{
		visualizer.setXmlParam("coloring", "Fire");
	}
	else if (a_coloring == 3)
	{
		visualizer.setXmlParam("coloring", "Line");
	}
	
	setVis (currentMode);
}

trigger.onLeftButtonDown (int x, int y)
{
	if (isKeyDown(VK_ALT) && isKeyDown(VK_SHIFT) && isKeyDown(VK_CONTROL))
	{
		if (visualizer.getXmlParam("fliph") == "1")
		{
			visualizer.setXmlParam("fliph", "0");
		}
		else
		{
			visualizer.setXmlParam("fliph", "1");
		}
		return;
	}

	currentMode++;

	if (currentMode == 7)
	{
		currentMode = 0;
	}

	setVis	(currentMode);
	complete;
}

trigger.onRightButtonUp (int x, int y)
{
	visMenu = new PopUpMenu;
	specmenu = new PopUpMenu;
	oscmenu = new PopUpMenu;
	pksmenu = new PopUpMenu;
	anamenu = new PopUpMenu;
	vumenu = new PopUpMenu;

	visMenu.addCommand("Presets:", 999, 0, 1);
	visMenu.addCommand("No Visualization", 100, currentMode == 0, 0);
	specmenu.addCommand("Thick Bands", 1, currentMode == 1, 0);
	specmenu.addCommand("Thin Bands", 2, currentMode == 2, 0);
	visMenu.addSubMenu(specmenu, "Spectrum Analyzer");

	oscmenu.addCommand("Lines", 3, currentMode == 3, 0);
	oscmenu.addCommand("Dots", 4, currentMode == 4, 0);
	oscmenu.addCommand("Solid", 5, currentMode == 5, 0);
	visMenu.addSubMenu(oscmenu, "Oscilloscope");
	visMenu.addCommand("VU Meter", 6, currentMode == 6, 0);
	visMenu.addCommand("Show VU Peaks", 102, show_vupeaks == 1, 0);

	visMenu.addSeparator();
	visMenu.addCommand("Options:", 999, 0, 1);
	visMenu.addCommand("Show Peaks", 101, show_peaks == 1, 0);
	pksmenu.addCommand("Slower", 200, p_falloffspeed == 0, 0);
	pksmenu.addCommand("Slow", 201, p_falloffspeed == 1, 0);
	pksmenu.addCommand("Moderate", 202, p_falloffspeed == 2, 0);
	pksmenu.addCommand("Fast", 203, p_falloffspeed == 3, 0);
	pksmenu.addCommand("Faster", 204, p_falloffspeed == 4, 0);
	visMenu.addSubMenu(pksmenu, "Peak Falloff Speed");
	anamenu.addCommand("Slower", 300, a_falloffspeed == 0, 0);
	anamenu.addCommand("Slow", 301, a_falloffspeed == 1, 0);
	anamenu.addCommand("Moderate", 302, a_falloffspeed == 2, 0);
	anamenu.addCommand("Fast", 303, a_falloffspeed == 3, 0);
	anamenu.addCommand("Faster", 304, a_falloffspeed == 4, 0);
	visMenu.addSubMenu(anamenu, "Analyzer Falloff Speed");
	visMenu.addSubmenu(vumenu, "VU Peak Falloff Speed");
	vumenu.addCommand("Slower", 500, vp_falloffspeed == 0, 0);
	vumenu.addCommand("Slow", 501, vp_falloffspeed == 1, 0);
	vumenu.addCommand("Moderate", 502, vp_falloffspeed == 2, 0);
	vumenu.addCommand("Fast", 503, vp_falloffspeed == 3, 0);
	vumenu.addCommand("Faster", 504, vp_falloffspeed == 4, 0);

	ProcessMenuResult (visMenu.popAtMouse());

	delete visMenu;
	delete specmenu;
	delete oscmenu;
	delete pksmenu;
	delete anamenu;
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

	else if (a >= 400 && a <= 403)
	{
		a_coloring = a - 400;
		if (a_coloring == 0)
		{
			visualizer.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 1)
		{
			visualizer.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 2)
		{
			visualizer.setXmlParam("coloring", "Fire");
		}
		else if (a_coloring == 3)
		{
			visualizer.setXmlParam("coloring", "Line");
		}
		setPrivateInt(getSkinName(), "Visualizer analyzer coloring", a_coloring);
	}

	else if (a >= 500 && a <= 504)
	{
		vp_falloffspeed = a - 500;
		vu_falloffspeed = (vp_falloffspeed/100)+0.02;
		setPrivateInt(getSkinName(), "Visualizer VU peaks falloff", vp_falloffspeed);
	}
}

setVis (int mode)
{
	setPrivateInt(getSkinName(), "Visualizer Mode", mode);
	if (mode == 0)
	{
		VU.stop();
		LeftMeterPeak.setXmlParam("alpha", "0");
		RightMeterPeak.setXmlParam("alpha", "0");
		LeftMeter.setXmlParam("visible", "0");
		RightMeter.setXmlParam("visible", "0");
		visualizer.setMode(0);
	}
	else if (mode == 1)
	{
		VU.stop();
		LeftMeterPeak.setXmlParam("alpha", "0");
		RightMeterPeak.setXmlParam("alpha", "0");
		LeftMeter.setXmlParam("visible", "0");
		RightMeter.setXmlParam("visible", "0");
		visualizer.setXmlParam("bandwidth", "wide");
		visualizer.setMode(1);
	}
	else if (mode == 2)
	{
		VU.stop();
		LeftMeterPeak.setXmlParam("alpha", "0");
		RightMeterPeak.setXmlParam("alpha", "0");
		LeftMeter.setXmlParam("visible", "0");
		RightMeter.setXmlParam("visible", "0");
		visualizer.setXmlParam("bandwidth", "thin");
		visualizer.setMode(1);
	}
	else if (mode == 3)
	{
		VU.stop();
		LeftMeterPeak.setXmlParam("alpha", "0");
		RightMeterPeak.setXmlParam("alpha", "0");
		LeftMeter.setXmlParam("visible", "0");
		RightMeter.setXmlParam("visible", "0");
		visualizer.setXmlParam("oscstyle", "solid");
		visualizer.setMode(2);
	}
	else if (mode == 4)
	{
		VU.stop();
		LeftMeterPeak.setXmlParam("alpha", "0");
		RightMeterPeak.setXmlParam("alpha", "0");
		LeftMeter.setXmlParam("visible", "0");
		RightMeter.setXmlParam("visible", "0");
		visualizer.setXmlParam("oscstyle", "dots");
		visualizer.setMode(2);
	}
	else if (mode == 5)
	{
		VU.stop();
		LeftMeterPeak.setXmlParam("alpha", "0");
		RightMeterPeak.setXmlParam("alpha", "0");
		LeftMeter.setXmlParam("visible", "0");
		RightMeter.setXmlParam("visible", "0");
		visualizer.setXmlParam("oscstyle", "lines");
		visualizer.setMode(2);
	}
	else if (mode == 6)
	{
		VU.start();
		LeftMeter.setXmlParam("visible", "1");
		RightMeter.setXmlParam("visible", "1");
		LeftMeterPeak.setXmlParam("alpha", "255");
		RightMeterPeak.setXmlParam("alpha", "255");
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