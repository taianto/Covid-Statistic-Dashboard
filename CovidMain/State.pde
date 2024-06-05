//Anton
class State {
  String name;
  String date;
  int geoid;
  String county;
  int cases;
  ArrayList<Datapoint> dataPoints;
  ArrayList<Datapoint> dataPointsInState;
  ArrayList<County> counties;
  boolean countyInList = false;
  int test = 0;
  int totalStateCases = 0;
  int mapID;

  State(String name, ArrayList<Datapoint> dataPoints) {
    this.name = name;
    this.dataPoints = dataPoints;
    counties = new ArrayList<County>();
    dataPointsInState = new ArrayList<Datapoint>();
    areasInState();
  }
  
  String getName() {
    return name;
  }

  void areasInState() {
    for (int i = 0; i < dataPoints.size(); i++) {
      if (dataPoints.get(i).state.equals(name)) {
        dataPointsInState.add(dataPoints.get(i));
        for (int j = 0; j < counties.size(); j++) {
          if (dataPoints.get(i).county.equals(counties.get(j).name)) {
            countyInList = true;
          }
        }
        if (countyInList == false) {
          County county = new County(dataPoints.get(i).county, dataPoints.get(i).geoid);
          counties.add(county);
        }
        countyInList = false;
      }
    }
  }

  void stateCasesDate() {
    for (int i = 0; i < dataPoints.size(); i ++) {
      if (dataPoints.get(i).state.equals(name)) {
        date = dataPoints.get(i).date;
        geoid = dataPoints.get(i).geoid;
        county = dataPoints.get(i).county;
        cases = dataPoints.get(i).cases;
      }
    }
  }

  int getTotalStateCases() {
    for (int i = 0; i < dataPoints.size(); i++) {
      if (dataPoints.get(i).state.equals(name)) {
        totalStateCases += dataPoints.get(i).cases;
      }
    }
    return totalStateCases;
  }
}
