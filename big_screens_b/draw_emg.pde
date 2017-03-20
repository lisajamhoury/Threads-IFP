// Collect setup functions for draw functions here 
void setupDrawSensors() {
  setupEmgVehicles();
  setupMultiPulse();
}


//////////////// EMG VARIABLES ////////////////
import java.util.Iterator;

//DEBUG
boolean debugFrameRate = false;
boolean debugFlowField = false;
boolean debugOutPoints = false;

//Set top and bottom for EMG sensors 
//int emg1Low = 100;
//int emg1High = 1000;
//int emg2Low = 100;
//int emg2High = 1000;
int emgMapLow = 100;
int emgMapHigh = 255;

//Set noise for each flowfield
int noise1 = 7;
int noise2 = 14;

FlowField flowfield1; // field for left emg sensors of both performers
FlowField flowfield2; // field for right emg sensors of both performers
ArrayList<Magnet> magnet;
boolean emgRunning = true;

ArrayList<Vehicle> vehicles1L;
ArrayList<Vehicle> vehicles1R;
ArrayList<Vehicle> vehicles2L;
ArrayList<Vehicle> vehicles2R;
PVector v1LStart;
PVector v1RStart;
PVector v2LStart;
PVector v2RStart;

float minSpeed =  0.00000007; //0.00000030;
float maxSpeed = 4*minSpeed;
float force = 0.0000001;

// to control which part of emg sketch is drawn
int emgState = 0;

void setupEmgVehicles() {
  noiseSeed(noise1); // 7 ok, but a bit too noisy on right
  
  flowfield1 = new FlowField(resolution); // resolution declared globally
  magnet = new ArrayList<Magnet>(); 
  flowfield1.init();

  PVector magnetPos = new PVector(PULSECTR.x, 1.25 * PULSECTR.y);
  flowfield1.update(magnetPos);
  
  noiseSeed(noise2); // does this work twice ? 
  flowfield2 = new FlowField(resolution); // resolution declared globally 
  flowfield2.init();
  flowfield2.update(magnetPos);
  
  vehicles1L = new ArrayList<Vehicle>();
  vehicles1R = new ArrayList<Vehicle>();
  vehicles2L = new ArrayList<Vehicle>();
  vehicles2R = new ArrayList<Vehicle>();

  //EMG START POSITIONS 
  float v1Lx = 0;
  float v1Ly = 0.5 * height;
  float v1Rx = 0;
  float v1Ry = 0.73 * height;
  float v2Lx = width-1;
  float v2Ly = 0.2 * height;
  float v2Rx = width-1;
  float v2Ry = 0.35 * height;

  v1LStart = new PVector(v1Lx, v1Ly);
  v1RStart = new PVector(v1Rx, v1Ry);
  v2LStart = new PVector(v2Lx, v2Ly);
  v2RStart = new PVector(v2Rx, v2Ry);
}

void drawEmgVehicles() {
  emgRunning = true;
  addEmgVehicles();
  runEmgVehicles();
  if (debugFrameRate == true) {
    debugFrameRate();
  }

  if (debugFlowField == true) {
    debugFlowField();
  }
}

void drawFakeTriangle(int chance) {
  if (chance == 50) {
    fill(255);  
    beginShape();
    vertex(0, height);
    vertex(width, 0);
    vertex(width, height);
    endShape();
  }
}

void drawBigTriangle() {
  String emg1Logic = emgLogic(emg1LeftSensor, emg1RightSensor);
  String emg2Logic = emgLogic(emg2LeftSensor, emg2RightSensor);
  // draw white triange if logic is both high
  if (emg1Logic == "high" && emg2Logic == "high") {
    println("BOTH HIGH!!!!!!!");
    //float newX = random(resolution);
    //float newY = (0.95 * height) + (random(resolution));
    //float newX = 1;
    //float newY = height-1;
    //v1LStart.x = newX; 
    //v1LStart.y = newY;
    fill(255);  
    beginShape();
    vertex(0, height);
    vertex(width, 0);
    vertex(width, height);
    endShape();
  }
}

void addEmgVehicles() {  
  float bright1L = map(emg1LeftSensor, 0, 1000, emgMapLow, emgMapHigh);
  float bright1R = map(emg1RightSensor, 0, 1000, emgMapLow, emgMapHigh);
  float bright2L = map(emg2LeftSensor, 0, 1000, emgMapLow, emgMapHigh);
  float bright2R = map(emg2RightSensor, 0, 1000, emgMapLow, emgMapHigh);

  String emg1Logic = emgLogic(emg1LeftSensor, emg1RightSensor);
  String emg2Logic = emgLogic(emg2LeftSensor, emg2RightSensor);

  if (emgState == 5) {
    makeCrazyLinesLogic(emg1Logic, v1LStart, v1RStart, flowfield1.getOutPointsLeft(), flowfield2.getOutPointsLeft()); // TO DO CHECK THESE!!!!! DOES THIS WORK?????
    makeCrazyLinesLogic(emg2Logic, v2LStart, v2RStart, flowfield1.getOutPointsRight(), flowfield2.getOutPointsRight());  // TO DO CHECK THESE!!!!! DOES THIS WORK?????
    
    //makeCrazyLinesLogic(emg2Logic, v2LStart, v2RStart, fieldOutPointsLeft);
    //makeCrazyLinesLogic(emg2Logic, v2LStart, v2RStart, fieldOutPointsRight);
  }

  //if (emgState == 6) {
  //  //makeBigTriangle();
  //  println("here");
  //  v1LStart.x = 0.016455347;
  //  v1LStart.y = 207.82713;
  //  //v1LStart.x = 0.001;
  //  //v1LStart.y = height - 0.01;
  //  //int lastPos = vehicles1L.size()-1;
  //  //Vehicle myVehicle = vehicles1L.get(lastPos);
  //  //myVehicle.position.x.set(0.001);


  //}

  vehicles1L.add(new Vehicle(emg1Logic, bright1L, emgState, v1LStart.x, v1LStart.y, random(AREA*minSpeed, AREA*maxSpeed), random(AREA*force)));
  vehicles1R.add(new Vehicle(emg1Logic, bright1R, emgState, v1RStart.x, v1RStart.y, random(AREA*minSpeed, AREA*maxSpeed), random(AREA*force)));
  vehicles2L.add(new Vehicle(emg2Logic, bright2L, emgState, v2LStart.x, v2LStart.y, random(AREA*minSpeed, AREA*maxSpeed), random(AREA*force)));
  vehicles2R.add(new Vehicle(emg2Logic, bright2R, emgState, v2RStart.x, v2RStart.y, random(AREA*minSpeed, AREA*maxSpeed), random(AREA*force)));
}

void runEmgVehicles() {
  runVehiclesIterator(flowfield1, vehicles1L, v1LStart, "left");
  runVehiclesIterator(flowfield2, vehicles1R, v1RStart, "left");
  runVehiclesIterator(flowfield1, vehicles2L, v2LStart, "right");
  runVehiclesIterator(flowfield2, vehicles2R, v2RStart, "right");
}

void runVehiclesIterator(FlowField flowField, ArrayList<Vehicle> vehicles, PVector startPos, String screenSide) {
  if (emgRunning == true) {
    Iterator<Vehicle> it = vehicles.iterator();
    while (it.hasNext()) {
      Vehicle v = it.next();
      v.follow(flowField);
      v.run();
      if (v.isDead()) {
        if (screenSide == "left") {
          if (v.position.x > PULSECTR.x) {
            PVector reStart = new PVector(0, random(height));
            startPos.set(reStart);
          } else {
            startPos.set(v.position);
          }
        }

        if (screenSide == "right") {
          if (v.position.x < 0.55 * width) {
            PVector reStart = new PVector(width-1, random(height));
            startPos.set(reStart);
          } else {
            startPos.set(v.position);
          }
        }

        //startPos = v.position.copy(); 
        //startPos.set(v.position);
        it.remove();
      }
    }
  }
}


void makeCrazyLinesLogic(String logic, PVector startPosL, PVector startPosR, ArrayList<PVector> fieldPtsArray1, ArrayList<PVector> fieldPtsArray2) {
  
  //Choose random point from array of outpoints on ff1 -- correspond to left sensor
  int noOutPoints1 = fieldPtsArray1.size();
  int noPoint1 = int(random(noOutPoints1));
  PVector newStart1 = fieldPtsArray1.get(noPoint1);
  
  
  //Choose random point from array of outpoints on ff2 -- correspond to right sensor
  int noOutPoints2 = fieldPtsArray2.size();
  int noPoint2 = int(random(noOutPoints2));
  PVector newStart2 = fieldPtsArray2.get(noPoint2);

  if (logic == "high") {
    // if L/R sensors are both high, make them both crazy lines
    startPosL.x = newStart1.x;
    startPosL.y = height;
    startPosR.x = newStart2.x;
    startPosR.y = height;
  } else if (logic == "left high") {
    // if the left is high, turn just the right into a crazy line
    startPosL.x = newStart1.x;
    startPosL.y = height;
  } else if (logic == "right high") {
    // if the right is high, turn just the right into a crazy line
    startPosR.x = newStart2.x;
    startPosR.y = height;
  } else if (logic == "low") {
    // if both are L/R sensors are low, keep moving and keep in vertical center 
    float yOff = 0.1 * height;
    startPosL.y = height/2 + random(-yOff, yOff);
    startPosR.y = height/2 + random(-yOff, yOff);
  }
}


void debugFrameRate() {
  //FRAMERATE BOX
  colorMode(RGB);
  fill(255, 0, 0);
  rect(0, 0, 100, 100);
  fill(255);
  //text(floor(frameRate), 10, 40);
  // ff noise debug
  text(emgState, 10, 40);
  text(str(triangle), 10, 60);
  //vehicle array size debug
  //text(floor(vehicles1L.size()), 10, 60);
  //text(floor(vehicles1R.size()), 10, 80);
  //text(floor(vehicles2L.size()), 10, 100);
  //text(floor(vehicles2R.size()), 10, 120);
}

void debugFlowField() {
  flowfield1.display();
  flowfield2.display();

  Iterator<Magnet> it = magnet.iterator();
  while (it.hasNext()) {
    Magnet m = it.next();
    m.display();
  }
}


//////////////// END EMG VEHICLES ////////////////