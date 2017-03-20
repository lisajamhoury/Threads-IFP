boolean emg1 = false;
boolean emg2 = false;
boolean emg3 = false;
boolean emg4 = false;
boolean emg5 = false;
boolean emg6 = false;
boolean emg7 = false;
boolean emg8 = false;
boolean triangle = false;
boolean fakeTriangle = false;
boolean pulse1 = false;
boolean pulse2 = false;
boolean pulse3 = false; 

boolean fadePulsesUp = false;
boolean fadePulsesDown = false;

boolean pulseTimerStarted = false;

boolean sloMo = false;
float currentMinSpeed = 0;

void keyPressed() {
  println("yes");
  char inKeyChar = key;
  processControls(inKeyChar);
}


void generateKeyPress() {
  //0:00
  if (frameCount == 1) processControls('7'); // pulse on
  //0:08
  if (frameCount == 480) processControls('1'); // emg on
  //0:35
  if (frameCount == 2100) { 
    processControls('3');
    processControls('8'); // hide pulse
  }
  //1:10
  if (frameCount == 4200) processControls('4');
  //1:27
  if (frameCount == 5220) processControls('5');
  //1:44
  if (frameCount == 6240) {
    processControls('6');
    processControls('t');
    //fakeTriangle = true;
    EMG1UPPER = 150; // reset high for performer!!
    EMG2UPPER = 150; // reset high for performer!!
    minSpeed = 0.0000004; //abritrary speed up
    
  }
  //2:19
  if (frameCount == 8340) { 
    processControls('5');
    minSpeed = 0.00000007; //slow back down
  }  
  //2:28
  if (frameCount == 8880) {
    processControls('4');
    processControls('y');
    //fakeTriangle = false;
    EMG1UPPER = 500; // reset high for performer!!
    EMG2UPPER = 500; // reset high for performer!!
  }
  //2:36
  if (frameCount == 9360) processControls('3');
  //2:41
  if (frameCount == 9660) processControls('1');
  //2:45
  if (frameCount == 9900) {
    processControls('0');
    processControls('9');
  }
  //2:54 
  if (frameCount == 10440) processControls('o');
  //3:03
  //if (frameCount == 10980) processControls('o');

}
  

void processControls(char inKeyChar) {
  if (inKeyChar == '1') {
    if (emg1 == false) {
      emg1 = true; 
      emg2 = false;
      emg3 = false;
      emg4 = false;
      emg5 = false; 
      emg6 = false;
      return;
    }
  }

  if (inKeyChar == '2') {
    if (emg2 == false) {
      emg1 = false; 
      emg2 = true;
      emg3 = false;
      emg4 = false;
      emg5 = false;
      emg6 = false;
      return;
    }
  }

  if (inKeyChar == '3') {
    if (emg3 == false) {
      emg1 = false; 
      emg2 = false;
      emg3 = true;
      emg4 = false;
      emg5 = false;
      emg6 = false;
      return;
    }
  }

  if (inKeyChar == '4') {
    if (emg4 == false) {
      emg1 = false; 
      emg2 = false;
      emg3 = false;
      emg4 = true;
      emg5 = false;
      emg6 = false;
      return;
    }

  }

  if (inKeyChar == '5') {
    if (emg5 == false) {
      emg1 = false;
      emg2 = false;
      emg3 = false;
      emg4 = false;
      emg5 = true; 
      emg6 = false;
      return;
    }
  }
  
  if (inKeyChar == '6') {
   if (emg6 == false) {
      emg1 = false;
      emg2 = false;
      emg3 = false;
      emg4 = false;
      emg5 = false; 
      emg6 = true; 
      return;
    }
  }

  if (inKeyChar == 't') {
    if (triangle == false) {
      triangle = true; 
    }
    
  }
  
  if (inKeyChar == 'y') {
    if (triangle == true) {
     triangle = false; 
    return;
    } 
  }
  
  
  // fade out emg
  if (inKeyChar == '0') {
    emg1 = false;
    emg2 = false;
    emg3 = false;
    emg4 = false;
    emg5 = false;
    emg6 = false;
    emg7 = true;
  }
  
  // turn off emg entirely
  if (inKeyChar == 'o') {
    emg1 = false;
    emg2 = false;
    emg3 = false;
    emg4 = false;
    emg5 = false;
    emg6 = false;
    emg7 = false;
    emg8 = true;
  }  

  // show hide pulse -- growing
  if (inKeyChar == '7') {
    pulse1 = true;
    pulse2 = false;
    pulse3 = false;
  }
  
  if (inKeyChar == '8') {
    pulse1 = false;
    pulse2 = true;
    pulse3 = false; 
  }

  // animate 
  //if (key == '8') { 
  //  if (animate == false) {
  //    animate = true; 
  //    return;
  //  }
  //  if (animate == true) {
  //    animate = false; 
  //    return;
  //  }
  //}

  // stop from growing / toggle growing/shrinking pulse
  if (inKeyChar == '9') {
    pulse1 = false;
    pulse2 = false;
    pulse3 = true;
    
  }

  //increase vehicle speed
  if (inKeyChar == 'p') {
    println("going up", minSpeed);
    minSpeed+= 0.00000001;
  }

  //decrease vehicle speed
  if (inKeyChar == 'l') {
    if (minSpeed > 0.00000001) { // never go below zero
      println("above", minSpeed);
      minSpeed-= 0.00000001;
    } else { 
      println("below", minSpeed);
    }
  }
  
  //slow mo on
  if (inKeyChar == 's') {
    if (sloMo == false) {
      currentMinSpeed = minSpeed;
      sloMo = true;
     }
     minSpeed = 0.0; // slow mo 
    } // return the min speed to the prev speed 
  
  // reset emg vehicle speed after slomo 
  if (inKeyChar == 'd') {
   if (sloMo == true) {
     sloMo = false;
     minSpeed = currentMinSpeed;
   }
 }
  
}


void runControls() {

  // TO DO -- ADD LABELS TO THESE
  if (emg1 == true) {
    //background(0);
    drawEmgVehicles();
    emgRunning = true;
    emgState = 1;
  }
  if (emg2 == true) {
    //background(0);
    drawEmgVehicles();
    emgRunning = true;
    emgState = 2;
  }
  if (emg3 == true) {
    //background(0);
    drawEmgVehicles();
    emgRunning = true;
    emgState = 3;
  }
  if (emg4 == true) {
    //background(0);
    drawEmgVehicles();
    emgRunning = true;
    emgState = 4;
  }
  if (emg5 == true) {
    //background(0);
    drawEmgVehicles();
    emgRunning = true;
    emgState = 5;
  }
  
   if (emg6 == true) {
    //background(0);
    drawEmgVehicles();
    emgRunning = true;
    emgState = 6;
  }

  if (triangle == true) {
    drawBigTriangle();
  }
  
  if (emg7 == true) {
    drawEmgVehicles();
    emgRunning = true;
    emgState = 7;
  }
  
  if (emg8 == true) {
    drawEmgVehicles();
    emgRunning = true;
    emgState = 8;    
  }

  // start pulses, draw pulses
  if (pulse1 == true) {
    if (fadePulsesDown == true) {
      fadePulsesUp = true;
      fadePulsesDown = false;
    }
    
    drawPulse = true;
    
    // if there's a bpm and it's not growing, 
    // start the bpm timer, start growing and start expanding bounds on screen, and drawpulse  
    if (currentBpm > 10 || pulseTimerStarted == true) {
      if (!growing) {
        //begin timer
        pulseTimerStarted = true;
        println("timer started");
        pulseStartTime = msPassed; // replace millis with fake millis
        pulseIncTimeX = pulseStartTime;
        pulseIncTimeY = pulseStartTime;
      }
      growing = true;

      expandPulseBounds();

      drawMultiPulse();
    } else {
      // debugging 
      println("nope", currentBpm);
    }
  }

  // hide pulses
  if (pulse2 == true) {
    fadePulsesDown = true;
    growing = true;
    expandPulseBounds();
    drawMultiPulse();
  }

  // remove pulses 
  if (pulse3 == true) {
    if (fadePulsesDown == true) {
      fadePulsesUp = true;
      fadePulsesDown = false;
    }
    
    growing = false;
    drawPulse = true;
    //if (currentBpm > 10) {
    

    expandPulseBounds();
      //noBoundExpansion();

    drawMultiPulse();
    //}
  }
  

  
} // Close run controls


  //boolean toggleKey(boolean scene) {
  //  println("THERE");
  //  boolean newScene = scene;
  //  if (scene == false) {
  //    println("it's false");
  //    newScene = true; 
  //  } else if (scene == true) {
  //    println("it's true");
  //    println("it's true");
  //    newScene = false; 
  //  }
  //  scene = newScene;
  //  return scene;
  //}