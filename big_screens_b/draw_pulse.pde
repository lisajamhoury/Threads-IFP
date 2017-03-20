//////////////// BEGIN PULSE  ////////////////
boolean beat = false;
int pulseExDuration;  
int targetBoundX;
int targetBoundY;

int pulseExpandUnitX;
int pulseExpandUnitY;
int pulseStartTime;
int pulseIncTimeX;
int pulseIncTimeY;
//int pulseTimeElapsed;

int pulseBoundX = 2; //starting x boundaries 
int pulseBoundY = 2; //starting y boundaries

float pulseRectHeight = 0.01 * height;  // 0.0006 * width; 
float ctrPosLocY;

// variables to time removal of pulses 
boolean removePulsesSet = false;
int pulsesToRemove = 0;
int removePulseTime = 0;
int removeTotalTime = 20000; // remove time in millis -- currently 
int removeRate = 1000; // remove every 100 millis
float removeIncs = removeTotalTime/removeRate; // number of times to remove at given rate
float removeEachInc;

boolean animate = false;


//////////////// MULTI PULSE ////////////////
boolean growing = false;
boolean drawPulse = false; // allows for pulse array to grow but not be drawn on screen
int pulseCount = 0; // add pulse every two
ArrayList<PulseMarker> multiPulses;

//size of spin pulses
//float pulseXBound;
//float pulseXBoundInc;
 
void setupMultiPulse() { 
 multiPulses = new ArrayList<PulseMarker>();
 
 pulseExDuration = 60000; //expand pulse over one minute  
 targetBoundX = columns/2; // set the target width for each half
 targetBoundY = rows/4; // set the target height for each half
 
 pulseExpandUnitX = pulseExDuration/targetBoundX; //how many millis between each x bound expansion
 pulseExpandUnitY = pulseExDuration/targetBoundY; //how many millis between each y bound expansion
 
 ctrPosLocY = PULSECTR.y;
}


void expandPulseBounds() {
 int pulseTimeElapsedX = msPassed - pulseIncTimeX;
 int pulseTimeElapsedY = msPassed - pulseIncTimeY;
 
 if (pulseTimeElapsedX > pulseExpandUnitX) {
   if (pulseBoundX <= targetBoundX+5) { // stop incrementing when all columns are in bounds. need to take into account pulse ctr shift
     pulseBoundX++;
   }
       
   pulseIncTimeX = msPassed;
 }
 
 if (pulseTimeElapsedY > pulseExpandUnitY) {
   if (pulseBoundY <= targetBoundY) {
     pulseBoundY++;
   }
   pulseIncTimeY = msPassed;
 } 
}

void noBoundExpansion() {
 pulseBoundX = 5;
 pulseBoundY= 5;
}

void drawMultiPulse(){
  //clear background 
  //fill(0);
  //rect(0, 0, width, height);
  //If pulse array is growing -- add on pulse
  if (growing == true) { 
  if (pulseSensor == 1 && beat == false) {
    beat = true;
    pulseCount++;
 
    // every two heart beat creates a circle
    if (pulseCount == 2) {
      pulseCount = 0;
      PVector pulseLoc = getPulseLocation();
      // check to make sure you have a bpm
      if (currentBpm > 0) { 
        //for (int i = 0; i < 40; i++) {
          //pulseLoc = getPulseLocation();
          multiPulses.add(new PulseMarker(pulseLoc));
        //} // use for debugging
      }
    }
  }
 
 if ( pulseSensor == 0 && beat == true ) {
   beat = false;
  }
 } //growing true
 
 //If pulse array is shrinking -- remove pulses in order they were drawn 
 if (growing == false) {
   if (removePulsesSet == false) {
     pulsesToRemove = multiPulses.size();  
     removePulseTime = msPassed;
     removeEachInc = pulsesToRemove / removeIncs;
     removePulsesSet = true;
     println(pulsesToRemove, removeEachInc);
   }
      
   if (msPassed > removePulseTime + removeRate) {
     if (multiPulses.size() > removeEachInc) { 
       for (int i = 0; i < removeEachInc; i++) {
         int pos = multiPulses.size() - 1;
         multiPulses.remove(pos);
       }
     } else if (multiPulses.size() > 0) {
      int pos = multiPulses.size() - 1;
      multiPulses.remove(pos);
    }  
   removePulseTime = msPassed;
 }
   
 } // growing false 
   
 // Draw pulse if true, otherwise, just keep count   
 if (drawPulse == true) {
   runMultiPulse();
 }

}


void runMultiPulse() {
  if (multiPulses.size() == 0) {
    return;
  }
  
  boolean allPulsesFaded = true;
    
  for (int i = 0; i < multiPulses.size(); i++) {
   
    if (fadePulsesUp == true) {
     multiPulses.get(i).fadeColorUp();
     
     //check if each pulse has finished fading
     if (multiPulses.get(i).getFadeStatus() == false) {
       allPulsesFaded = false;
     }
   }
    
   if (fadePulsesDown == true) {
     multiPulses.get(i).fadeColorDown();
     //check if each pulse has finished fading 
     if (multiPulses.get(i).getFadeStatus() == false) {
       allPulsesFaded = false;
     }
     
   }
   multiPulses.get(i).run();
  }
  
  if (fadePulsesUp == true && allPulsesFaded == true) {
    fadePulsesUp = false;
  }
  
  if (fadePulsesDown == true && allPulsesFaded == true) {
    drawPulse = false;
  }
  
    
}


PVector getPulseLocation() {
 PVector newPulseLoc;
 newPulseLoc = hardXandY(pulseBoundX, pulseBoundY);
 //newPulseLoc = getCenterPulse();
 return newPulseLoc;
}


PVector getCenterPulse() {
  PVector newLoc = new PVector();

  newLoc.x = PULSECTR.x;
  newLoc.y = ctrPosLocY;
  ctrPosLocY += pulseRectHeight;
  println(ctrPosLocY);
  //int yUpOrDown = floor(random(0,2)); // get a 0 or 1
  
  return newLoc;
  
}


PVector hardXandY(int xBound, int yBound) {
 PVector newLoc = new PVector();
  
 // choose x
 int xLine = floor(random(-xBound, xBound));
 float scaleUpXLine = resolution * xLine; // get amount of width to scale by
 newLoc.x = PULSECTR.x + scaleUpXLine;
    
 // choose y
 int yLine = floor(random(-yBound, yBound));
 float scaleUpYLine = resolution * yLine; // get amount of width to scale by
 newLoc.y = PULSECTR.y + scaleUpYLine;
 
 return newLoc; 
}

PVector hardXorY(int xBound, int yBound) {
  PVector newLoc = new PVector();
  
  int xOrY = floor(random(2));
  if (xOrY == 0) {
   // choose a line  
   int xLine = floor(random(-xBound, xBound));
   float scaleUpXLine = resolution * xLine; // get amount of width to scale by
   newLoc.x = PULSECTR.x + scaleUpXLine;
   newLoc.y = random(0, height);
 }
 
 if (xOrY == 1) { 
   // choose a line 
   int yLine = floor(random(-yBound, yBound));
   float scaleUpYLine = resolution * yLine; // get amount of width to scale by
   newLoc.y = PULSECTR.y + scaleUpYLine;
   
   //float xVariant = pulseXBound1 * resolution;
   //float xOff = random(-xVariant, xVariant);
   //newX = newX + xOff;
   newLoc.x = random(0, width);
 }
 return newLoc; 
}






//////////////// END MULTI PULSE ////////////////