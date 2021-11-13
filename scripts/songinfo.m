#include "..\..\..\lib/std.mi"

Function string tokenizeSongInfo(String tkn, String sinfo);
Function getSonginfo(String SongInfoString);
Function loadPlaylistArtWork();

Global Group frameGroup;
Global Layer channelDisplay;
Global Text bitrateText, FrequencyText;
Global Timer songInfoTimer;
Global String SongInfoString;
Global AlbumArtLayer waaa;
Global Int waaaRetries = 0;

System.onScriptLoaded(){
	frameGroup = getScriptGroup();

	bitrateText = frameGroup.findObject("Bitrate");
	frequencyText = frameGroup.findObject("Frequency");

	channelDisplay = frameGroup.findObject("channels");

	songInfoTimer = new Timer;
	songInfoTimer.setDelay(250);

	if (getStatus() == STATUS_PLAYING) {
		String sit = getSongInfoText();
		waaaRetries = 0;
		if (sit != "") getSonginfo(sit);
		else songInfoTimer.setDelay(250); // goes to 250ms once info is available
		songInfoTimer.start();
	} else if (getStatus() == STATUS_PAUSED) {
		getSonginfo(getSongInfoText());
	}
}

loadPlaylistArtWork()
{
	Container albumart = System.getContainer("winamp.albumart");
	if(albumart)
	{
		Layout aalayout = albumart.getLayout("normal");
		if(aalayout)
		{
			waaa = aalayout.findObject("waaa");
		}
	}
}

System.onScriptUnloading(){
	delete songInfoTimer;
}

System.onPlay(){
	String sit = getSongInfoText();
	waaaRetries = 0;
	if (sit != "") getSonginfo(sit);
	else songInfoTimer.setDelay(250); // goes to 250ms once info is available
	songInfoTimer.start();
}

System.onTitleChange(String newtitle){
	String sit = getSongInfoText();
	waaaRetries = 0;
	if (sit != "") getSonginfo(sit);
	else songInfoTimer.setDelay(250); // goes to 250ms once info is available
	songInfoTimer.start();
}

System.onStop(){
	waaaRetries = 0;
	songInfoTimer.stop();
	frequencyText.setText("(__)");
	bitrateText.setText("(___)");
	channelDisplay.setXmlParam("image", "player.songinfo.none");
}

System.onResume(){
	String sit = getSongInfoText();
	if (sit != "") getSonginfo(sit);
	else songInfoTimer.setDelay(250); // goes to 250ms once info is available
	songInfoTimer.start();
}

System.onPause(){
	songInfoTimer.stop();
}

songInfoTimer.onTimer(){
	String sit = getSongInfoText();
	if (sit == "") return;
	songInfoTimer.setDelay(250);
	getSonginfo(sit);

	if(!waaa) loadPlaylistArtWork();
	if(waaa)
	{
		if(waaa.isInvalid() && waaaRetries < 5)
		{
			waaaRetries += 1;
			waaa.refresh();
			waaa.show();
		}
		else if(!waaa.isInvalid())
		{
			waaaRetries = 0;
		}
	}
}

String tokenizeSongInfo(String tkn, String sinfo){
	int searchResult;
	String rtn;
	if (tkn=="Bitrate"){
		for (int i = 0; i < 5; i++) {
			rtn = getToken(sinfo, " ", i);
			searchResult = strsearch(rtn, "kbps");
			if (searchResult>0) return StrMid(rtn, 0, searchResult);
		}
		return "";
	}

	if (tkn=="Channels"){
		for (int i = 0; i < 5; i++) {
			rtn = getToken(sinfo, " ", i);
			searchResult = strsearch(rtn, "tereo");
			if (searchResult>0) return "stereo";
			searchResult = strsearch(rtn, "ono");
			if (searchResult>0) return "mono";
			// Martin: surround > 3, stereo = 2,3
			searchResult = strsearch(rtn, "annels");
			if (searchResult>0)
			{
				int pos = strsearch(getSongInfoText(), "annels");
				pos = stringToInteger(strmid(getSongInfoText(), pos - 4, 1));
				if (pos > 3) return "surround";
				if (pos > 1 && pos < 4) return "stereo";
				else return "mono";
			}
		}
		return "none";
	}

	if (tkn=="Frequency"){
		for (int i = 0; i < 5; i++) {
			rtn = getToken(sinfo, " ", i);
			searchResult = strsearch(strlower(rtn), "khz");
			if (searchResult>0) {
				String r = StrMid(rtn, 0, searchResult);
				int dot = StrSearch(r, ".");
				if (dot == -1) dot = StrSearch(r, ",");
				if (dot != -1) return StrMid(r, 0, dot);
				return r;
			}

		}
		return "";
	}
	else return "";
}

getSonginfo(String SongInfoString) {
	String tkn;

	tkn = tokenizeSongInfo("Bitrate", SongInfoString);
	int bitrateint = System.Stringtointeger(tkn);
	String bitratestring = System.IntegerToString(bitrateint);
	if(tkn != "") {bitrateText.setText("["+tkn+"]");}
	if(bitrateint < 100) {bitrateText.setText("[ "+tkn+"]");}
	if(bitrateint < 10) {bitrateText.setText("[  "+tkn+"]");}
	//if(bitrateint > 1000) {bitrateText.setText("["+strleft(tkn, 2)+"H]");} //what's this? Hhousands?
	//if(bitrateint > 10000) {bitrateText.setText("[ "+strleft(tkn, 1)+"C]");} //Cillions???
	if(bitrateint == 0) {bitrateText.setText("[ "+"--"+"]");}

	tkn = tokenizeSongInfo("Channels", SongInfoString);
	channelDisplay.setXmlParam("image", "player.songinfo." + tkn);
	tkn = tokenizeSongInfo("Frequency", SongInfoString);
	int freqint = System.Stringtointeger(tkn);
	String freqstring = System.IntegerToString(freqint);
	if(tkn != "") {frequencyText.setText("["+tkn+"]");}
	if(freqint < 100) {frequencyText.setText("["+tkn+"]");}
	if(freqint > 100) {FrequencyText.setXmlParam("x", "69");} else{FrequencyText.setXmlParam("x", "71");}
	if(freqint < 10) {frequencyText.setText("[ "+tkn+"]");}
	if(freqint == 0) {frequencyText.setText("["+"--"+"]");}
}
