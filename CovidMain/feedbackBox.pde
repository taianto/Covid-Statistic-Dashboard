//Anton
class feedbackBox extends textBox {
  color fontColor;
  boolean startedTyping;
  String displayedText;
  int loopTimer;
  int line = 0;
  float widthMultiplier = 0.8;
  float textWidth;
  float rectX;

  feedbackBox(float x, int y, int width, int height, String label, color widgetColor, color fontColor, PFont widgetFont, int event) {
    super( x, y, width, height, label, widgetColor, fontColor, widgetFont, event);
    this.fontColor = fontColor;
  }

  void draw() {
    hoverOver();
    isOnScreen();
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
    textAlign(LEFT, TOP);
    textFont(widgetFont);
    textSize(22);
    if (startedTyping) {
      displayedText = (displayedText.length() < 650 && pressedWhen == textBoxPressed)? userText : displayedText;
    } else {
      displayedText = (pressed)? userText : "";
    }
    startedTyping = (displayedText.length() == 0)? false : true;
    if (pressed) {
      if (startedTyping) {
        text(displayedText, x+width/10, y+height/10, (width) - ((width/10) * 2), height);
      }
      stroke(fontColor);
    } else {
      fill(fontColor);
      text(label, x+width/10, y+height/10);
    }
    text(displayedText.length() + "/650", SCREENX/2 + SCREENX/5, SCREENY/2 + SCREENY/2.5);
  }

  void sendFeedback() {
    output.println(userText);
    output.flush();
    output.close();
  }
    @Override int getEvent() {
    if (mouseX>x && mouseX < x+width && mouseY >y && mouseY <y+height && ableToBePressed) {
      if (!pressed) {
        pressed = true; 
        ableToBePressed = false;
        textBoxPressed++;
        pressedWhen = textBoxPressed;
        userText = "";
      } else pressed = false;
      return event;
    }
    return EVENT_NULL;
  }
}
