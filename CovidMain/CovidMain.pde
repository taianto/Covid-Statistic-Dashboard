import twitter4j.*;
import org.gicentre.geomap.*;
ArrayList tweets;
Tweet tweetObjects[] = new Tweet[15];
ConfigurationBuilder cb = new ConfigurationBuilder();
Twitter twitterInstance;
Query queryForTwitter;
State state;
PrintWriter output;
Table table;
int rows;
int columns;
int totalStateCases = 0;
boolean stateInList = false;
ArrayList<Datapoint> dataPoints;
ArrayList<State> states;
PFont myFont;
int maxCases = 0;
boolean allDataLoaded = false;
float scrollSpeed = 0;
float scrollSpeedTweet = 0;
int scrollDuration;
int scrollActivated;
boolean loadedStates = false;
color squareColour = color(255);
ArrayList<Screen> screens;
int currentScreen = 1;
int currentButton = 0;
float initialMouseX, initialMouseY;
boolean ableToBePressed = true;
boolean mouseBeingHeld;
String userText = "";
PImage twitterImg;
int textBoxPressed = 0;
boolean querySent = false;
PImage symptomsTable;
GeoMap geoMap;                // Declare the geoMap object.
int totalNationwideCases;
float highestStateCases =0;
float lowestStateCases = Integer.MAX_VALUE;
ArrayList<Map> maplist = new ArrayList();
Map minnesota, washington, montana, idaho, northDakota, maine, oregon, southDakota, newHampshire, vermont, wyoming, iowa, nebraska, massachusetts, illinois, pennsylvania, 
  conneticut, rhodeIsland, california, utah, nevada, ohio, indiana, newJersey, newYork, colorado, westVirginia, missouri, kansas, delaware, maryland, virginia, kentucky, arizona, 
  oklahoma, newMexico, tennessee, northCarolina, texas, arkansas, southCarolina, alabama, georgia, mississippi, louisiana, florida, michigan, wisconsin;


void settings() {
  size(SCREENX, SCREENY);
}

void setup() {
  geoMap = new GeoMap(80,TOOLBARHEIGHT,SCREENX-160,SCREENY-TOOLBARHEIGHT,this);  // Create the geoMap object.
  geoMap.readFile("usContinental");   // Reads shapefile.
  output = createWriter("feedback.txt");
  table = loadTable("daily-10k.csv", "header");
  states = new ArrayList<State>();
  dataPoints = new ArrayList<Datapoint>();
  myFont = loadFont("Arial-ItalicMT-18.vlw");
  symptomsTable = loadImage("symptomstable.PNG");
  textFont(myFont);
  loadData(0, table.getRowCount());
  screens = new ArrayList<Screen>();
  cb.setOAuthConsumerKey("5iZa26PJoy4l6pqHG9MNhJS5u");
  cb.setOAuthConsumerSecret("YIcZKFvZ1TZ8dFC98jjQSJirMLZxN8U0qV0NJNOBBJKPnEUscZ");
  cb.setOAuthAccessToken("908970988305616896-kkPTyTD1yh1QXZJTdeqZrddIrYj5fxg");
  cb.setOAuthAccessTokenSecret("TNlhk6KUPdXVHpIfeD5Re2Ka6ZIU3s7dUX3zZFa0a36XL");
  twitterInstance = new TwitterFactory(cb.build()).getInstance();
  queryForTwitter = new Query("#covid19");
  TweetsFetch();
  twitterImg = loadImage("twitter.png");
  twitterImg.resize(20, 20);
  for (int i = 0; i < AMOUNTOFSCREENS; i++) {
    Screen screen = new Screen(245, i);
    screens.add(screen);
  }
  createMap();
  addStateCases();
  getHighestValue();
  getLowestValue();
  for (int j = 0; j < maplist.size(); j++)
  {
    maplist.get(j).createColor();
  }
}

void loadData(int start, int end) {

  for (int i=start; i<end; i++)
  {
    String date = "";
    String county = "";
    String state = "";
    int geoid = 0;
    int cases = 0;
    String country = "";
    for (int j=0; j<table.getColumnCount(); j++)
    {
      switch (j) {
      case 0:
        date = table.getString(i, j);
        break;
      case 1:
        county = table.getString(i, j);
        break;
      case 2: 
        state = table.getString(i, j);
        break;
      case 3:
        geoid = table.getInt(i, j);
        break;
      case 4:
        if(table.getInt(i, j) > 0) cases = table.getInt(i, j);
        else cases = 0;
        if (cases > maxCases) maxCases = cases;
        break;
      case 5:
        country = table.getString(i, j);
        Datapoint dataPoint = new Datapoint(date, county, state, geoid, cases, country);
        dataPoints.add(dataPoint);
        break;
      }
    }
  }
  for (int i = 0; i < dataPoints.size(); i++) {
    for (int j = 0; j < states.size(); j++) {
      if (dataPoints.get(i).state.equals(states.get(j).name)) {
        stateInList = true;
      }
    }
    if (stateInList == false) {
      State state = new State(dataPoints.get(i).state, dataPoints);
      states.add(state);
    }
    stateInList = false;
  }
  allDataLoaded = true;
}


void draw() {
  frameRate(60);
  background(255);
  screens.get(currentScreen).draw();
  fill(0);
}

void mouseWheel(MouseEvent event) {
  scrollActivated = 0;
  scrollDuration = 20;
  scrollSpeed = event.getCount()*0.6;
  scrollSpeedTweet = event.getCount()*0.1;
}

void mousePressed() {
  scrollSpeed = 0;
  mouseBeingHeld = true;
  initialMouseX = mouseX;
  initialMouseY = mouseY;
}

void mouseReleased() {
  screens.get(currentScreen).getEvent();
  ableToBePressed = true;
  mouseBeingHeld = false;
}

void keyPressed() {
  if (key==CODED) {
    if (keyCode==LEFT) {
      //println ("left");
    } else {
      //println ("unknown special key");
    }
  } else
  {
    if (key==BACKSPACE) {
      if (userText.length()>0) {
        userText=userText.substring(0, userText.length()-1);
      }
    } else if (key==RETURN || key==ENTER) {
      querySent = true;
    } else {
      userText+=key;
    }
  }
}

//Aisling
void TweetsFetch() {
  try {
    QueryResult result = twitterInstance.search(queryForTwitter);
    tweets = (ArrayList) result.getTweets();
  } 
  catch(TwitterException te) {
    println("Couldn't connect: " + te);
  }
}

void TweetsCreate() {
  for (int i=0; i<tweets.size(); i++) {
    Status t = (Status) tweets.get(i);
    String user = t.getUser().getName();
    String msg = t.getText();
    Tweet newTweet = new Tweet(user, msg, twitterImg, (float)i);
    tweetObjects[i] = newTweet;
  }
}

int getTotalNationwideCases () {
  for (int i =0; i < states.size(); i++)
  {
    totalNationwideCases += states.get(i).getTotalStateCases();
  }
  return totalNationwideCases;
}

//Aisling
void createMap() {
  for (int j=1; j<52; j++)
  {
    switch (j) {
    case 1:
      minnesota = new Map(1, "Minnesota");
      maplist.add(minnesota);
      break;
    case 2:
      washington = new Map(2, "Washington");
      maplist.add(washington);
      break;
    case 3: 
      montana = new Map(3, "Montana");
      maplist.add(montana);
      break;
    case 4:
      idaho = new Map(4, "Idaho");
      maplist.add(idaho);
      break;
    case 5:
      northDakota = new Map(5, "North Dakota");
      maplist.add(northDakota);
      break;
    case 6:
      maine = new Map(6, "Maine");
      maplist.add(maine);
      break;
    case 7:
      oregon = new Map(7, "Oregon");
      maplist.add(oregon);
      break;
    case 8:
      southDakota = new Map(8, "South Dakota");
      maplist.add(southDakota);
      break;
    case 9:
      newHampshire = new Map(9, "New Hampshire");
      maplist.add(newHampshire);
      break;
    case 10:
      vermont = new Map(10, "Vermont");
      maplist.add(vermont);
      break;
    case 11:
      newYork = new Map(11, "New York");
      maplist.add(newYork);
      break;
    case 12:
      wyoming  = new Map(12, "Wyoming");
      maplist.add(wyoming);
      break;
    case 13:
      iowa = new Map(13, "Iowa");
      maplist.add(iowa);
      break;
    case 14:
      nebraska = new Map(14, "Nebraska");
      maplist.add(nebraska);
      break;
    case 15:
      massachusetts = new Map(15, "Massachusetts");
      maplist.add(massachusetts);
      break;
    case 16:
      illinois = new Map(16, "Illinois");
      maplist.add(illinois);
      break;
    case 17:
      pennsylvania = new Map(17, "Pennsylvania");
      maplist.add(pennsylvania);
      break;
    case 18:
      conneticut = new Map(18, "Conneticut");
      maplist.add(conneticut);
      break;
    case 19:
      rhodeIsland = new Map(19, "Rhode Island");
      maplist.add(rhodeIsland);
      break;
    case 20:
      california = new Map(20, "California");
      maplist.add(california);
      break;
    case 21:
      utah = new Map(21, "Utah");
      maplist.add(utah);
      break;
    case 22:
      nevada = new Map(22, "Nevada");
      maplist.add(nevada);
      break;
    case 23:
      ohio = new Map(23, "Ohio");
      maplist.add(ohio);
      break;
    case 24:
      indiana = new Map(24, "Indiana");
      maplist.add(indiana);
      break;
    case 25:
      newJersey = new Map(25, "New Jersey");
      maplist.add(newJersey);
      break;
    case 26:
      newYork = new Map(26, "New York");
      maplist.add(newYork);
      break;
    case 27:
      colorado = new Map(27, "Colorado");
      maplist.add(colorado);
      break;
    case 28:
      westVirginia = new Map(28, "West Virginia");
      maplist.add(westVirginia);
      break;
    case 29:
      missouri = new Map(29, "Missouri");
      maplist.add(missouri);
      break;
    case 30:
      kansas = new Map(30, "Kansas");
      maplist.add(kansas);
      break;
    case 31:
      delaware = new Map(31, "Delaware");
      maplist.add(delaware);
      break;
    case 32:
      maryland = new Map(32, "Maryland");
      maplist.add(maryland);
      break;
    case 33:
      virginia = new Map(33, "Virginia");
      maplist.add(virginia);
      break;
    case 34:
      kentucky = new Map(34, "Kentucky");
      maplist.add(kentucky);
      break;
    case 35:
      break;
    case 36:
      arizona = new Map(36, "Arizona");
      maplist.add(arizona);
      break;
    case 37:
      oklahoma = new Map(37, "Oklahoma");
      maplist.add(oklahoma);
      break;
    case 38:
      newMexico = new Map(38, "New Mexico");
      maplist.add(newMexico);
      break;
    case 39:
      tennessee = new Map(39, "Tennessee");
      maplist.add(tennessee);
      break;
    case 40:
      northCarolina = new Map(40, "North Carolina");
      maplist.add(northCarolina);
      break;
    case 41:
      texas = new Map(41, "Texas");
      maplist.add(texas);
      break;
    case 42:
      arkansas = new Map(42, "Arkansas");
      maplist.add(arkansas);
      break;
    case 43:
      southCarolina = new Map(43, "South Carolina");
      maplist.add(southCarolina);
      break;
    case 44:
      alabama = new Map(44, "Alabama");
      maplist.add(alabama);
      break;
    case 45:
      georgia = new Map(45, "Georgia");
      maplist.add(georgia);
      break;
    case 46:
      mississippi = new Map(46, "Mississippi");
      maplist.add(mississippi);
      break;
    case 47:
      louisiana = new Map(47, "Louisiana");
      maplist.add(louisiana);
      break;
    case 48:
      florida = new Map(48, "Florida");
      maplist.add(florida);
      break;
    case 49:
      michigan = new Map(49, "Michigan");
      maplist.add(michigan);
      break;
    case 50:
      michigan = new Map(50, "Michigan");
      maplist.add(michigan);
      break;
    case 51:
      wisconsin = new Map(51, "Wisconsin");
      maplist.add(wisconsin);
      break;
    }
  }
}

void addStateCases ()
{
  for (int j = 0; j < maplist.size(); j++)
  {
    String stateName = maplist.get(j).getName();
    for (int i =0; i < states.size(); i++)
    {
      if (states.get(i).name.equals(stateName))
      {
        maplist.get(j).totalCases = states.get(i).getTotalStateCases();
      }
    }
  }
}

void getHighestValue()
{
  for (int j = 0; j < maplist.size(); j++)
  {
    float currentCases = maplist.get(j).totalCases;
    if (currentCases > highestStateCases && maplist.get(j).stateName != "New York")
    {
      highestStateCases = currentCases;
    }
  }
}

void getLowestValue()
{
  for (int j = 0; j < maplist.size(); j++)
  {
    float currentCases = maplist.get(j).totalCases;
    if (currentCases < lowestStateCases)
    {
      lowestStateCases = currentCases;
    }
  }
}
