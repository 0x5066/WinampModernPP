#include "lib/std.mi"

Global Group tipGroup;
Global Text tipText;
Global GuiObject tipBorder, tipBG;
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

  tipText.setXmlParam("fontsize", IntegerToString(14*layoutscale));
  tipBorder.setXmlParam("h", IntegerToString(17*layoutscale));
  tipBG.setXmlParam("h", IntegerToString((17*layoutscale)-2));

  int x = getMousePosX();
  int y = getMousePosY()+21; //follows behavior from windows

  int vpleft = getViewportLeftFromPoint(x, y);
  int vptop = getViewportTopFromPoint(x, y);
  int vpright = vpleft+getViewportWidthFromPoint(x, y);
  int vpbottom = vptop+getViewportHeightFromPoint(x, y);

  int w = getTextWidth();
  int h = tipGroup.getHeight()*layoutscale;

  if (x + w > vpright) x = vpright - w;
  if (x < vpleft) x = vpleft;
  if (x + w > vpright) { w = vpright-vpleft-64; x = 32; }
  if (y + h > vpbottom) y = vpbottom - h;
  if (y < vptop) y = vptop + 32; // avoid mouse
  if (y + h > vpbottom) { h = vpbottom-vptop-64; y = 32; }

  tipGroup.resize(x, y, w, h);
}