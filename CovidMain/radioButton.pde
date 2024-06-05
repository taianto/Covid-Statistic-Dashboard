class radioButton extends Widget{
  int order;
  
  radioButton(float x, int y, int width, int height, String label, color widgetColor, PFont widgetFont, int event, color pressedColour, int order){
    super(x, y, width, height, label, widgetColor, widgetFont, event);
    this.pressedColour = pressedColour;
    this.order = order;
  }
  
  void draw(){
    hoverOver();
    stroke(strokeColour);
    ellipseMode(RADIUS);
    fill(widgetColor);
    ellipse(x, y, width, height);
    if(currentButton != order) pressed = false;
    if(pressed && currentButton == order){
      fill(pressedColour);
      ellipse(x, y, width/2, height/2);
    }
    fill(labelColor);
    textAlign(LEFT, CENTER);
    textFont(widgetFont);
    textSize(22);
    text(label, x + width + 10, y);
  }
  
  void hoverOver(){
    if(dist(mouseX, mouseY, x, y) <= width) strokeColour = color(255);
    else strokeColour = color(0);

  }
  
  @Override int getEvent() {
    if (dist(mouseX, mouseY, x, y) <= width) {
      currentButton = order;
      if(!pressed) pressed = true;
      else if (pressed) pressed = false;
      return event;
    }
    return EVENT_NULL;
  }
}
