
color white = color(256, 256, 256);
color red = color(256, 0,  0);
color grey = color(196, 196,  196);
int w = 30;
int h = 30;
int sat = 70;
int bri = 100;
int tr = 255;
int steps;

int[][] sudokul1n1 = {   {0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {6, 7, 1, 0, 0, 0, 9, 0, 0},
                         {2, 8, 9, 0, 0, 0, 0, 0, 0},
                         {0, 4, 0, 0, 0, 2, 0, 0, 0},
                         {0, 0, 0, 5, 0, 0, 3, 0, 0},
                         {8, 0, 3, 0, 0, 9, 4, 0, 0},
                         {9, 2, 4, 8, 0, 1, 5, 7, 3}, // 6 4 6
                         {1, 5, 0, 7, 0, 4, 6, 0, 2},
                         {3, 6, 7, 9, 0, 0, 8, 0, 1}  };
                    
int[][] sudokul3n1 = {   {1, 0, 0, 2, 0, 0, 0, 0, 7},
                         {3, 0, 0, 0, 0, 8, 9, 1, 6},
                         {0, 6, 0, 0, 1, 0, 0, 3, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 3, 0, 0, 0, 9, 0, 8, 5},
                         {0, 0, 0, 6, 3, 7, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 1},
                         {0, 0, 0, 4, 8, 0, 0, 6, 0},
                         {0, 1, 0, 0, 2, 6, 8, 4, 3}  };
                    

int[][] sudokul5n1 = {   {0, 0, 0, 0, 0, 3, 0, 0, 0},
                         {0, 3, 0, 0, 5, 0, 0, 2, 4},
                         {0, 0, 8, 0, 0, 6, 9, 0, 0},
                         {0, 6, 5, 0, 8, 0, 0, 0, 1},
                         {0, 2, 0, 0, 6, 5, 7, 0, 0},
                         {0, 4, 0, 7, 0, 0, 0, 0, 6},
                         {0, 0, 1, 0, 0, 9, 6, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 3, 8}  };
                    
int[][][] candidates = new int[9][9][9];
int[][] selectedGrid = sudokul3n1;


void setup() {
  initCandidates(selectedGrid);
  
  size(360, 360);
  background(white);
  colorMode(HSB, 9, 100, 100);
  pushMatrix();
  //stroke(grey);
  noStroke();
  translate(50, 50);
  drawGrid(selectedGrid);
  popMatrix();
}

void initCandidates(int [][] grid) {
  for(int l=0; l<9; l++) {
    for(int c=0; c<9; c++) {
      initCandidatesForCell(l,c);
    }
  }
  for(int l=0; l<9; l++) {
    for(int c=0; c<9; c++) {
      int val = grid[l][c];
      // already defined
      if (val > 0) {
        //logForCell(l, c, "initializing ...");
        removeCandidatesForLineAndValue(l, val);    
        removeCandidatesForColumnAndValue(c, val);    
        removeCandidatesForSquareAndValue(l, c, val);    
        setCandidatesForCellAndValue(l, c, val);
      } 
      logValuesForCell(l, c, grid);
    }
  }  
}  

void initCandidatesForCell(int l, int c) {
  for (int v=0; v<9; v++) {
    candidates[l][c][v] = 1;
  }  
}  

void setCandidatesForCellAndValue(int l, int c, int val) {
  for (int v=0; v<9; v++) {
    candidates[l][c][v] = 0;
  }  
  candidates[l][c][val-1] = 1;
  //logForCell(l, c, "setting val " + val); 
}

void removeCandidatesForLineAndValue(int l, int val) {
  for (int c=0; c<9; c++) {
    //logForCell(l, c, "removing val " + val); 
    candidates[l][c][val-1] = 0;
  }  
}

void removeCandidatesForColumnAndValue(int c, int val) {
  for (int l=0; l<9; l++) {
    //logForCell(l, c, "removing val " + val); 
    candidates[l][c][val-1] = 0;
  }  
}

void removeCandidatesForSquareAndValue(int l, int c, int val) {
  int sl = l/3;
  int sc = c/3;
  for (int il=0; il<3; il++) {
    for (int ic=0; ic<3; ic++) {
      int al = sl*3 + il;
      int ac = sc*3 + ic;
      //logForCell(al, ac, "removing val " + val); 
      candidates[al][ac][val-1] = 0;
    }
  }
}

void draw() {
 
  pushMatrix();
  noStroke();
  translate(50, 50);
  int cell = resolve(selectedGrid);
  println("received " + cell);
  if (cell>=0) {
     int l = cell/81;
     int c = (cell - (l*81))/9;
     int val = cell - (l*81) - (c*9) + 1;
     logForCell(l,c,"received val " + val);
     if (val > 0) {
       selectedGrid[l][c] = val;
       removeCandidatesForLineAndValue(l, val);    
       removeCandidatesForColumnAndValue(c, val);    
       removeCandidatesForSquareAndValue(l, c, val);    
       setCandidatesForCellAndValue(l, c, val);
       //drawCell(l, c, val);
       drawLine(l, selectedGrid);
       drawColumn(c, selectedGrid);
       drawSquare(l, c, selectedGrid);
     }  
  } else {
    noLoop();
  } 
  popMatrix();
  
  if (steps>100) {
    noLoop();
  }
  steps++;
}

int resolve(int[][] grid){
  println("Resolving ... =================");
  //int l = 6; // base 0
  //int c = 4; // base 0
  //int v = 6; // base 1
  int c = 9;
  int l = 9;
  int val = -1;
  while (val<=0 && l>0) {
    l--;
    c = 9;
    while (val<=0 && c>0) {
      c--;
      int ev = grid[l][c];
      logValuesForCell(l, c, grid);
      if (ev < 1) {
        val = lookupLastCandidate(l,c);
        if (val < 1) {
          val = lookupUniqueCandidateForLine(l, grid);
        } 
        if (val < 1) {
          val = lookupUniqueCandidateForColumn(c, grid);
        } 
        if (val < 1) {
          val = lookupUniqueCandidateForSquare(l, c, grid);
        }  
      } else {
        //logForCell(l,c,"is resolved");
      }  
    }  
  }  
  logForCell(l,c,"resolved val " + val);
  return val-1 + (c*9) + (l*81);
}


void drawGrid(int[][] grid) {
  for(int c=0; c<9; c++) {
    for(int l=0; l<9; l++) {
      int val = grid[l][c];
      drawCell(l, c, val);
    }
  }
}

void drawLine(int l, int[][] grid) {
  for(int c=0; c<9; c++) {
    int val = grid[l][c];
    drawCell(l, c, val);
  }
}

void drawColumn(int c, int[][] grid) {
  for(int l=0; l<9; l++) {
    int val = grid[l][c];
    drawCell(l, c, val);
  }
}

void drawSquare(int l, int c, int[][] grid) {
  int sl = l/3;
  int sc = c/3;
  for (int il=0; il<3; il++) {
    for (int ic=0; ic<3; ic++) {
      int al = sl*3 + il;
      int ac = sc*3 + ic;
      int val = grid[al][ac];
      drawCell(al, ac, val);
    }
  }
}

void drawCell(int l, int c, int val) {
    if (val>0) {
      drawCellRect(val-1, c*w, l*h, tr);
    } else {
      int cellTr = tr/getNumberOfCandidates(l,c)/8;
      for (int v=0; v<9; v++) {
        if ( candidates[l][c][v] > 0) {
          //drawCellRect(v, c*w, l*h, cellTr); 
          drawCellMozaic(l, c, v);
        }  
      }  
    }
}

void drawCellRect(int hue, int x, int y, int tr) {
  fill(hue, sat, bri, tr);
  rect(x, y, w, h);  
}

void drawCellMozaic(int l, int c, int v) {
  fill(v, sat, bri, tr/2);
  int il = v/3;
  int ic = v%3;
  int x = c*w + ic*w/3;
  int y = l*h + il*h/3;
  rect(x, y, w/3, h/3);  
}


 

int getNumberOfCandidates(int l, int c) {
  int nbCandidates = 0;
  for (int v=0; v<9; v++) {
    nbCandidates += candidates[l][c][v];
  }  
  return nbCandidates;
}  

int lookupLastCandidate(int l, int c) {
    logForCell(l, c, "Looking up last candidate ...");
    int val = 0;
    int nbCandidates = getNumberOfCandidates(l,c);
    //println("nb candidates " + nbCandidates + " l=" + l + " c=" +c);
    if (nbCandidates == 1) {
      for (int v=0; v<9; v++) {
        if ( candidates[l][c][v] > 0) {
          val = v+1;
          logForCell(l, c, "Found last candidate -> val=" + val);
        }  
      }          
    }
    return val; //TODO baser sur count et somme 
}  


int lookupUniqueCandidateForLine(int l, int[][] grid) {
    int sumVal = 0;
    int nbResolvedCells = 0;
    int val = 0;
    for (int c=0; c<9; c++) {
      val = grid[l][c];
      nbResolvedCells += (val>0?1:0); 
      sumVal += val;      
    }
    if (nbResolvedCells < 8) {
      val = 0;
    } else {
      val = 45 - sumVal;
      logForLine(l, "Found unique candidate for line -> val=" + val);
    }  
    return val;
}  

int lookupUniqueCandidateForColumn(int c, int[][] grid) {
    logForColumn(c, "Looking up unique candidate for column ...");
    int sumVal = 0;
    int nbResolvedCells = 0;
    int val = 0;
    for (int l=0; l<9; l++) {
      val = grid[l][c];
      nbResolvedCells += (val>0?1:0); 
      sumVal += val;      
    }
    if (nbResolvedCells < 8) {
      val = 0;
    } else {
      val = 45 - sumVal;
      logForColumn(c, "Found unique candidate for column -> val=" + val);
    }  
    return val;
}  

int lookupUniqueCandidateForSquare(int l, int c, int[][] grid) {
    logForCell(l, c, "Looking up unique candidate for square ...");
    int sumVal = 0;
    int nbResolvedCells = 0;
    int val = 0;
    
    int sl = l/3;
    int sc = c/3;
    logForCell(l, c, "square " + sl + "." + sc);
    for (int il=0; il<3; il++) {
      for (int ic=0; ic<3; ic++) {
        int al = sl*3 + il;
        int ac = sc*3 + ic;
        val = grid[al][ac];
        logForCell(l, c, "square " + al + "," + ac + " val=" + val);
        nbResolvedCells += (val>0?1:0); 
        sumVal += val;      
      }
    }
      
    if (nbResolvedCells < 8) {
      val = 0;
    } else {
      val = 45 - sumVal;
      logForCell(l, c, "Found unique candidate for square -> val=" + val);
    }  
    return val;
}  


void logForLine(int l, String message) {
  println("Line " + l + ",- " + message);
}  
void logForColumn(int l, String message) {
  println("Col  -," + l + " " + message);
}  
void logForCell(int l, int c, String message) {
  println("Cell " + l + "," + c + " " + message);
}  
void logValuesForCell(int l, int c, int[][]grid) {
  print("Cell " + l + "," + c + " solved " + grid[l][c] + " candidates " );
  for (int v=0; v<9; v++) {
    int b = candidates[l][c][v]; 
    print(b + " ");
  }
  println(" ");
}  
