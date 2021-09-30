#include "..\..\..\lib/std.mi"
#include "attribs.m"

Function setObjects();
Function refreshVisSettings();
Function ProcessMenuResult(int a);
Function unsmooth();
Function smooth();

Global PopUpMenu visMenu;

Global Group frameGroup,beatdisplay;
Global Layer beatOverlay,DisplayRight,DisplayRightOverlay,DisplaySongtickerBG,VisOverlay;
Global Timer refreshEQ;
Global AnimatedLayer beatbarLeft,beatbarRight;
Global int lastBeatLeft,lastBeatRight;
Global Button Toggler,Toggler2;
Global Int dobeat2, level1, level2;

Global Boolean vu_smooth;

System.onScriptLoaded() {
	initAttribs();
  frameGroup = getScriptGroup();
  beatdisplay = frameGroup.findObject("player.normal.display.beatvisualization");
  beatOverlay = frameGroup.findObject("beatdisplayoverlay");
  beatbarLeft = frameGroup.findObject("beatleft");
  beatbarRight = frameGroup.findObject("beatright");

  Toggler = frameGroup.findObject("beatvisualization");
  Toggler2 = frameGroup.findObject("beatvisualization2");

  DisplayRight = frameGroup.findObject("display.right");
  DisplayRightOverlay = frameGroup.findObject("display.right.overlay2");
  DisplaySongtickerBG = frameGroup.findObject("display.st.right");
  VisOverlay = frameGroup.findObject("visualization.overlay");

  lastBeatLeft = 0;
  lastBeatRight = 0;

  refreshEQ = new Timer;
  refreshEQ.setDelay(10);

  refreshVisSettings();
}

refreshVisSettings ()
{
	vu_smooth = getPrivateInt(getSkinName(), "Smooth VU Meters", 1);
}

System.onscriptunloading() {
  delete refreshEQ;
}

setObjects() {
  int group_width = frameGroup.getWidth();

  if ( group_width % 2 !=0 ) {
		DisplayRight.setXmlParam("image","player.display.right");
  	DisplayRightOverlay.setXmlParam("image","player.display.right");
  	DisplaySongtickerBG.setXmlParam("image","player.display.songticker.bg.right");
  	VisOverlay.setXmlParam("image","player.visualization.overlay");
	} else {
		DisplayRight.setXmlParam("image","player.display.right2");
  	DisplayRightOverlay.setXmlParam("image","player.display.right2");
  	DisplaySongtickerBG.setXmlParam("image","player.display.songticker.bg.right2");
  	VisOverlay.setXmlParam("image","player.visualization.overlay2");
	}

  if ( group_width > 480 ) {
    int newXpos = (group_width-60)/2;
    beatdisplay.setXmlParam("x", IntegerToString(newXpos));
    beatdisplay.show();

    if ( beatvisualization_attrib.getData()=="1" ) {
      refreshEQ.stop();
      refreshEQ.start();
    } else {
      refreshEQ.stop();
      beatbarLeft.gotoframe(0);
      beatbarRight.gotoframe(0);
    }
  } else {
    beatdisplay.hide();
    refreshEQ.stop();
  }
}

frameGroup.onResize(int x, int y, int w, int h) {
  setObjects();
}

beatvisualization_attrib.onDataChanged() {
  setObjects();
}

System.onKeyDown(String key) {
  if (key == "shift+ctrl+alt") {
    dobeat2 = 1;
    complete;
  } else dobeat2 = 0;
}

Toggler.onLeftClick() {
	if ( beatvisualization_attrib.getData()=="1" ) {
		beatvisualization_attrib.setData("0");
	} else {
		beatvisualization_attrib.setData("1");
	}
}

Toggler.onRightButtonUp (int x, int y)
{
	visMenu = new PopUpMenu;

	visMenu.addCommand("VU Smoothing", 101, vu_smooth == 1, 0);

	ProcessMenuResult (visMenu.popAtMouse());

	delete visMenu;

	complete;	
}

ProcessMenuResult (int a)
{
	if (a < 1) return;

	if (a > 0 && a <= 6 || a == 100)
	{
		if (a == 100) a = 0;
	}

	else if (a == 101)
	{
		vu_smooth = (vu_smooth - 1) * (-1);
		setPrivateInt(getSkinName(), "Smooth VU Meters", vu_smooth);
	}
}

refreshEQ.onTimer() {
//credit to Egor Petrov/E-Trance for the original piece of code used in his EPS3 skin
//modified to remove the signal being made logarithmic, making it linear, removed the smoothing as well
	if(vu_smooth == 0){
		unsmooth();
	}else{
		smooth();
	}

    beatbarleft.gotoFrame(level1);
    beatbarright.gotoFrame(level2);
}

unsmooth(){
	level1 = (getLeftVuMeter()*beatbarleft.getLength()/256);
	level2 = (getRightVuMeter()*beatbarright.getLength()/256);
}

smooth(){
	float DivL1 = 1.75;
	float DivR1 = DivL1;

	level1 += ((getLeftVuMeter()*beatbarleft.getLength()/256)/DivL1 - Level1 / DivL1);
	level2 += ((getRightVuMeter()*beatbarright.getLength()/256)/DivR1 - level2 / DivR1);
}

Toggler2.onActivate(boolean on) {
	if (!dobeat2) { Toggler.leftClick(); return; }
	refreshEQ.stop();

	if (on) {
		beatbarLeft.setXMLParam("image","player.display.beat.left2");
		beatbarRight.setXMLParam("image","player.display.beat.right2");
		beatOverlay.hide();
	} else {
		beatbarLeft.setXMLParam("image","player.display.beat.left");
		beatbarRight.setXMLParam("image","player.display.beat.right");
		beatOverlay.show();
	}
	setObjects();
}
