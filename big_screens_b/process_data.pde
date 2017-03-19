//variables for manipulating data
// TO DO REFACTOR -- floats become ints for sensor data
int pulseSensor = 0;
float emg1LeftSensor = 0;
float emg1RightSensor = 0;
float emg2LeftSensor = 0;
float emg2RightSensor = 0;

//Constants for mapping data 
int EMG1LOWER = 10;
int EMG1UPPER = 500; // reset high for performer!!
int EMG2LOWER = 10;
int EMG2UPPER = 500; // reset high for performer!!

int LOWBPM = 30; // reset for perfomer!!
int HIGHBPM = 120; // reset for perfomer!!

//Pulse bpm timing
int pulseTimeCtr; // count time elapsed since last calculation
int pulseCtr = 0; // count number of pulses
int BPMTIMESPAN = 5000; // take bpm every 5 seconds 
int ONEMINUTE = 60000;
int lastPulseSensorVal;
int currentBpm;

//pulse vairables
boolean pulse = false;

void setupProcessData() {
  pulseTimeCtr = millis();
}

void getSensorData() { 
 emg1LeftSensor = mapEmgData(emg1L, EMG1LOWER, EMG1UPPER);
 emg1RightSensor = mapEmgData(emg1R, EMG1LOWER, EMG1UPPER);
 emg2LeftSensor = mapEmgData(emg2L, EMG2LOWER, EMG2UPPER); 
 emg2RightSensor = mapEmgData(emg2R, EMG2LOWER, EMG2UPPER);
 
 //IF RUNNING OFF OF FAKE DATA SWITCH SENSOR SIDES
 //emg2LeftSensor = mapEmgData(emg1L, EMG1LOWER, EMG1UPPER);
 //emg2RightSensor = mapEmgData(emg1R, EMG1LOWER, EMG1UPPER);
 //emg1LeftSensor = mapEmgData(emg2L, EMG2LOWER, EMG2UPPER); 
 //emg1RightSensor = mapEmgData(emg2R, EMG2LOWER, EMG2UPPER);
 pulseSensor = polar0;
 
 calculateBpm();
 
}

float mapEmgData(float sensorReading, int lowerBound, int upperBound) {
  if (sensorReading < lowerBound) {
    sensorReading = lowerBound;
  }
  
  if (sensorReading > upperBound) {
    sensorReading = upperBound;
  }
  
  sensorReading = map(sensorReading, lowerBound, upperBound, 0, 1000);
  return sensorReading;   
}


void calculateBpm() {
 int timeElapsed = millis() - pulseTimeCtr; 

 if (pulseSensor == 1 && lastPulseSensorVal == 0) {
   pulseCtr++;
 }
  
 if (timeElapsed > BPMTIMESPAN) {
  currentBpm = (ONEMINUTE/BPMTIMESPAN)*pulseCtr; 
  currentBpm = limitBpm(currentBpm, LOWBPM, HIGHBPM);
  pulseTimeCtr = millis();
  pulseCtr = 0;
 }
 lastPulseSensorVal = pulseSensor;
}

// Keep bpm within range so all are drawn
int limitBpm(int bpm, int lowerBound, int upperBound) {
  if (bpm < lowerBound) {
    bpm = lowerBound;
  }
  
  if (bpm > upperBound) {
    bpm = upperBound;
  }
  
  return bpm;  
}




// Get logic from left and right emg sensors
String emgLogic(float leftSensor, float rightSensor) {
  String status = "neutral";
    
  if (leftSensor > 900 && rightSensor > 900) { // 950 instead of 900?
    status = "high";
  } else if (leftSensor > 900) {
    status = "left high";
  } else if (rightSensor > 900) { 
    status = "right high";
  } else if (leftSensor < 90 && rightSensor < 90) { // was 300
    status = "low";
  } else if (abs(leftSensor - rightSensor) <=100) {
    status = "close";
  } 
 
 return status;
}