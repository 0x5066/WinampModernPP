#include "..\..\..\lib/std.mi"
#include "attribs.m"

Global Group frameGroup;
Global Togglebutton ShuffleBtn,RepeatBtn,ShuffleBtn2,RepeatBtn2;
Global Timer SongTickerTimer, RandomTimer, nanoTimer;
Global Text InfoTicker;
Global GuiObject SongTicker;
Global Slider Balance;
Global Layout normal;
Global int reallyrandom/*, i*/;
Global String dankpods;

function setSongtickerScrolling();
//Function please();

System.onScriptLoaded() {
	initAttribs();
	frameGroup = getScriptGroup();
	SongTicker = frameGroup.findObject("songticker");
	InfoTicker = frameGroup.findObject("infoticker");
	normal = frameGroup.getParentLayout();

	SongTickerTimer = new Timer;
	SongTickerTimer.setDelay(1000);

	RandomTimer = new Timer;
	RandomTimer.setDelay(500);
	RandomTimer.start();

	nanoTimer = new Timer;
	nanoTimer.setDelay(500);
	//i = 0;

	RepeatBtn = frameGroup.findObject("Repeat");
	ShuffleBtn = frameGroup.findObject("Shuffle");
	RepeatBtn2 = frameGroup.findObject("RepeatDisplay");
	ShuffleBtn2 = frameGroup.findObject("ShuffleDisplay");

	Balance = frameGroup.findObject("Balance");
	setSongtickerScrolling();
}

normal.onAction (String action, String param, Int x, int y, int p1, int p2, GuiObject source)
{
	if (strlower(action) == "showinfo")
	{
		SongTicker.hide();
		SongTickerTimer.start();
		InfoTicker.setText(param);
		InfoTicker.show();

	}
	else if (strlower(action) == "cancelinfo")
	{
		SongTickerTimer.onTimer ();
	}
}

RandomTimer.onTimer(){
	reallyrandom = random(9);
}

SongTickerTimer.onTimer() {
	SongTicker.show();
	InfoTicker.hide();
	SongTickerTimer.stop();
}

System.onScriptUnloading() {
	delete SongTickerTimer;
}

Balance.onSetPosition(int newpos)
{
	string t=translate("Balance")+":";
	if (newpos==127) t+= " " + translate("Center");
	if (newpos<127) t += " " + integerToString((100-(newpos/127)*100))+"% "+translate("Left");
	if (newpos>127) t += " " + integerToString(((newpos-127)/127)*100)+"% "+translate("Right");

	SongTickerTimer.start();
	SongTicker.hide();
	InfoTicker.show();
	InfoTicker.setText(t);
}

SongTicker.onLeftButtonDown (int x, int y)
{
	//i'm so sorry for this.
	//reallyrandom = 8;

	String extension = System.strlower(System.getExtension(System.removePath(System.getPlayItemString())));

	if (isKeyDown(VK_ALT) && isKeyDown(VK_SHIFT) && isKeyDown(VK_CONTROL))
	{
	if(reallyrandom == 0) dankpods = "Can you believe no one bought this?";
	else if(reallyrandom == 1) dankpods = "So like, this one time, yeh?";
	else if(reallyrandom == 2) dankpods = "Someone's been in here.";
	else if(reallyrandom == 3) dankpods = "It's like an MP3 player or something.";
	else if(reallyrandom == 4) dankpods = "Oh Craig!";
	else if(reallyrandom == 5) dankpods = "They sound like kids percussion.";
	else if(reallyrandom == 6) dankpods = "We're off to cashies, mate!";
	else if(reallyrandom == 7) dankpods = "na-no";
	//else if(reallyrandom == 8) nanoTimer.start();
	else if(reallyrandom == 8) dankpods = "Oh my PKcells...";
	else if(reallyrandom == 9) dankpods = "Also known as: the bare minimum.";

	if(extension == "mp3") dankpods = "MP3, a.k.a the bare minimum.";
	SongTickerTimer.start();
	SongTicker.hide();
	InfoTicker.show();
	InfoTicker.setText(dankpods);
	}
}

/*
nanoTimer.onTimer(){
	//this is bad, there's probably a better way
	i++;
	if(i >= 3){
		i = 0;
	}

	if(i == 0){
		dankpods = "na   ";
	}else if(i == 1){
		dankpods = "na-no";
	}
	please();
	InfoTicker.setText(dankpods);
}

Please(){
	if(i == 2){
		nanoTimer.stop();
	}
}
*/

RepeatBtn.onToggle(boolean on) {
	SongTickerTimer.start();
	int v = getCurCfgVal();
	SongTicker.hide();
	InfoTicker.show();
	if (v == 0) InfoTicker.setText("Repeat: OFF");
	else if (v > 0) InfoTicker.setText("Repeat: ALL");
	else if (v < 0) InfoTicker.setText("Repeat: TRACK");
}

ShuffleBtn.onToggle(boolean on) {
	SongTickerTimer.start();
	SongTicker.hide();
	InfoTicker.show();
	if (on) InfoTicker.setText("Playlist Shuffling: ON"); else InfoTicker.setText("Playlist Shuffling: OFF");
}

RepeatBtn2.onToggle(boolean on) {
	SongTickerTimer.start();
	int v = getCurCfgVal();
	SongTicker.hide();
	InfoTicker.show();
	if (v == 0) InfoTicker.setText("Repeat: OFF");
	else if (v > 0) InfoTicker.setText("Repeat: ALL");
	else if (v < 0) InfoTicker.setText("Repeat: TRACK");
}

ShuffleBtn2.onToggle(boolean on) {
	SongTickerTimer.start();
	SongTicker.hide();
	InfoTicker.show();
	if (on) InfoTicker.setText("Playlist Shuffling: ON"); else InfoTicker.setText("Playlist Shuffling: OFF");
}

songticker_scrolling_attrib.onDataChanged() {
	setSongtickerScrolling();
}

setSongtickerScrolling() {
	if (songticker_scrolling_modern_attrib.getData()=="1") {
		SongTicker.setXMLParam("ticker","bounce");
	}
	else if (songticker_scrolling_classic_attrib.getData()=="1") {
		SongTicker.setXMLParam("ticker","scroll");
	}
	else {
		SongTicker.setXMLParam("ticker","off");
	}
}