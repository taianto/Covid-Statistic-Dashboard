class sliderWidget extends Widget {
  int barWidth; int barHeight;
  float initialX;
  color barColour;
  
  sliderWidget(float x, int y, int width, int height, String label, color widgetColor, PFont widgetFont, int event, int barWidth, int barHeight, color barColour){
    super(x, y, width, height, label, widgetColor, widgetFont, event);
    this.barWidth=barWidth;
    this.barHeight=barHeight;
    this.barColour = barColour;
    initialX = x;
    this.x = int(initialX + barWidth/2 - width/2);
  }
  
  void draw(){
    hoverOver();
    stroke(0);
    fill(barColour);
    rect(initialX, y+ height/4, barWidth, barHeight, barHeight/10);
    stroke(strokeColour);
    fill(widgetColor);
    rect(x, y, width, height, ((width>=height)? height/10 : width/10));
    if(mouseBeingHeld && (mouseX <= x + width && mouseX >= x) 
    && (initialMouseX <= initialX + barWidth && initialMouseX >= initialMouseX) 
    && (mouseY <= y + height && mouseY >= y)){
      noStroke();
      fill(0, 0, 0, 30);
      rect(x, y, width, height, ((width>=height)? height/10 : width/10));
    }
    fill(labelColor);
    textAlign(CENTER, CENTER);
    textFont(widgetFont);
    textSize(22);
    if(height > barHeight) text(label, initialX+barWidth/2, y+height + 20);
    else text(label, initialX+barWidth/2, y+barHeight + 20);
  }
  
  void drag(){
    if(mouseX >= initialX && mouseX <= initialX + barWidth){
      x = mouseX - width/2;
      percentageFilledUp = x / (barWidth + initialX);
    }
  }
  
  @Override int getEvent(){
    if(mouseX >= x && mouseX <= x + width && mouseY >y && mouseY <y+height){
      drag();
      return event;
    }
    else return EVENT_NULL;
  }
}
