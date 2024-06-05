import org.gicentre.geomap.*;
class Screen {
  ArrayList<Widget> widgetsOnScreen = new ArrayList();
  int screenNumber;
  int backgroundColour;
  int event;
  boolean mouseBeingDragged = false;
  color widgetColour = color(23, 171, 176);
  int timer;
  int hoveringOver;
  BarChart[] barCharts;
  int currentBC = -1;
  boolean canScrollUp;
  boolean canScrollDown;
  boolean feedbackSent = false;
  Widget sentFeedback;
  feedbackBox feedback;
  int j;
  float imageY = 70;

  Scrollbar imageScroll, statesListScroll, dataPointScroll;

  float dataPointY = 0;
  float statesListLength = 0;

  Screen(int bgColour, int currentNumber) {
    screenNumber = currentNumber;
    backgroundColour = bgColour;
    addWidget();
  }

  void addWidget() {
    if (screenNumber == 0) {
      Widget getStarted;
      getStarted = new Widget(SCREENX/2 - 100, SCREENY/2 - 40, 200, 80, "Get Started", widgetColour, myFont, HOME);
      widgetsOnScreen.add(getStarted);
    }
    if (screenNumber > 0) {
      textBox search;
      Widget home, help, tweets, nationGraph, symptoms, statesList;
      home = new Widget(((SCREENX - 8*(5))/7)* 0 + 1*5, 10, ((SCREENX - 8*(5))/7), 50, "Home", widgetColour, myFont, HOME);
      nationGraph = new Widget(((SCREENX - 8*(5))/7)* 1 + 2*5, 10, ((SCREENX - 8*(5))/7), 50, "Nationwide Graph", widgetColour, myFont, NATIONGRAPH);
      symptoms = new Widget(((SCREENX - 8*(5))/7)* 2 + 3*5, 10, ((SCREENX - 8*(5))/7), 50, "Symptoms", widgetColour, myFont, SYMPTOMS);
      tweets = new Widget(((SCREENX - 8*(5))/7)* 3 + 4*5, 10, ((SCREENX - 8*(5))/7), 50, "Recent Tweets", widgetColour, myFont, TWEETS);
      statesList = new Widget(((SCREENX - 8*(5))/7)* 4 + 5*5, 10, ((SCREENX - 8*(5))/7), 50, "States List", widgetColour, myFont, STATESLIST);
      help = new Widget(((SCREENX - 8*(5))/7)* 5 + 6*5, 10, ((SCREENX - 8*(5))/7), 50, "Help", widgetColour, myFont, HELP);
      search = new textBox(((SCREENX - 8*(5))/7)* 6 + 7*5, 10, ((SCREENX - 8*(5))/7), 50, "Search", color(255), color(200), myFont, SEARCH);
      widgetsOnScreen.add(home);
      widgetsOnScreen.add(nationGraph);
      widgetsOnScreen.add(symptoms);
      widgetsOnScreen.add(tweets);
      widgetsOnScreen.add(statesList);
      widgetsOnScreen.add(help);
      widgetsOnScreen.add(search);
    }
    if (screenNumber == NATIONGRAPH) {
      barCharts = new BarChart[2];
      allCasesByDateBarChart byDate= new allCasesByDateBarChart(SCREENX*0.1, SCREENY*0.85, SCREENX*0.8, SCREENY*0.6);
      allStateBarChart byState= new allStateBarChart(SCREENX*0.1, SCREENY*0.85, SCREENX*0.8, SCREENY*0.6);
      barCharts[0] = byDate;
      barCharts[1] = byState;
      Widget byDateButton, byStateButton;
      byDateButton = new Widget(SCREENX/2 - 210, TOOLBARHEIGHT-20, 200, 30, "Number of Cases per Day", color(backgroundColour), myFont, 10);
      byStateButton = new Widget(SCREENX/2 + 10, TOOLBARHEIGHT-20, 200, 30, "Number of Cases per State", color(backgroundColour), myFont, 11);
      widgetsOnScreen.add(byDateButton);
      widgetsOnScreen.add(byStateButton);
      currentBC = 0;
    }
    if (screenNumber == STATESLIST) {
      barCharts = new BarChart[states.size()*102];
      for (int i = 0; i < states.size(); i++) {
        Widget stateButton = new Widget(SCREENX*0.05, TOOLBARHEIGHT + 80 + widgetsOnScreen.size()*SCREENY/28 + widgetsOnScreen.size()*SCREENY/100 - 7*50, textWidth(states.get(i).name), SCREENY/28, states.get(i).name, color(170), myFont, i*100 + 20);
        widgetsOnScreen.add(stateButton);
        barCharts[i*100] = new stateByDateBarChart(states.get(i), SCREENX*0.35, SCREENY - 150, SCREENX/1.8, SCREENY - 100 - TOOLBARHEIGHT - 80);
        for (int j = 0; j < states.get(i).counties.size() + 1; j++) {
          if (j == 0) {
            Widget countyButton = new Widget(SCREENX*0.07, TOOLBARHEIGHT + 80 + widgetsOnScreen.size()*SCREENY/28 + widgetsOnScreen.size()*SCREENY/100 - 7*50, textWidth("All Counties in State"), SCREENY/28, "All Counties in State", color(170), myFont, (i*100 + (j+1)) + 20);
            widgetsOnScreen.add(countyButton);
            barCharts[i*100 + (j+1)] = new allCountyBarChart(states.get(i), SCREENX*0.35, SCREENY - 150, SCREENX/1.8, SCREENY - 100 - TOOLBARHEIGHT - 80);
          } else {
            Widget countyButton = new Widget(SCREENX*0.07, TOOLBARHEIGHT + 80 + widgetsOnScreen.size()*SCREENY/28 + widgetsOnScreen.size()*SCREENY/100 - 7*50, textWidth(states.get(i).counties.get(j-1).name), SCREENY/28, states.get(i).counties.get(j-1).name, color(170), myFont, (i*100 + (j+1)) + 20);
            widgetsOnScreen.add(countyButton);
            barCharts[i*100 + (j+1)] = new individualCountyBarChart(states.get(i).counties.get(j-1), SCREENX*0.35, SCREENY - 150, SCREENX/1.8, SCREENY - 100 - TOOLBARHEIGHT - 80);
          }
        }
      }
      statesListScroll = new Scrollbar(SCREENX - 10, 70, 10, SCREENY -  70, 50000);
      statesListLength = (widgetsOnScreen.get(widgetsOnScreen.size() - 1).y + (height * 2)) - (widgetsOnScreen.get(0).y + height) - 1500;
      currentBC = 0;
    }
    if (screenNumber == TWEETS) {
      TweetsCreate();
      Widget tweetRefresh;
      tweetRefresh = new Widget(SCREENX/4 - 265, TOOLBARHEIGHT-20, 200, 30, "Refresh Tweets", color(29, 161, 242, 255), myFont, 12);
      widgetsOnScreen.add(tweetRefresh);
    }
    if (screenNumber == HELP) {
      feedback = new feedbackBox(SCREENX/2 - SCREENX/4, SCREENY/4, SCREENX/2, 500, "Please type your response here", color(255), color(200), myFont, FEEDBACKBOX);
      sentFeedback = new Widget(SCREENX/2 - (SCREENX/12)/2, SCREENY - SCREENY/10 - 10, SCREENX/12, SCREENY/10, "Send Feedback", color(backgroundColour), myFont, SENDFEEDBACK);
      widgetsOnScreen.add(feedback);
      widgetsOnScreen.add(sentFeedback);
      imageScroll = new Scrollbar(SCREENX - 10, 70, 10, SCREENY-70, 1);
    }
    if (screenNumber == SYMPTOMS) {
      Widget symptomsLinkWidget;
      symptomsLinkWidget = new Widget(30, 500, 500, 50, "Click Here for more info from HSE.ie", widgetColour, myFont, 19);
      Widget vaccineLinkWidget;
      vaccineLinkWidget = new Widget(30, 600, 600, 50, "Click Here to find out when you can get your vaccine", widgetColour, myFont, 18);
      widgetsOnScreen.add(symptomsLinkWidget);
      widgetsOnScreen.add(vaccineLinkWidget);
      imageScroll = new Scrollbar(SCREENX - 10, 70, 10, SCREENY-70, 3*5+1);
    }
  }

  void getEvent() {
    for (int i = 0; i<widgetsOnScreen.size(); i++) {
      Widget aWidget = (Widget) widgetsOnScreen.get(i);
      event = aWidget.getEvent();
      if (event >= HOME && event < SEARCH) {
        currentScreen = event;
      }
      if (event >= 9) {
        if (event >= 20) currentBC = event - 20;
        else currentBC = event -10;
      }
      if (event == 19) {
        link("https://www2.hse.ie/conditions/coronavirus/symptoms.html?gclid=CjwKCAjw07qDBhBxEiwA6pPbHkz9igGJdlFqKkgC8Z_mrntmp3HH9asaTmiex0QXqGkmFJGvbGL6whoCUcYQAvD_BwE&gclsrc=aw.ds");
      }
      if (event == 18) {
        link("https://www2.hse.ie/screening-and-vaccinations/covid-19-vaccine/rollout/rollout.html");
      }
    }
  }

  void draw() {
    if (currentScreen == screenNumber) background(backgroundColour); 
    hoveringOver = 0;
    for (int i = 0; i < widgetsOnScreen.size(); i++) {
      if (widgetsOnScreen.get(i).strokeColour == color(255) || widgetsOnScreen.get(i).strokeColour == color(100) ) hoveringOver++;
    }
    if (hoveringOver > 0) cursor(HAND);
    else cursor(ARROW);
    textFont(myFont);
    textSize(TEXTSIZE);
    fill(0);
    switch(currentScreen) {
    case 0:
      //Aisling
      text("Welcome to the Covid Tracker", SCREENX/2, 200);
      break;
    case HOME:
      noFill();
      rect(30, SCREENY-125, 220, 100);
      //fill(255);
      //rect(SCREENX - 15, 70, 10, 730);
      //for (int i = 0; i < dataPoints.size(); i++)
      //{
      //  dataPointY = (i*2) - ((dataPointScroll.getPos() - 70) * (dataPoints.size()/730));
      //  dataPoints.get(i).draw(dataPointY);
      //}
      //dataPointScroll.draw();
      //dataPointScroll.move();
      stroke(0);
      //background(202, 226, 245);  // Ocean colour
      for (int j = 0; j < maplist.size(); j++)
      {
        color createdColor = maplist.get(j).mapColor;

        fill(createdColor);          // Land colour  
        geoMap.draw(maplist.get(j).stateID);
      }
      //geoMap.writeAttributesAsTable(5);

      // Find the country at mouse position and draw in different colour.
      int id = geoMap.getID(mouseX, mouseY);
      if (id != -1)
      {
        fill(128, 128, 128);      // Highlighted land colour.
        geoMap.draw(id);
        String name = geoMap.getAttributeTable().findRow(str(id), 0).getString("Name");    
        fill(0);
        float cases=0;
        text(name, mouseX+5, mouseY-5);
        for (int j = 0; j < maplist.size(); j++)
        {
          if (maplist.get(j).stateID == id)
          {
            cases = maplist.get(j).totalCases;
          }
        }
        text("State: "+name, 35, SCREENY-100);
        text("Cases: "+(int)cases, 35, SCREENY-50);
      }
      break;
    case NATIONGRAPH:
      if (currentBC >= 0) barCharts[currentBC].draw();
      break;
    case SYMPTOMS:
      fill(255);
      rect(SCREENX - 15, 70, 10, 730);
      fill(0);
      fill(0);
      textSize(25);
      text("Common Covid19 Symptoms according to the HSE:", 300, 110);
      textSize(18);
      ellipse(30, 150, 8, 8);
      text("A fever (38 degrees Celsius or above)", 200, 150);
      ellipse(30, 185, 8, 8);
      text("A new cough, this can be any kind of cough, not just dry", 265, 185);
      ellipse(30, 215, 8, 8);
      text("Shortness of breath or breathing difficulties", 215, 215);
      ellipse(30, 250, 8, 8);
      text("Loss or change to your sense of smell or taste", 235, 250);
      ellipse(60, 275, 6, 6);
      textSize(16);
      text("This means you cannot smell/ taste or those senses have changed", 305, 275);
      textSize(18);
      ellipse(30, 300, 8, 8);
      text("Sneezing is not a symptom of Covid-19", 200, 300);
      tint(255);
      imageY = 70 - ((imageScroll.getPos() - 70) * (symptomsTable.height/730));
      image(symptomsTable, 650, imageY);
      imageScroll.draw();
      imageScroll.move();
      break;
    case TWEETS:
      float k=0;
      if (event ==12)
      {
        TweetsFetch();
        TweetsCreate();
        event=0;
        k = 0;
      }
      for (int i = 0; i < tweetObjects.length; i++)
      {
        if (tweetObjects[i].isOnScreen == true) {
          if (i == 0) canScrollUp = false;
          tweetObjects[i].draw(i);
        }

        if (!tweetObjects[0].isOnScreen) canScrollUp = true;
        if (!tweetObjects[tweetObjects.length - 1].isOnScreen) {
          timer = 0;
          canScrollDown = true;
        }
        tweetObjects[i].isOnScreen();
        if ((canScrollUp && scrollSpeed < 0) || (canScrollDown && scrollSpeed > 0)) tweetObjects[i].move();
        if (tweetObjects[i].isOnScreen == true) {
          if (i == tweetObjects.length - 1) canScrollDown = false;
        }
      }
      scrollActivated++;
      if (scrollActivated == scrollDuration) {
        scrollActivated = 0;
        scrollDuration = 1;
        scrollSpeed = 0;
      }
      break;
    case STATESLIST:
      fill(255);
      rect(SCREENX - 15, 70, 10, 730);
      fill(0);
      if (currentBC >= 0) barCharts[currentBC].draw();
      for (int i = 7; i < widgetsOnScreen.size(); i++) {
        widgetsOnScreen.get(i).isOnScreen();
        if (widgetsOnScreen.get(i).isOnScreen) widgetsOnScreen.get(i).draw();
        widgetsOnScreen.get(i).y = (widgetsOnScreen.get(i).initialY) - ((statesListScroll.getPos() - 70) * (statesListLength/730));
        statesListScroll.draw();
        statesListScroll.move();
      }
      scrollActivated++;
      if (scrollActivated == scrollDuration) {
        scrollActivated = 0;
        scrollDuration = 1;
        scrollSpeed = 0;
      }
      break;
    case HELP:
      if (!feedbackSent) {
        feedback.draw();
        fill(0);
        text("Please leave us feedback:", SCREENX/2 - SCREENX/4, SCREENY/5 + SCREENY/40);
        if (event == 11) {
          feedback.sendFeedback();
          feedbackSent = true;
          widgetsOnScreen.remove(feedback);
          widgetsOnScreen.remove(sentFeedback);
          event = 0;
        }
      } else {
        textSize(25);
        text("Thank you for your feedback!", SCREENX/2 - 175, SCREENY/2);
      }
      break;
    }
    if (currentScreen == screenNumber) {
      if (currentScreen > 0) {
        noStroke();
        fill(100);
        rect(0, 0, SCREENX, TOOLBARHEIGHT*.7);
        fill(backgroundColour);
        rect(((SCREENX - 8*(5))/7)* (currentScreen -1) + currentScreen*5 - 2, TOOLBARHEIGHT*.05, ((SCREENX - 8*(5))/7) + 5, TOOLBARHEIGHT*.65, (((SCREENX - 8*(5))/7) + 2)/30, (((SCREENX - 8*(5))/7) + 2)/30, 0, 0);
      }
      if (screenNumber != STATESLIST) {
        for (int i = 0; i<widgetsOnScreen.size(); i++) {
          Widget aWidget = (Widget) widgetsOnScreen.get(i);
          aWidget.draw();
        }
      } else {
        for (int i = 0; i<7; i++) {
          Widget aWidget = (Widget) widgetsOnScreen.get(i);
          aWidget.draw();
        }
      }
    }
  }
}
