void setup() {
  size(9024, 800, P3D); // ifp resolution
  //size(5000, 443, P3D); // my display ifp res
  //size(11520, 1080, P3D);
  //size(5760, 540, P3D);
  //size(5000, 469, P3D); // my display
  //fullScreen(P3D);
  //size(2880, 270, P3D);
  //size(3840,360, P3D);
  //size(1920, 180, P3D); //Aaron's projector 
  //size(1440, 135, P3D);
  //surface.setLocation(0,0);
  
  //frameRate(fps); // global set in csv_data
  
  background(0);
  smooth(4);
  noCursor();
  
  //setupOsc();
  setupGlobals();
  csvSetup();
  setupProcessData();
  setupDrawSensors(); // collected in draw emg
}

void draw() {
  background(0);
  getCsvData();
  getSensorData();
  generateKeyPress();
  runControls();
  
  if (fakeTriangle) {
    int randNum = round(random(100));
    println(randNum);
    drawFakeTriangle(randNum); 
  }

  if (frameCount <= 11220) {
    if (frameCount%2 == 0) {
      //println("saving");
      String savePath = "/Volumes/Gibson/Lisa/threads/threads-######.png";
      //String savePath = "threads/threads-######.png";
      saveFrame(savePath);
    }
  } else {
    println("done saving");
  }
  //if (debugFlowField == true) {
  //  debugFlowField();
  //}
  //if (debugFrameRate == true) {
  //  debugFrameRate();
  //}

}