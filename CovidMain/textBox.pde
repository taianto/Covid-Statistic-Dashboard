class textBox extends Widget {
  color fontColor;
  boolean startedTyping;
  String displayedText;
  int loopTimer;
  String inputText;
  int pressedWhen = 0;
  boolean noResults = false;

  textBox(float x, int y, int width, int height, String label, color widgetColor, color fontColor, PFont widgetFont, int event) {
    super(x, y, width, height, label, widgetColor, widgetFont, event);
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
    textAlign(LEFT, CENTER);
    textFont(widgetFont);
    textSize(22);
    if (pressed && pressedWhen == textBoxPressed) {
      if (inputText != userText) noResults = false;
      inputText = userText;    
      search();
      if (noResults) {
        stroke(255);
        fill(255);
        rect(x, y+height, width, height*0.8);
        fill(0);
        textSize(TEXTSIZE-4);
        text("No Results Found", x + width*0.1, y+height + height/2 - (TEXTSIZE-4)/2);
      }
    }
    textSize(TEXTSIZE);
    displayedText = (pressed)? inputText : "";
    startedTyping = (displayedText.length() == 0)? false : true;
    if (pressed) {
      if (startedTyping) {
        displayedText = inputText;
        while (textWidth(displayedText) > width*.8) {
          displayedText = displayedText.substring(1);
        }
        text(displayedText, x+width/10, y+height/2);
      }
      stroke(fontColor);
      if (loopTimer < 30) rect(x+width/10 + textWidth(displayedText) + 3, y+height/2 - 11, 1, 22);
      else if ( loopTimer > 60) loopTimer = 0;
      loopTimer++;
    } else {
      fill(fontColor);
      text(label, x+width/10, y+height/2);
    }
  }

  void search() {
    if (querySent) {
      for (int i = 0; i < screens.get(STATESLIST).barCharts.length; i++) {
        if (screens.get(STATESLIST).barCharts[i] != null) {
          if (screens.get(STATESLIST).barCharts[i].state != null) {
            if ((inputText.equalsIgnoreCase(screens.get(STATESLIST).barCharts[i].state.name) && i % 100 == 0) || inputText == String.valueOf(screens.get(STATESLIST).barCharts[i].state.geoid)) {
              currentScreen = STATESLIST;
              screens.get(STATESLIST).currentBC = i;
              querySent = false;
            }
          }
          if (screens.get(STATESLIST).barCharts[i].county != null && querySent == true) {
            if ((inputText.equalsIgnoreCase(screens.get(STATESLIST).barCharts[i].county.name) && i % 100 != 0) || inputText == String.valueOf(screens.get(STATESLIST).barCharts[i].county.geoid)) {
              currentScreen = STATESLIST;
              screens.get(STATESLIST).currentBC = i;
              querySent = false;
            }
          }
        }
      }
      if (querySent) noResults = true;
      querySent = false;
    }
  }

  @Override int getEvent() {
    if (mouseX>x && mouseX < x+width && mouseY >y && mouseY <y+height && ableToBePressed) {
      if (!pressed) {
        pressed = true; 
        ableToBePressed = false;
        textBoxPressed++;
        pressedWhen = textBoxPressed;
        userText = "";
        querySent = false;
      } else pressed = false;
      return event;
    }
    return EVENT_NULL;
  }
}
