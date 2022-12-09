#include "..\..\..\lib/std.mi"

Global GuiObject lpadoru;
Global Timer padoruanim, padoruspin;

Global int i, dice, ipadoru;

System.onScriptLoaded(){
    Group gpadoru = getContainer("Main").getLayout("Normal");
    //enables it to be run only in holiday edition

    lpadoru = gpadoru.findObject("lpadoru");

    padoruanim = new Timer;
    padoruanim.setDelay(80);

    padoruspin = new Timer;
    padoruspin.setDelay(160);
    
    if(getDateDay(getDate()) == 25 || getDateDay(getDate()) == 24 && getDateMonth(getDate()) == 11) padoruanim.start();

    i = -19;
    ipadoru = 0;
    lpadoru.setXmlParam("x", "-19");
    lpadoru.setXmlParam("visible", "1");

    dice = System.random(2);

    if(dice == 1) padoruspin.start();
}

padoruanim.onTimer(){
    i++;
    String iString = integertostring(i);
    if(i == 80) i = -19;
    lpadoru.setXmlParam("x", iString);
}

padoruspin.onTimer(){
    ipadoru++;
    String ipadoruString = integertostring(ipadoru);
    if(ipadoru == 3) ipadoru = 0;
    lpadoru.setXmlParam("image", "player.visualization.padoruanim"+ipadoruString);
}
