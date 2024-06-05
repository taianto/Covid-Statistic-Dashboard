class Widget {
  float x, y, width, height;
  String label; 
  int event;
  color widgetColor, labelColor, strokeColour;
  PFont widgetFont;
  float percentageFilledUp = 1;
  boolean pressed = false;
  color pressedColour;
  int textSize = TEXTSIZE;
  float ypos;
  boolean isOnScreen = false;
  float initialY;

  Widget(float x, float y, float width, float height, String label, 
    color widgetColor, PFont widgetFont, int event) {
    this.x=x; 
    this.y=y; 
    this.initialY = y;
    this.width = width; 
    this.height= height;
    this.label=label; 
    this.event=event;
    this.widgetColor=widgetColor; 
    this.widgetFont=widgetFont;
    labelColor= color(0);
  }
  void draw() {
    hoverOver();
    strokeWeight(1);
    stroke(strokeColour);
    fill(widgetColor);
    rect(x, y, width, height, ((width>=height)? height/10 : width/10));
    if (mouseBeingHeld && (mouseX>x && mouseX < x+width && mouseY >y && mouseY <y+height) 
      && (initialMouseX>x && initialMouseX < x+width && initialMouseY >y && initialMouseY <y+height)) {
      noStroke();
      fill(0, 0, 0, 30);
      rect(x, y, width, height, ((width>=height)? height/10 : width/10));
    }
    fill(labelColor);
    textAlign(CENTER, CENTER);
    textFont(widgetFont);
    textSize(textSize);
    while (textWidth(label) > width*.8) {
      textSize--;
      textSize(textSize);
    }
    text(label, x+width/2, y+height/2);
  }
  int getEvent() {
    if (mouseX>x && mouseX < x+width && mouseY >y && mouseY <y+height && ableToBePressed) {
      if (!pressed) {
        pressed = true; 
        ableToBePressed = false;
      } else pressed = false;
      return event;
    }
    return EVENT_NULL;
  }

  void hoverOver() {
    if (mouseX>x && mouseX < x+width && mouseY >y && mouseY <y+height) strokeColour = color(255);
    else strokeColour = color(0);
  }
  
  void isOnScreen(){
    if(y > TOOLBARHEIGHT - 30 && y < SCREENY + height){
      isOnScreen = true;
    } else isOnScreen = false;
  }
}
