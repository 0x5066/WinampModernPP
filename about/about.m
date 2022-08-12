//painfully reverse engineered by mirzi, thank you so much!!
//this isn't documented much however it works
//about just as well as the original

#include "..\..\..\lib/std.mi"

Global int int10;           // some kind of counter?

Global int int11;           // ints 11 - 45 seem to be used for animating each of the 4 stars
Global int int12;
Global int int13;
Global int int14;
Global int int15;
Global int int16;
Global int int17;
Global int int18;
Global int int19;
Global int int20;
Global int int21;
Global int int22;
Global int int23;
Global int int24;
Global int int25;
Global int int26;
Global int int27;
Global int int28;
Global int int29;
Global int int30;
Global int int31;
Global int int32;
Global int int33;
Global int int34;
Global int int35;
Global int int36;
Global int int37;
Global int int38;
Global int int39;           // int39 - 32 is used for eyes
Global int int40;
Global int int41;
Global int int42;
Global int int43;
Global int int44;
Global int int45;
Global int int46;           // int 46 is used to iterate through the "string array" wrapped in the getStr function

Global Text text1;
Global Text text2;
Global Text text1b;
Global Text text2b;
//Global Text debugText;
Global Layer bolt;
Global Layer eye1;
Global Layer eye2;
Global AnimatedLayer star1;
Global AnimatedLayer star2;
Global AnimatedLayer star3;
Global AnimatedLayer star4;
Global Timer mainTimer;

// debug shit
Function String getValues();

// these 4 functions are used to calculate positions for each of the stars
Function func2349();
Function func2605();
Function func2861();
Function func3117();

// showNextStr is used for string array iteration on the text objects
Function showNextStr();

// getStr is a wannabe string array wrapped in a function
// you gotta do what you gotta do
Function String getStr(int a, int b);

System.onScriptLoaded(){
    Group scriptGroup;
    scriptGroup = System.getScriptGroup();
    bolt = scriptGroup.findObject(( "about.bolt"));
    star1 = scriptGroup.findObject(( "about.star1"));
    star2 = scriptGroup.findObject(( "about.star2"));
    star3 = scriptGroup.findObject(( "about.star3"));
    star4 = scriptGroup.findObject(( "about.star4"));
    eye1 = scriptGroup.findObject(( "about.eye1"));
    eye2 = scriptGroup.findObject(( "about.eye2"));
    text1 = scriptGroup.findObject(( "about.text1"));
    text2 = scriptGroup.findObject(( "about.text2"));
    text1b = scriptGroup.findObject(( "about.text1b"));
    text2b = scriptGroup.findObject(( "about.text2b"));
    //debugText = scriptGroup.findObject("debug.text");
    int10 = 100;
    int46 = 0;
    func2349();
    func2605();
    func2861();
    func3117();
    mainTimer = new Timer;
    mainTimer.setDelay(50);
    mainTimer.start();
}

System.onScriptUnloading(){
    delete mainTimer;
}

mainTimer.onTimer(){
    Float Float89;
    int int98;
    int int76;
    int int67;
    int int81;
    int int78;
    Float Float85;
    int int79;
    int int82;
    int int66;
    int int73;
    int int71;
    int int77;
    int66 = ( mainTimer.getSkipped() + 1); //what's the purpose of this???
    int67 = 6;
    if(( int67 > int66)) {
        int31 ++;
        int32 ++;
        int33 ++;
        int34 ++;
        if(( int31 < 14)) {
            int71 = ( ( System.sin(( int13 / 30)) * int15) + 149); //circle animation
            int73 = ( ( System.cos(( int13 / 30)) * int15) + 144); //circle animation
            star1.setXmlParam(( "x"), System.integerToString(int71)); //circle animation
            star1.setXmlParam(( "y"), System.integerToString(int73)); //circle animation
            int11 = ( int11 + int12);
            int13 = ( int13 + int14);
            if(( int11 < 0)) {
                int12 = ( - int12);
            }
            star1.gotoFrame(int11);
            star1.show();
        } else {
            star1.hide();
        if(( int31 > int35)) {
            func2349();
        }
    }
    if(( int32 < 14)) {
        int76 = ( ( System.sin(( int18 / 30)) * int20) + 149);
        int77 = ( ( System.cos(( int18 / 30)) * int20) + 144);
        star2.setXmlParam(( "x"), System.integerToString(int76));
        star2.setXmlParam(( "y"), System.integerToString(int77));
        int16 = ( int16 + int17);
        int18 = ( int18 + int19);
        if(( int16 < 0)) {
            int17 = ( - int17);
        }
    star2.gotoFrame(int16);
    star2.show();
    } else {
        star2.hide();
            if(( int32 > int36)) {
        func2605();
        }
    }
    if(( int33 < 14)) {
        int78 = ( ( System.sin(( int23 / 30)) * int25) + 149);
        int79 = ( ( System.cos(( int23 / 30)) * int25) + 144);
        star3.setXmlParam(( "x"), System.integerToString(int78));
        star3.setXmlParam(( "y"), System.integerToString(int79));
        int21 = ( int21 + int22);
        int23 = ( int23 + int24);
        if(( int21 < 0)) {
            int22 = ( - int22);
        }
    star3.gotoFrame(int21);
    star3.show();
    } else {
        star3.hide();
    if(( int33 > int37)) {
        func2861();
        }
    }
    if(( int34 < ( 56 / int43))) {
        int81 = ( ( System.sin(( int28 / 30)) * int30) + 149);
        int82 = ( ( System.cos(( int28 / 30)) * int30) + 144);
        star4.setXmlParam(( "x"), System.integerToString(int81));
        star4.setXmlParam(( "y"), System.integerToString(int82));
        int39 = ( ( System.sin(( int28 / 30)) * 7) + 183);
        Float85 = System.cos(( int28 / 30));
    if(( Float85 < 0)) {
        Float85 = ( - Float85);
    }
        int40 = ( ( Float85 * 12) + 76);
        eye1.setXmlParam(( "x"), System.integerToString(int39));
        eye1.setXmlParam(( "y"), System.integerToString(int40));
        int41 = ( ( System.sin(( int28 / 30)) * 7) + 200);
        Float89 = System.cos(( int28 / 30));
    if(( Float89 < 0)) {
        Float89 = ( - Float89);
    }
        int42 = ( ( Float89 * 11) + 77);
        eye2.setXmlParam(( "x"), System.integerToString(int41));
        eye2.setXmlParam(( "y"), System.integerToString(int42));
        int28 = ( int28 + int29);
        int26 = ( ( System.cos(( int28 * 2)) * 3) + 3);
        star4.gotoFrame(int26);
        star4.show();
    } else {
        star4.hide();
    if(( int34 > int38)) {
        func3117();
    }
    if(( int39 > 186)) {
        int39 --;
    }
    else if(( int39 < 186)) {
        int39 ++;
    }
    if(( int40 > 78)) {
        int40 --;
    }
    else if(( int40 < 78)) {
        int40 ++;
    }
    if(( int41 > 197)) {
        int41 --;
    }
    else if(( int41 < 197)) {
        int41 ++;
    }
    if(( int42 > 79)) {
        int42 --;
    }
    else if(( int42 < 79)) {
        int42 ++;
    }
        eye1.setXmlParam(( "x"), System.integerToString(int39));
        eye1.setXmlParam(( "y"), System.integerToString(int40));
        eye2.setXmlParam(( "x"), System.integerToString(int41));
        eye2.setXmlParam(( "y"), System.integerToString(int42));
    }
        int98 = ( ( System.getLeftVuMeter() + System.getRightVuMeter()) / 2);
        bolt.setAlpha(( 255 - int98));
        showNextStr();
        int67 ++;
    }

    //debugText.setText(getValues());
}

func2349(){
    int int104;
    int13 = ( System.random(999) + 999);
    int11 = 6;
    int12 = ( - 1);
    int14 = ( System.random(2) + 1);
    if(( System.random(10) < 5)) {
        int14 = ( - int14);
    }
    int104 = System.random(14);
    int15 = 68;
    int31 = 0;
    int35 = ( System.random(22) + 15);
    if(( int104 < 4)) {
        int15 = 56;
    }
    if(( int104 < 9)) {
        int15 = 31;
    }
}

func2605(){
    int int111;
    int18 = ( System.random(999) + 999);
    int16 = 6;
    int17 = ( - 1);
    int19 = ( System.random(2) + 1);
    if(( System.random(10) < 5)) {
        int19 = ( - int19);
    }
    int111 = System.random(14);
    int20 = 68;
    int32 = 0;
    int36 = ( System.random(42) + 15);
    if(( int111 < 4)) {
        int20 = 56;
    }
    if(( int111 < 9)) {
        int20 = 31;
    }
}

func2861(){
    int int113;
    int23 = ( System.random(999) + 999);
    int21 = 6;
    int22 = ( - 1);
    int24 = ( System.random(2) + 1);
    if(( System.random(10) < 5)) {
        int24 = ( - int24);
    }
    int113 = System.random(14);
    int25 = 68;
    int33 = 0;
    int37 = ( System.random(42) + 15);
    if(( int113 < 4)) {
        int25 = 56;
    }
    if(( int113 < 9)) {
        int25 = 31;
    }
}

func3117(){
    int28 = 70;
    int27 = ( - 1);
    int29 = ( System.random(2) + 1);
    int43 = int29;
    if(( System.random(10) < 5)) {
        int29 = ( - int29);
        int28 = 120;
    }
    int30 = 68;
    int34 = 0;
    int38 = ( System.random(222) + 77);
}

showNextStr(){
    if(( int10 == 50)) {
        int44 = 0;
        int45 = 255;
        text1.setText(getStr(int46, 2));
        text1b.setText(getStr(int46, 1));
        text2.setText(getStr(( int46 + 1), 2));
        text2b.setText(getStr(( int46 + 1), 1));
    }
    int10 ++;
    if(( int10 < 100)) {
        int44 = ( int44 - 10);
        int45 = ( int45 + 10);
    if(( int44 < 0)) {
        int44 = 0;
    }
    if(( int45 > 255)) {
        int45 = 255;
    }
    text1.setAlpha(int44);
    text1b.setAlpha(int44);
    text2.setAlpha(int45);
    text2b.setAlpha(int45);
    }
    if(( int10 > 100)) {
        text1.setText(getStr(( int46 + 2), 2));
        text1b.setText(getStr(( int46 + 2), 1));
        int44 = ( int44 + 10);
        int45 = ( int45 - 10);
    if(( int44 > 255)) {
        int44 = 255;
    }
    if(( int45 < 0)) {
        int45 = 0;
    }
        text1.setAlpha(int44);
        text1b.setAlpha(int44);
        text2.setAlpha(int45);
        text2b.setAlpha(int45);
    }
    if(( int10 > 150)) {
        int10 = 50;
        int46++;
        int AmountOfStrings;
        AmountOfStrings = 17;
        if(( int46 > AmountOfStrings )) { //increase 12 when adding new strings
            int46 = 0;
        }
    }
}

getStr(int a, int b){
    if(((a == 1) && (b == 1))) {
        return " ";
    }
    else if(((a == 1) && (b == 2))) {
        return " ";
    }
    else if(((a == 2) && (b == 1))) {
        return "W I N A M P";
    }
    else if(((a == 2) && (b == 2))) {
        return "Modern Skin";
    }
    else if(((a == 3) && (b == 1))) {
        return "Graphics and Coding";
    }
    else if(((a == 3) && (b == 2))) {
        return "by Sven Kistner a.k.a. bartibartman";
    }
    else if(((a == 4) && (b == 1))) {
        return "from";
    }
    else if(((a == 4) && (b == 2))) {
        return "www.metrix.de";
    }
    else if(((a == 5) && (b == 1))) {
        return "MAKI Scripts";
    }
    else if(((a == 5) && (b == 2))) {
        return "by Francis Gastellu and Sven Kistner";
    }
    else if(((a == 6) && (b == 1))) {
        return "Additional MAKI Scripts";
    }
    else if(((a == 6) && (b == 2))) {
        return "by Eris Lund (0x5066) and mirzi";
    }
    else if(((a == 7) && (b == 1))) {
        return "Reverse Engineering (about.maki)";
    }
    else if(((a == 7) && (b == 2))) {
        return "by mirzi (huge thanks to him!)";
    }
    else if(((a == 8) && (b == 1))) {
        return "Easteregg Development by";
    }
    else if(((a == 8) && (b == 2))) {
        return "Mike The Llama himself and Eris Lund (0x5066)";
    }
    else if(((a == 9) && (b == 1))) {
        return "Bugfixes and feature additions";
    }
    else if(((a == 9) && (b == 2))) {
        return "by Eris Lund (0x5066)";
    }
    else if(((a == 10) && (b == 1))) {
        return "Color themes by bartibartman, iPlayTheSpoons, lonedfx and";
    }
    else if(((a == 10) && (b == 2))) {
        return "EAK125, kiilu, matt_69, MdMa, Vicb, witmer777, Germ";
    }
    else if(((a == 11) && (b == 1))) {
        return "Additional color themes by Eris Lund, mirzi, ";
    }
    else if(((a == 11) && (b == 2))) {
        return "RaducuF28, Samey the Hedgie and dinnerbird";
    }
    else if(((a == 12) && (b == 1))) {
        return " ";
    }
    else if(((a == 12) && (b == 2))) {
        return "Please feel free to use this skin as a...";
    }
    else if(((a == 13) && (b == 1))) {
        return " ";
    }
    else if(((a == 13) && (b == 2))) {
        return "...reference point to build your new Winamp5 skins";
    }
    else if(((a == 14) && (b == 1))) {
        return "Special thanks to...";
    }
    else if(((a == 14) && (b == 2))) {
        return "mirzi, dro, Egor Petrov, Victhor, Ralf Engels and more...";
    }
    else if(((a == 15) && (b == 1))) {
        return "Thank you to those...";
    }
    else if(((a == 15) && (b == 2))) {
        return "... who tested and gave feedback on my work";
    }
    else if(((a == 16) && (b == 1))) {
        return "Without you...";
    }
    else if(((a == 16) && (b == 2))) {
        return "... we wouldn't be here today. <3";
    }
    else if(((a == 17) && (b == 1))) {
        return "https://getwacup.com";
    }
    else if(((a == 17) && (b == 2))) {
        return " ";
    }
    else if(((a == 18) && (b == 1))) {
        return " ";
    }
    else if(((a == 18) && (b == 2))) {
        return " ";
    }

    return " ";
}
/*
getValues(){
    return "debug\n"+
        "int10:" + integerToString(Int10) + "\n" +
        "int11:" + integerToString(Int11) + "\n" +
        "int12:" + integerToString(Int12) + "\n" +
        "int13:" + integerToString(Int13) + "\n" +
        "int14:" + integerToString(Int14) + "\n" +
        "int15:" + integerToString(Int15) + "\n" +
        "int16:" + integerToString(Int16) + "\n" +
        "int17:" + integerToString(Int17) + "\n" +
        "int18:" + integerToString(Int18) + "\n" +
        "int19:" + integerToString(Int19) + "\n" +
        "int20:" + integerToString(Int20) + "\n" +
        "int21:" + integerToString(Int21) + "\n" +
        "int22:" + integerToString(Int22) + "\n" +
        "int23:" + integerToString(Int23) + "\n" +
        "int24:" + integerToString(Int24) + "\n" +
        "int25:" + integerToString(Int25) + "\n" +
        "int26:" + integerToString(Int26) + "\n" +
        "int27:" + integerToString(Int27) + "\n" +
        "int28:" + integerToString(Int28) + "\n" +
        "int29:" + integerToString(Int29) + "\n" +
        "int30:" + integerToString(Int30) + "\n" +
        "int31:" + integerToString(Int31) + "\n" +
        "int32:" + integerToString(Int32) + "\n" +
        "int33:" + integerToString(Int33) + "\n" +
        "int34:" + integerToString(Int34) + "\n" +
        "int35:" + integerToString(Int35) + "\n" +
        "int36:" + integerToString(Int36) + "\n" +
        "int37:" + integerToString(Int37) + "\n" +
        "int38:" + integerToString(Int38) + "\n" +
        "int39:" + integerToString(Int39) + "\n" +
        "int40:" + integerToString(Int40) + "\n" +
        "int41:" + integerToString(Int41) + "\n" +
        "int42:" + integerToString(Int42) + "\n" +
        "int43:" + integerToString(Int43) + "\n" +
        "int44:" + integerToString(Int44) + "\n" +
        "int45:" + integerToString(Int45) + "\n" +
        "int46:" + integerToString(Int46);
}
*/