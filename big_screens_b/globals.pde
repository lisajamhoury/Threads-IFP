//POSTITIONING
PVector PULSECTR;
PVector LEFTEMGCTR;
PVector RIGHTEMGCTR;
float ONETHIRD;
float TWOTHIRD;
float AREA;

//GRID 
int resolution;
int columns;
int rows;

void setupGlobals() {  
  //Set positioning constants
  PULSECTR = new PVector(0.5*width, 0.5*height);
  LEFTEMGCTR = new PVector(0.16*width, 0.5*height);
  RIGHTEMGCTR = new PVector(0.82*width, 0.5*height);
  ONETHIRD = 0.33*width;
  TWOTHIRD = 0.66*width;
  AREA = width * height;
  
  resolution = floor(width/180); // scale resolution to canvas size 
  columns = width / resolution;
  rows = height / resolution;  
}