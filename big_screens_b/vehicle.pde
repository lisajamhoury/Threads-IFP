class Vehicle {
  PVector position;
  PVector acceleration;
  PVector velocity;
  float r;
  float maxspeed;
  float maxforce;
  float lifespan = 5;
  float vBright; 
  //color clr;
  float lineStk = 0.0000004 * AREA;
  ArrayList<PVector> prevPositions;
  boolean wrapping = false;
  String vLogic;
  int vEmgState;
  
  

  PVector prevPos;

  Vehicle(String iLogic, float iBright, int state, float x, float y, float ms, float mf) {
    position = new PVector(x, y);
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    r = 4;
    maxspeed = ms;
    maxforce = mf;
    vBright = iBright;
    vLogic = iLogic;
    vEmgState = state;
    //clr = iClr;

    prevPositions = new ArrayList<PVector>();  
    prevPos = position.copy();
  }

  void run() {
    update();
    borders();
    display();
  }

  void follow(FlowField flow) {
    PVector desired = flow.lookup(position);
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void update() {
    //v1Start = position;
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
    lifespan -= 0.1;

    prevPos = position.copy();
    prevPositions.add(prevPos);

    // check if there's more than one vertex in the vehicle & that wrapping is false
    if (prevPositions.size() > 1 && wrapping == false) {
      //check to see if vehicle is wrapping  
      int prevPosSize = prevPositions.size(); 
      PVector point1 = prevPositions.get(prevPosSize-1);
      PVector point2 = prevPositions.get(prevPosSize-2);
      float diff = abs(point1.y-point2.y);
      //if wrapping set wrapping true
      if (diff > height/2) {
        wrapping = true;
      }
    }
  }

  void borders() {
    if (position.x < -r) {
      position.x = width+r;
    }
    if (position.y < -r) { 
      position.y = height+r;
    }
    if (position.x > width+r) {
      position.x = -r;
    }
    if (position.y > height+r) { 
      position.y = -r;
    }
  }

   void fadeColorDown() {
   if (vBright >= 0) {
     //fadeComplete = false;
     vBright-=5;
    } else {
     //fadeComplete = true;
     //drawMarker = false;
    }
  }
  


  void display() {
    //float theta = velocity.heading() + PI/2;
    colorMode(HSB); // Change color for brightness
   
    if (vEmgState == 1) {
      //only draw flow lines
      justFlow();
    }
   
    if (vEmgState == 2) {
      // draw flow and draw wrapping lines if both sensors are high;
      flowAndHighWrapping();
    }
    
    if (vEmgState == 3) {
      flowAndWrapping();
    }
    
    // DOESN'T CURRENTLY INCLUDE SENSOR DATA -- add data as speed!
    if (vEmgState == 4) {
     allWhite(); 
    }
    
    if (vEmgState == 5) {
     justLinesGray();
    }
    
    if (vEmgState == 6) {
     justLinesWhite();
    }
    
    // using this now to draw triangle
    //if (vEmgState == 6) {
    // justLines();
    //}

    // fade all out
    if (vEmgState == 7) {
      fadeColorDown();
      justFlow();
    }
    
    // All go black   
    if (vEmgState == 8) {
      stroke(0, 0, 0, 0);
      fill(0, 0, 0, 0);
    }

    //strokeWeight(lineStk);
    strokeWeight(lineStk);
    beginShape();

    for (int i=0; i<prevPositions.size(); i++) {
      PVector point = prevPositions.get(i); 
      vertex(point.x, point.y);
      //line(pos.x, pos.y, prevPos.x, prevPos.y);
    }
    endShape();
    colorMode(RGB); // Reset color mode
  }

  void justFlow() {
    if (wrapping == true) {
      stroke(0, 0, 0);
      //fill(0, 0, 0);
      noFill();
    } else {
      stroke(0, 0, vBright);
      //fill(0, 0, vBright);
      noFill();
    }
  }

  void flowAndHighWrapping() {
    if (wrapping == true && vLogic == "high") {
      //println("true");
      stroke(0, 0, vBright);
      fill(0, 0, vBright);
    } else if (wrapping == false) {
      stroke(0, 0, vBright);
      fill(0, 0, vBright);
    } else {
      stroke(0, 0, 0);
      fill(0, 0, 0);
    }
  }
  
  void flowAndWrapping() {
    stroke(0, 0, vBright);
    fill(0, 0, vBright);
  }

  void allWhite() {
    stroke(0, 0, 255);
    fill(0, 0, 255);
  }

  void justLinesGray() {
    if (wrapping == true) {
      stroke(0, 0, vBright);
      fill(0, 0, vBright);
    } else {
      stroke(0, 0, 0);
      fill(0, 0, 0);
    }
  }
  
  void justLinesWhite() {
    if (wrapping == true) {
      stroke(0, 0, 255);
      fill(0, 0, 255);
    } else {
      stroke(0, 0, 0);
      fill(0, 0, 0);
    }
  }

  boolean isDead() {
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }
}