//Anton
class Scrollbar
{
  int barWidth;
  int barHeight;    
  int barX;
  int barY;        
  float sliderX;
  float newSliderX;    
  int sliderMin;
  int sliderMax;  
  int sliderWeight;              
  boolean hover;          
  boolean locked;
  float ratio;

  Scrollbar (int x, int y, int barWidth, int barHeight, int sliderWeight) {
    this.barWidth = barWidth;
    this.barHeight = barHeight;
    int heightToWidth = barHeight - barWidth;
    this.ratio = (float)barHeight / (float)heightToWidth;
    this.barX = x-barWidth/2;
    this.barY = y;
    this.sliderX = y-1;
    this.newSliderX = sliderX;
    this.sliderMin = barY - 2;
    this.sliderMax = barY + barHeight - barWidth;
    this.sliderWeight = sliderWeight;
  }

  void move() {
    if (hover()) {
      hover = true;
    } else {
      hover = false;
    }
    if (mousePressed && hover) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newSliderX = constrain(mouseY-barWidth/2, sliderMin, sliderMax);
    }
    if (abs(newSliderX - sliderX) > 1) {
      sliderX = sliderX + (newSliderX-sliderX)/sliderWeight;
    }
  }

  int constrain(int val, int minV, int maxV) {
    return min(max(val, minV), maxV);
  }

  boolean hover() {
    if (mouseX > barX && mouseX < barX+barWidth &&
      mouseY > barY && mouseY < barY+barHeight) {
      return true;
    } else {
      return false;
    }
  }

  void draw() {
    stroke(0);
    strokeWeight(1);
    if (hover || locked) {
      fill(209, 233, 235);
    } else {
      fill(23, 171, 176);
    }
    rect(barX, sliderX, barWidth, barWidth);
  }

  float getPos() {
    return sliderX * ratio;
  }
}
