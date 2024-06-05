//Laura
class BarChart {
  int totalCasesY;
  int maxY = 1;
  IntList totalCasesInDay;
  String date;
  IntList stateBars;
  State state;
  IntList countyBars;
  IntList individualCountyBars;
  County county;
  int j = 0;
  float cornerX, cornerY, xWidth, yWidth;
  float widthOfBars, heightOfBar;
  float angle;
  float textWidth;
  StringList dates;
  int increments;
  int power= 1;
  float yAxisLabelsWidth=0;
  float xAxisLabelsWidth=0;
  float datesFontSize;
  int datesShownMultiplier;
  ArrayList<ArrayList<String>> bar;
  ArrayList<String> info;

  BarChart(float cornerX, float cornerY, float xWidth, float yWidth) {
    this.cornerX = cornerX;
    this.cornerY = cornerY;
    this.xWidth = xWidth;
    this.yWidth = yWidth;
    angle = radians(300);
    bar = new ArrayList<ArrayList<String>>();
    info = new ArrayList<String>();
  }

  void draw() {
  }

  void hoverOver(int barNumber) {
    fill(255);
    noStroke();
    rect(mouseX - (parseInt(bar.get(barNumber).get(bar.get(barNumber).size()-1))), mouseY - ((bar.get(barNumber).size()-2)*TEXTSIZE*1.3 + 30), (parseInt(bar.get(barNumber).get(bar.get(barNumber).size()-1))), (bar.get(barNumber).size()-2)*TEXTSIZE*1.3 + 30);
    textAlign(CENTER, TOP);
    for (int i = 0; i < bar.get(barNumber).size() - 1; i++) {
      fill(0);
      text(bar.get(barNumber).get(i), mouseX - (parseInt(bar.get(barNumber).get(bar.get(barNumber).size()-1)))/2, mouseY - ((bar.get(barNumber).size()-2)*TEXTSIZE*1.3 + 20) + i*TEXTSIZE*1.3);
    }
    textAlign(RIGHT, BOTTOM);
  }
}
class allCasesByDateBarChart extends BarChart {
  allCasesByDateBarChart(float cornerX, float cornerY, float xWidth, float yWidth) {
    super(cornerX, cornerY, xWidth, yWidth);
    getArrayOfBars();
  }

  void getArrayOfBars() {
    totalCasesInDay = new IntList();
    dates = new StringList();
    for (int i = 0; i < dataPoints.size(); i++) {
      if (i > 0 && !dataPoints.get(i).date.equals(dataPoints.get(i-1).date)) {
        j++;
        totalCasesInDay.append(0);
        dates.set(j, dataPoints.get(i).date);
      }
      totalCasesY = dataPoints.get(i).cases;
      if (i > 0) totalCasesInDay.add(j, totalCasesY);
      else {
        j = 0;
        totalCasesInDay.append(totalCasesY);
        dates.set(j, dataPoints.get(i).date);
      }
      info = new ArrayList<String>();
      info.add("Date: " + dates.get(j));
      info.add("Cases: " + String.valueOf(totalCasesInDay.get(j)));
      if (info.get(0).length() > info.get(1).length()) info.add(String.valueOf(info.get(0).length()*8));
      else info.add(String.valueOf(info.get(1).length()*8));
      if (bar.size() == j) bar.add(info);
      else bar.set(j, info);

      if (totalCasesInDay.get(j) > maxY) maxY = totalCasesInDay.get(j);
    }
    increments = maxY;
    while (increments >= 10) {
      increments = increments/10;
      power+=1;
    }
    increments = (int)Math.pow(10, power-1)/2;
    if (increments > maxY) increments = maxY;
    if (increments == 0) increments = 1;
    datesFontSize = TEXTSIZE*.7;
    datesShownMultiplier = 1;
    while ((dates.size()/datesShownMultiplier)*(TEXTSIZE*1.2) >= xWidth) {
      datesShownMultiplier++;
    }
  }
  void draw() {
    textAlign(CENTER, BOTTOM);
    text("Nationwide Cases", cornerX + xWidth/2, cornerY - yWidth - 10);
    textAlign(RIGHT, CENTER);
    if (maxY%increments != 0) textSize(yWidth/(maxY%increments) + 10);
    else textSize(yWidth/(maxY/increments) + 10);
    if ((yWidth/(maxY/increments) + 10 > 22) || yWidth/(maxY%increments) + 10 > 22) textSize(18);
    widthOfBars = xWidth/(j+1);
    for (int c = 0; c*increments < maxY; c++) {
      text(c*increments, cornerX - 10, cornerY - (c*increments*(yWidth/maxY)));
      stroke(150);
      line(cornerX, cornerY - (c*increments*(yWidth/maxY)), cornerX + xWidth, cornerY - (c*increments*(yWidth/maxY)));
      if (textWidth(Integer.toString((c*increments))) > yAxisLabelsWidth) yAxisLabelsWidth = textWidth(Integer.toString((c*increments)));
    }
    textAlign(RIGHT, BOTTOM);
    if (yWidth > maxY%increments* (yWidth/maxY) + 22) text(maxY, cornerX-10, cornerY - yWidth);
    line(cornerX, cornerY - yWidth, cornerX + xWidth, cornerY - yWidth);
    stroke(0);
    strokeWeight(3);
    line(cornerX, cornerY, cornerX + xWidth, cornerY);
    line(cornerX, cornerY, cornerX, cornerY - yWidth);
    textSize(widthOfBars - 1);
    for (int i = 0; i < dates.size(); i++) {
      noStroke();
      heightOfBar = totalCasesInDay.get(i) * (yWidth/maxY);
      textSize(datesFontSize);
      rect(cornerX + widthOfBars*i, cornerY - heightOfBar, widthOfBars, heightOfBar);
      if (i % datesShownMultiplier == 0) {
        pushMatrix();
        translate(cornerX + (xWidth/(dates.size()/datesShownMultiplier))*(i/datesShownMultiplier) + widthOfBars/2, cornerY + 10);
        rotate(angle);
        text(dates.get(i), 0, 0);
        if (cos(angle-270)*textWidth(dates.get(i)) > xAxisLabelsWidth) xAxisLabelsWidth = cos(angle-270)*textWidth(dates.get(i));
        popMatrix();
      }
    }
    for (int i = 0; i < totalCasesInDay.size(); i++) {
      heightOfBar = totalCasesInDay.get(i) * (yWidth/maxY);
      if ((mouseX >= cornerX + widthOfBars*i && mouseX < cornerX + widthOfBars*(i+1)) && (mouseY >= cornerY - heightOfBar && mouseY < cornerY)) hoverOver(i);
    }
    textAlign(CENTER, BOTTOM);
    pushMatrix();
    textSize(TEXTSIZE);
    translate(cornerX - yAxisLabelsWidth - 20, cornerY - yWidth/2);
    rotate(radians(270));
    text("Cases", 0, 0);
    popMatrix();
    textAlign(CENTER, TOP);
    text("Dates", cornerX + xWidth/2, cornerY + xAxisLabelsWidth + 30);
  }
}

class allStateBarChart extends BarChart {
  allStateBarChart(float cornerX, float cornerY, float xWidth, float yWidth) {
    super(cornerX, cornerY, xWidth, yWidth);
    getArrayOfBars();
  }

  void getArrayOfBars() {
    stateBars = new IntList();
    for (int i = 0; i < states.size(); i++) {
      totalCasesY = states.get(i).getTotalStateCases();
      stateBars.append(totalCasesY);
      if (totalCasesY > maxY) maxY = totalCasesY;
    }
    increments = maxY;
    while (increments >= 10) {
      increments = increments/10;
      power+=1;
    }
    increments = (int)Math.pow(10, power-1)/2;
    if (increments > maxY) increments = maxY;
    if (increments == 0) increments = 1;
  }
  void draw() {
    textAlign(CENTER, BOTTOM);
    text("Nationwide Cases By State", cornerX + xWidth/2, cornerY - yWidth - 10);
    textAlign(RIGHT, CENTER);
    if (maxY%increments != 0) textSize(yWidth/(maxY%increments) + 10);
    else textSize(yWidth/(maxY/increments) + 10);
    if ((yWidth/(maxY/increments) + 10 > 22) || yWidth/(maxY%increments) + 10 > 22) textSize(18);
    widthOfBars = xWidth/(stateBars.size());
    for (int c = 0; c*increments < maxY; c++) {
      text(c*increments, cornerX - 10, cornerY - (c*increments*(yWidth/maxY)));
      stroke(150);
      line(cornerX, cornerY - (c*increments*(yWidth/maxY)), cornerX + xWidth, cornerY - (c*increments*(yWidth/maxY)));
      if (textWidth(Integer.toString((c*increments))) > yAxisLabelsWidth) yAxisLabelsWidth = textWidth(Integer.toString((c*increments)));
    }
    textAlign(RIGHT, BOTTOM);
    if (yWidth < maxY%increments* (yWidth/maxY) + 22) text(maxY, cornerX-10, cornerY - yWidth);
    line(cornerX, cornerY - yWidth, cornerX + xWidth, cornerY - yWidth);
    stroke(0);
    strokeWeight(3);
    line(cornerX, cornerY, cornerX + xWidth, cornerY);
    line(cornerX, cornerY, cornerX, cornerY - yWidth);
    for (int i = 0; i < stateBars.size(); i++) {
      noStroke();
      heightOfBar = stateBars.get(i) * (yWidth/maxY);
      rect(cornerX + widthOfBars*i, cornerY - heightOfBar, widthOfBars, heightOfBar);
      textSize(widthOfBars - 1);
      int k = 1;
      while (textWidth(states.get(i).name) > yWidth/7) {
        k++;
        textSize(widthOfBars - k);
      }
      if (widthOfBars - k > 22) textSize(22);
      pushMatrix();
      translate(cornerX + widthOfBars*(i+ 1) - widthOfBars/2, cornerY + 15);
      rotate(angle);
      text(states.get(i).name, 0, 0);
      if (cos(angle-270)*textWidth(states.get(i).name) > xAxisLabelsWidth) xAxisLabelsWidth = cos(angle-270)*textWidth(states.get(i).name);
      popMatrix();
    }
    textAlign(CENTER, BOTTOM);
    pushMatrix();
    textSize(TEXTSIZE);
    translate(cornerX - yAxisLabelsWidth - 20, cornerY - yWidth/2);
    rotate(radians(270));
    text("Cases", 0, 0);
    popMatrix();
    textAlign(CENTER, TOP);
    text("States", cornerX + xWidth/2, cornerY + xAxisLabelsWidth + 30);
  }
}

class stateByDateBarChart extends BarChart {

  stateByDateBarChart(State state, float cornerX, float cornerY, float xWidth, float yWidth) {
    super(cornerX, cornerY, xWidth, yWidth);
    this.state = state;
    getArrayOfBars();
  }

  void getArrayOfBars() {
    totalCasesInDay = new IntList();
    dates = new StringList();
    for (int i = 0; i < state.dataPointsInState.size(); i++) {
      if (i > 0 && !state.dataPointsInState.get(i).date.equals(state.dataPointsInState.get(i-1).date)) {
        j++;
        totalCasesInDay.append(0);
        dates.set(j, state.dataPointsInState.get(i).date);
      }
      totalCasesY = state.dataPointsInState.get(i).cases;
      if (i > 0) totalCasesInDay.add(j, totalCasesY);
      else {
        totalCasesInDay.append(totalCasesY);
        dates.set(j, state.dataPointsInState.get(i).date);
      }
      info = new ArrayList<String>();
      info.add("Date: " + dates.get(j));
      info.add("Cases: " + String.valueOf(totalCasesInDay.get(j)));
      if (info.get(0).length() > info.get(1).length()) info.add(String.valueOf(info.get(0).length()*8));
      else info.add(String.valueOf(info.get(1).length()*8));
      if (bar.size() == j) bar.add(info);
      else bar.set(j, info);

      if (totalCasesInDay.get(j) > maxY) maxY = totalCasesInDay.get(j);
    }
    increments = maxY;
    while (increments >= 10) {
      increments = increments/10;
      power+=1;
    }
    increments = (int)Math.pow(10, power-1)/2;
    if (increments > maxY) increments = maxY;
    if (increments == 0) increments = 1;
    datesFontSize = TEXTSIZE*.7;
    datesShownMultiplier = 1;
    while ((dates.size()/datesShownMultiplier)*(TEXTSIZE*1.2) >= xWidth) {
      datesShownMultiplier++;
    }
  }

  void draw() {
    textAlign(CENTER, BOTTOM);
    text("State of " + state.name, cornerX + xWidth/2, cornerY - yWidth - 10);
    textAlign(RIGHT, CENTER);
    if (maxY%increments != 0) textSize(yWidth/(maxY%increments) + 10);
    else textSize(yWidth/(maxY/increments) + 10);
    if ((yWidth/(maxY/increments) + 10 > 22) || yWidth/(maxY%increments) + 10 > 22) textSize(18);
    widthOfBars = xWidth/(j+1);
    for (int c = 0; c*increments < maxY; c++) {
      text(c*increments, cornerX - 10, cornerY - (c*increments*(yWidth/maxY)));
      stroke(150);
      line(cornerX, cornerY - (c*increments*(yWidth/maxY)), cornerX + xWidth, cornerY - (c*increments*(yWidth/maxY)));
      if (textWidth(Integer.toString((c*increments))) > yAxisLabelsWidth) yAxisLabelsWidth = textWidth(Integer.toString((c*increments)));
    }
    textAlign(RIGHT, BOTTOM);
    if (yWidth > maxY%increments* (yWidth/maxY) + 22) text(maxY, cornerX-10, cornerY - yWidth);
    line(cornerX, cornerY - yWidth, cornerX + xWidth, cornerY - yWidth);
    stroke(0);
    strokeWeight(3);
    line(cornerX, cornerY, cornerX + xWidth, cornerY);
    line(cornerX, cornerY, cornerX, cornerY - yWidth);
    for (int i = 0; i < totalCasesInDay.size(); i++) {
      noStroke();
      heightOfBar = totalCasesInDay.get(i) * (yWidth/maxY);
      textSize(datesFontSize);
      rect(cornerX + widthOfBars*i, cornerY - heightOfBar, widthOfBars, heightOfBar);
      if (i % datesShownMultiplier == 0) {
        pushMatrix();
        translate(cornerX + (xWidth/(dates.size()/datesShownMultiplier))*(i/datesShownMultiplier) + widthOfBars/2, cornerY + 10);
        rotate(angle);       
        text(dates.get(i), 0, 0);
        if (cos(angle-270)*textWidth(dates.get(i)) > xAxisLabelsWidth) xAxisLabelsWidth = cos(angle-270)*textWidth(dates.get(i));
        popMatrix();
      }
    }
    for (int i = 0; i < totalCasesInDay.size(); i++) {
      heightOfBar = totalCasesInDay.get(i) * (yWidth/maxY);
      if ((mouseX >= cornerX + widthOfBars*i && mouseX < cornerX + widthOfBars*(i+1)) && (mouseY >= cornerY - heightOfBar && mouseY < cornerY)) hoverOver(i);
    }
    textAlign(CENTER, BOTTOM);
    pushMatrix();
    textSize(TEXTSIZE);
    translate(cornerX - yAxisLabelsWidth - 20, cornerY - yWidth/2);
    rotate(radians(270));
    text("Cases", 0, 0);
    popMatrix();
    textAlign(CENTER, TOP);
    text("Dates", cornerX + xWidth/2, cornerY + xAxisLabelsWidth + 30);
  }
}


class allCountyBarChart extends BarChart {
  allCountyBarChart(State state, float cornerX, float cornerY, float xWidth, float yWidth) {
    super(cornerX, cornerY, xWidth, yWidth);
    this.state = state;
    getArrayOfBars();
  }
  void getArrayOfBars() {
    countyBars = new IntList();
    for (int i = 0; i < state.counties.size(); i++) {
      totalCasesY = state.counties.get(i).totalCases();
      countyBars.append(totalCasesY);
      if (totalCasesY > maxY) maxY = totalCasesY;
    }
    increments = maxY;
    while (increments >= 10) {
      increments = increments/10;
      power+=1;
    }
    increments = (int)Math.pow(10, power-1)/2;
    if (increments > maxY) increments = maxY;
    if (increments == 0) increments = 1;
  }
  void draw() {
    textAlign(CENTER, BOTTOM);
    text("State of " + state.name + " cases by county", cornerX + xWidth/2, cornerY - yWidth - 10);
    textAlign(RIGHT, CENTER);
    if (maxY%increments != 0) textSize(yWidth/(maxY%increments) + 10);
    else textSize(yWidth/(maxY/increments) + 10);
    if ((yWidth/(maxY/increments) + 10 > 22) || yWidth/(maxY%increments) + 10 > 22) textSize(18);
    widthOfBars = xWidth/(countyBars.size());
    for (int c = 0; c*increments < maxY; c++) {
      text(c*increments, cornerX - 10, cornerY - (c*increments*(yWidth/maxY)));
      stroke(150);
      line(cornerX, cornerY - (c*increments*(yWidth/maxY)), cornerX + xWidth, cornerY - (c*increments*(yWidth/maxY)));
      if (textWidth(Integer.toString((c*increments))) > yAxisLabelsWidth) yAxisLabelsWidth = textWidth(Integer.toString((c*increments)));
    }
    textAlign(RIGHT, BOTTOM);
    if (yWidth < maxY%increments* (yWidth/maxY) + 22) text(maxY, cornerX-10, cornerY - yWidth);
    line(cornerX, cornerY - yWidth, cornerX + xWidth, cornerY - yWidth);
    stroke(0);
    strokeWeight(3);
    line(cornerX, cornerY, cornerX + xWidth, cornerY);
    line(cornerX, cornerY, cornerX, cornerY - yWidth);
    for (int i = 0; i < countyBars.size(); i++) {
      noStroke();
      heightOfBar = countyBars.get(i) * (yWidth/maxY);
      rect(cornerX + widthOfBars*i, cornerY - heightOfBar, widthOfBars, heightOfBar);
      textSize(widthOfBars - 1);
      int k = 1;
      while (textWidth(state.counties.get(i).name) > yWidth/5) {
        k++;
        textSize(widthOfBars - k);
      }
      if (widthOfBars - k > 22) textSize(22);
      pushMatrix();
      translate(cornerX + widthOfBars*(i+ 1) - widthOfBars/2, cornerY + 15);
      rotate(angle);
      text(state.counties.get(i).name, 0, 0);
      if (cos(angle-270)*textWidth(state.counties.get(i).name) > xAxisLabelsWidth) xAxisLabelsWidth = cos(angle-270)*textWidth(state.counties.get(i).name);
      popMatrix();
    }
    textAlign(CENTER, BOTTOM);
    pushMatrix();
    textSize(TEXTSIZE);
    translate(cornerX - yAxisLabelsWidth - 20, cornerY - yWidth/2);
    rotate(radians(270));
    text("Cases", 0, 0);
    popMatrix();
    textAlign(CENTER, TOP);
    text("Counties", cornerX + xWidth/2, cornerY + xAxisLabelsWidth + 30);
  }
}

class individualCountyBarChart extends BarChart {
  individualCountyBarChart(County county, float cornerX, float cornerY, float xWidth, float yWidth) {
    super(cornerX, cornerY, xWidth, yWidth);
    this.county = county;
    getArrayOfBars();
  }

  void getArrayOfBars() {
    totalCasesInDay = new IntList();
    dates = new StringList();
    for (int i = 0; i < county.countyDataPoints.size(); i++) {
      if (i > 0 && !county.countyDataPoints.get(i).date.equals(county.countyDataPoints.get(i-1).date)) {
        j++;
        totalCasesInDay.append(0);
        dates.set(j, county.countyDataPoints.get(i).date);
      }
      totalCasesY = county.countyDataPoints.get(i).cases;
      if (i > 0) totalCasesInDay.add(j, totalCasesY);
      else {
        totalCasesInDay.append(totalCasesY);
        dates.set(j, county.countyDataPoints.get(i).date);
      }
      info = new ArrayList<String>();
      info.add("Date: " + dates.get(j));
      info.add("Cases: " + String.valueOf(totalCasesInDay.get(j)));
      if (info.get(0).length() > info.get(1).length()) info.add(String.valueOf(info.get(0).length()*8));
      else info.add(String.valueOf(info.get(1).length()*8));
      if (bar.size() == j) bar.add(info);
      else bar.set(j, info);

      if (totalCasesInDay.get(j) > maxY) maxY = totalCasesInDay.get(j);
    }
    increments = maxY;
    while (increments >= 10) {
      increments = increments/10;
      power+=1;
    }
    increments = (int)Math.pow(10, power-1)/2;
    if (increments > maxY) increments = maxY;
    if (increments == 0) increments = 1;
    datesFontSize = TEXTSIZE*.7;
    datesShownMultiplier = 1;
    while ((dates.size()/datesShownMultiplier)*(TEXTSIZE*1.2) >= xWidth) {
      datesShownMultiplier++;
    }
  }
  void draw() {
    textAlign(CENTER, BOTTOM);
    text("County  " + county.name, cornerX + xWidth/2, cornerY - yWidth - 10);
    textAlign(RIGHT, CENTER);
    if (maxY%increments != 0) textSize(yWidth/(maxY%increments) + 10);
    else textSize(yWidth/(maxY/increments) + 10);
    if ((yWidth/(maxY/increments) + 10 > 22) || yWidth/(maxY%increments) + 10 > 22) textSize(18);
    widthOfBars = xWidth/(j+1);
    for (int c = 0; c*increments < maxY; c++) {
      text(c*increments, cornerX - 10, cornerY - (c*increments*(yWidth/maxY)));
      stroke(150);
      line(cornerX, cornerY - (c*increments*(yWidth/maxY)), cornerX + xWidth, cornerY - (c*increments*(yWidth/maxY)));
      if (textWidth(Integer.toString((c*increments))) > yAxisLabelsWidth) yAxisLabelsWidth = textWidth(Integer.toString((c*increments)));
    }
    textAlign(RIGHT, BOTTOM);
    if (yWidth > maxY%increments* (yWidth/maxY) + 22) text(maxY, cornerX-10, cornerY - yWidth);
    line(cornerX, cornerY - yWidth, cornerX + xWidth, cornerY - yWidth);
    stroke(0);
    strokeWeight(3);
    line(cornerX, cornerY, cornerX + xWidth, cornerY);
    line(cornerX, cornerY, cornerX, cornerY - yWidth);
    for (int i = 0; i < totalCasesInDay.size(); i++) {
      noStroke();
      heightOfBar = totalCasesInDay.get(i) * (yWidth/maxY);
      textSize(datesFontSize);
      rect(cornerX + widthOfBars*i, cornerY - heightOfBar, widthOfBars, heightOfBar);
      if (i % datesShownMultiplier == 0) {
        pushMatrix();
        translate(cornerX + (xWidth/(dates.size()/datesShownMultiplier))*(i/datesShownMultiplier) + widthOfBars/2, cornerY + 10);
        rotate(angle);       
        text(dates.get(i), 0, 0);
        if (cos(angle-270)*textWidth(dates.get(i)) > xAxisLabelsWidth) xAxisLabelsWidth = cos(angle-270)*textWidth(dates.get(i));
        popMatrix();
      }
    }
    for (int i = 0; i < totalCasesInDay.size(); i++) {
      heightOfBar = totalCasesInDay.get(i) * (yWidth/maxY);
      if ((mouseX >= cornerX + widthOfBars*i && mouseX < cornerX + widthOfBars*(i+1)) && (mouseY >= cornerY - heightOfBar && mouseY < cornerY)) hoverOver(i);
    }
    textAlign(CENTER, BOTTOM);
    pushMatrix();
    textSize(TEXTSIZE);
    translate(cornerX - yAxisLabelsWidth - 20, cornerY - yWidth/2);
    rotate(radians(270));
    text("Cases", 0, 0);
    popMatrix();
    textAlign(CENTER, TOP);
    text("Dates", cornerX + xWidth/2, cornerY + xAxisLabelsWidth + 30);
  }
}
