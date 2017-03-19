class Magnet {
  PVector posPos;
  PVector posNeg;
  float sz;
  
  Magnet(PVector iPosPos, PVector iPosNeg) {
    posPos = iPosPos.copy();
    posNeg = iPosNeg.copy();
    sz = PVector.sub(posPos, posNeg).mag();;    
  }

  void display() {
    fill(255);
    noStroke();
    //ellipse(posNeg.x + (sz/2),posNeg.y, sz, sz);
  } 
}