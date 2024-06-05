class checkBox extends Widget{
  checkBox(float x, int y, int width, int height, String label, color widgetColor, PFont widgetFont, int event, color pressedColour){
    super(x, y, width, height, label, widgetColor, widgetFont, event);
    this.pressedColour = pressedColour;
  }
  
  void draw(){
    hoverOver();
    stroke(strokeColour);
    fill(widgetColor);
    rect(x, y, width, height);
    if(pressed){
      fill(pressedColour);
      rect(x+width/4, y+width/4, width/2, height/2);
    }
    fill(labelColor);
    textAlign(LEFT, CENTER);
    textFont(widgetFont);
    textSize(TEXTSIZE);
    text(label, x + width + 10, y+height/2);
  }
}
