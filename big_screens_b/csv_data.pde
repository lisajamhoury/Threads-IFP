Table table;

int rowCount;
int rowIndex;
int startRow = 16501;
int endRow = 20281;
int msPerS = 1000;
float fps = 60;
float msPerFrame = msPerS/fps;
int msPassed = 0;
float dataRate = 86;
int currentDataFrame = 0;
//float fakeMillis = 0;

//int time = 0;

//variables for receiving data
int polar0;
int emg1L, emg1R, emg2L, emg2R;

void csvSetup() {
  table = loadTable("data/osc_dancers20161121_third.csv", "header");  
  rowCount = table.getRowCount();
  
  rowIndex = startRow;
}

//void keepFakeTime() {
  
//}

void getCsvData() {
  //println("getting data", rowIndex);
  msPassed = round(msPerFrame * frameCount);
  int newDataFrame = round(msPassed/dataRate);
  //println(newDataFrame, currentDataFrame);
  
  if (newDataFrame > currentDataFrame) {
    //println("yes");
    currentDataFrame = newDataFrame;
    rowIndex++;
    
    if (rowIndex > endRow) {
      rowIndex = startRow;
    }
      
    TableRow row = table.getRow(rowIndex);
    polar0 = row.getInt("pulse");
    emg1L = row.getInt("emg1l");
    emg1R = row.getInt("emg1r");
    emg2L = row.getInt("emg2l");
    emg2R = row.getInt("emg2r");

  }
 
       //  //print the data
  //println("polar: " + polar0);
  //println("emg1: " + emg1L + ", " + emg1R);
  //println("emg2: " + emg2L + ", " + emg2R);
    

}