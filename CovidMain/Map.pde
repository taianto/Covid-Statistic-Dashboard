//Aisling
class Map {
  int stateID;
  String stateName;
  float totalCases;
  color mapColor;
  
  Map (int stateID, String stateName)
  {
    this.stateID = stateID;
    this.stateName = stateName;
  }
  
  String getName () {
    return stateName;
  }
  
  void createColor()
  {
    int mappedValue = int(map(totalCases, lowestStateCases, highestStateCases, 0, 255)); 
    mapColor = color(255, 255-mappedValue, 255-mappedValue );  
    
  }
}
