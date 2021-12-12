#include "..\..\..\lib/std.mi"
#include "..\..\Winamp Modern/scripts/attribs.m"

Global Group frameGroup;
Global Layer xmaslights_l, xmaslights_m, xmaslights_r;
Global Timer refreshLights;
Global Int lightCount;

System.onScriptLoaded() {
    initAttribs();
    frameGroup = getScriptGroup();
    xmaslights_l = frameGroup.getObject("player.main.xmaslights.l");
    xmaslights_m = frameGroup.getObject("player.main.xmaslights.m");
    xmaslights_r = frameGroup.getObject("player.main.xmaslights.r");
    
    lightCount = 1;
    
    refreshLights = new Timer;
    refreshLights.setDelay(300);
    refreshLights.start();
    menubar_main_attrib.onDataChanged();
}

System.onscriptunloading() {
    delete refreshLights;
}

refreshLights.onTimer() {
    if(lightCount == 5) lightCount = 1;
    xmaslights_l.setXMLParam("image","player.main.xmaslights.l" + IntegerToString(lightCount));
    xmaslights_m.setXMLParam("image","player.main.xmaslights.m" + IntegerToString(lightCount));
    xmaslights_r.setXMLParam("image","player.main.xmaslights.r" + IntegerToString(lightCount));
    lightCount++;
}

menubar_main_attrib.onDataChanged() {
    if (menubar_main_attrib.getData() == "0"){
        xmaslights_l.setXMLParam("y", "-268");
        xmaslights_m.setXMLParam("y", "-265");
        xmaslights_r.setXMLParam("y", "-267");
    }else{
        xmaslights_l.setXMLParam("y", "-251");
        xmaslights_m.setXMLParam("y", "-248");
        xmaslights_r.setXMLParam("y", "-250");
    }
}


