// Aisling
class Tweet {
  
  String user;
  String tweet;
  float y;
  float ypos;
  PImage twitterImg;
  boolean isOnScreen = true;
  boolean scrolled = false;
  
  Tweet(String user, String tweet, PImage twitterImg, float y) {
    this.user = user;
    this.tweet = tweet;
    this.twitterImg = twitterImg;
    this.y = y;
  }
  
  void move () {
    ypos += scrollSpeedTweet;
  }
  
  void isOnScreen() {
    if (y < 14) {
      if ((40+(y-ypos)*120)>= 0 && (40+(y-ypos)*120)+100<= SCREENY) {
        isOnScreen = true;
      } else isOnScreen = false;
    }
    else{
      if ((40+(y-ypos)*120)+120 <= SCREENY) {
        isOnScreen = true;
      } else isOnScreen = false;
    }
  } 
  
  void draw(float y) {
    fill(29, 161, 242, 255);
    rect(SCREENX/4, (40+((y-ypos)*120)), SCREENX/2, 20);
    image(twitterImg, (SCREENX/4+SCREENX/2)-30, (40+(y-ypos)*120));
    tint(101, 119, 134);
    fill(255);
    text(user, SCREENX/4, (30+(y-ypos)*120), SCREENX/2, 40 );
    stroke(29, 161, 242);
    fill(255, 255, 255, 255);
    rect(SCREENX/4, (40+(y-ypos)*120)+20, SCREENX/2, 80);
    fill(0);
    text(tweet, SCREENX/4, (40+(y-ypos)*120)+20, SCREENX/2, 40 );
  }
}
  
