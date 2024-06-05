class Datapoint{
  String date;
  String county;
  String state;
  int geoid;
  int cases;
  String country;
  boolean scrolled = false;
  float y;
  float ypos;
  float percentage;
  boolean isOnScreen = true;
  Datapoint(String date, String county, String state, int geoid, int cases, String country) {
    this.date = date;
    this.county = county;
    this.state = state;
    this.geoid = geoid;
    this.cases = cases;
    this.country = country;
    ypos = 0;
  }

  void move() {
    ypos += scrollSpeed;
  }

  void isOnScreen() {
    if (y < dataPoints.size() - 1) {
      if ((y - ypos) * TEXTSIZE + 18>= 0 && (y - ypos) * TEXTSIZE -18 <= SCREENY) {
        isOnScreen = true;
      } else isOnScreen = false;
    }
    else{
      if ((y - ypos) * TEXTSIZE + TOOLBARHEIGHT + 18 <= SCREENY) {
        isOnScreen = true;
      } else isOnScreen = false;
    }
  }

  void draw(float y) {
    textFont(myFont);
    textAlign(BOTTOM, LEFT);
    this.y = y;
    String outputString = date + " " + county + " " + state + " " + String.valueOf(geoid) + " " + String.valueOf(cases) + " " + country;
    fill(0);
    text(outputString, 20, (y - ypos) * TEXTSIZE + TOOLBARHEIGHT + 15);
    stroke(0);
    fill(255);
    rect(SCREENX/2, (y - ypos) * TEXTSIZE - 18 + TOOLBARHEIGHT + 15, SCREENX/2 -30, TEXTSIZE);
    noStroke();
    fill(0);
    rect(SCREENX/2, (y - ypos) * TEXTSIZE - 18 + TOOLBARHEIGHT + 15, (float)cases/(float)maxCases * (float)(SCREENX/2 - 30), TEXTSIZE);
  }
}
