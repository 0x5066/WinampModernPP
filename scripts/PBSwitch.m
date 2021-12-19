//you can adapt this to your skins, credit is not necessary
//this just merely fixes the progressgrid still appearing 
//when it's left parameter is specified

#include "..\..\..\lib/std.mi"

Global GuiObject ProgressBar;

System.onScriptLoaded(){

    Group WAModernBar = getScriptGroup();

    ProgressBar = WAModernBar.findObject("ProgressBar");

    if(getStatus() == -1){
        ProgressBar.setXmlParam("visible", "1");
    }
    if(getStatus() == 0){
        ProgressBar.setXmlParam("visible", "0");
    }
    if(getStatus() == 1){
        ProgressBar.setXmlParam("visible", "1");
    }
}

System.onPlay(){
    ProgressBar.setXmlParam("visible", "1");
}

System.onStop(){
    ProgressBar.setXmlParam("visible", "0");
}

System.onPause(){
    ProgressBar.setXmlParam("visible", "1");
}

System.onResume(){
    ProgressBar.setXmlParam("visible", "1");
}