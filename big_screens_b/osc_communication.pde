//import oscP5.*;
//import netP5.*;
 
//config
//int listeningPort = 6001;  

//variables for receiving data
//int polar0;
//int emg1L, emg1R, emg2L, emg2R;

//variables for osc communication
//OscP5 oscP5;
//NetAddress host;
//float pct;

//void setupOsc() {
//  oscP5 = new OscP5(this, listeningPort);
//}

/* incoming osc message are forwarded to the oscEvent method. */
//void oscEvent(OscMessage theOscMessage) {

//  // parse incoming data
//  if (theOscMessage.checkAddrPattern("/polar")) {
//    polar0 = theOscMessage.get(0).intValue();
//  } else if (theOscMessage.checkAddrPattern("/emg1")) {
//    emg1L = theOscMessage.get(0).intValue();
//    emg1R = theOscMessage.get(1).intValue();
//  } else if (theOscMessage.checkAddrPattern("/emg2")) {
//    emg2L = theOscMessage.get(0).intValue();
//    emg2R = theOscMessage.get(1).intValue();
//  } else if (theOscMessage.checkAddrPattern("/key")) {
//    int inKey = theOscMessage.get(0).intValue();
//    //change incoming key press from ascii to char
//    char inKeyChar = char(inKey);
//    processControls(inKeyChar);
//  }
  
//  //print the data
//  //println("polar: " + polar0);
//  //println("emg1: " + emg1L + ", " + emg1R);
//  //println("emg2: " + emg2L + ", " + emg2R);
  
//  //print incoming key code
//  //println(inKey);
//  //println(char(inKey));
//}