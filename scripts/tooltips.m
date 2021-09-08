#include "..\..\..\lib/std.mi"

Global Group tipGroup;
Global Text tipText;
Global GuiObject tipBorder;
Global Layer tipBG;
Global Double layoutscale;

Global Container containerMain;
Global Layout layoutMainNormal;

System.onScriptLoaded() {

  containerMain = System.getContainer("main");
	layoutMainNormal = containerMain.getLayout("normal");

  tipGroup = getScriptGroup();
  tipText = tipGroup.getObject("tooltip.text");
  tipBorder = tipGroup.getObject("tooltip.grid");
  tipBG = tipGroup.getObject("tooltip.grid.frame");

}

// When text is changed, resize the group accordingly and make sure it's fully visible

tipText.onTextChanged(String newtext) {
  //poll scale factor
  layoutscale = layoutMainNormal.getScale();
  if(layoutscale < 1) layoutscale = 1;
  if(layoutscale > 1) tipText.setXmlParam("antialias", "1");
  else tipText.setXmlParam("antialias", "0");

  tipText.setXmlParam("fontsize", IntegerToString(14*layoutscale));
  tipText.setXmlParam("x", IntegerToString(1*layoutscale));
  tipText.setXmlParam("y", IntegerToString(1*layoutscale));
  tipBorder.setXmlParam("h", IntegerToString(17*layoutscale));
  tipBG.setXmlParam("h", IntegerToString((17*layoutscale)-2));
  //tipBorder.setAlpha(0);
  //tipBG.setAlpha(0);

  if(layoutscale >= 2) int w = getTextWidth()+4;
  else w = getTextWidth();
  int h = tipGroup.getHeight()*layoutscale;

  int x = getMousePosX();
  int y = getMousePosY() - h; //follows behavior from windows

  int vpleft = getViewportLeftFromPoint(x, y);
  int vptop = getViewportTopFromPoint(x, y);
  int vpright = vpleft+getViewportWidthFromPoint(x, y);
  int vpbottom = vptop+getViewportHeightFromPoint(x, y);

  if (x + w > vpright) x = vpright - w;
  if (x < vpleft) x = vpleft;
  if (x + w > vpright) { w = vpright-vpleft-64; x = 32; }
  if (y + h > vpbottom) y = vpbottom - h;
  if (y < vptop) y = vptop + 32; // avoid mouse
  if (y + h > vpbottom) { h = vpbottom-vptop-64; y = 32; }

  if(layoutscale >= 2) tipGroup.resize(getMousePosX(), y, 0, h);
  else tipGroup.resize(getMousePosX(), y, 0, h);

  //tipBorder.setTargetA(255);
  //tipBorder.gotoTarget();
  //tipBorder.setTargetSpeed(0.25);

  //tipBG.setTargetA(255);
  //tipBG.gotoTarget();
  //tipBG.setTargetSpeed(0.25);

  tipGroup.setTargetW(w);
  tipGroup.setTargetX(x);
  tipGroup.setTargetSpeed(0.35);
  tipGroup.gotoTarget();
}
