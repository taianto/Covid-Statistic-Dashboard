class County {
  String name;
  int geoid;
  int cases;
  ArrayList<Datapoint> countyDataPoints;
  County(String county, int geoid) {
    this.name = county;
    this.geoid = geoid;
    countyDataPoints = new ArrayList<Datapoint>();

    for ( int i = 0; i < dataPoints.size(); i++) {

      if (dataPoints.get(i).geoid == geoid) {
        countyDataPoints.add(dataPoints.get(i));
      }
    }

    for ( int i = 0; i < countyDataPoints.size(); i++) {
      cases += countyDataPoints.get(i).cases ;
    }
  }
  int totalCases() {
    return cases;
  }

  int casesOnDate(String date) {
    for (int i = 0; i < countyDataPoints.size(); i++)
    {
      if (countyDataPoints.get(i).date.equals(date)) {
        return countyDataPoints.get(i).cases ;
      }
    }
    return 0 ;
  }
}
